#!/usr/bin/env python3
"""Test deployment in a disposable HOME."""

import importlib.util
import os
import subprocess
import sys
import tempfile
from pathlib import Path

sys.dont_write_bytecode = True

script_dir = Path(__file__).resolve().parent
manager_path = script_dir / "manage-macos.py"

spec = importlib.util.spec_from_file_location(
    "macsetup_manager",
    manager_path,
)

manager = importlib.util.module_from_spec(spec)
spec.loader.exec_module(manager)


def run(repo, home, *arguments, expected=0):
    environment = os.environ.copy()

    environment.update({
        "DOTFILES_TEST_MODE": "1",
        "DOTFILES_TEST_HOME": str(home),
        "DOTFILES_TEST_REPO": str(repo),
    })

    result = subprocess.run(
        [sys.executable, str(manager_path), *arguments],
        text=True,
        capture_output=True,
        env=environment,
        check=False,
    )

    if result.returncode != expected:
        raise AssertionError(
            f"{arguments}: expected {expected}, "
            f"received {result.returncode}\n"
            f"{result.stdout}\n{result.stderr}"
        )

    return result.stdout


def main():
    with tempfile.TemporaryDirectory(
        prefix="macsetup-v2-test-"
    ) as temporary:
        root = Path(temporary)
        home = root / "home"
        repo = root / "repo"

        home.mkdir()
        repo.mkdir()

        originals = {}

        # Construct a disposable copy of all 16 targets.
        for index, (name, src_name, dst_name) in enumerate(
            manager.MANIFEST
        ):
            source = repo / src_name
            target = home / dst_name

            source.parent.mkdir(
                parents=True,
                exist_ok=True,
            )
            target.parent.mkdir(
                parents=True,
                exist_ok=True,
            )

            if name == "Neovim":
                source.mkdir()
                (source / "init.lua").write_text(
                    "print('Neovim')\n"
                )
            else:
                source.write_text(
                    f"config {name}\n"
                )

            if index < 5:
                target.symlink_to(
                    source,
                    target_is_directory=source.is_dir(),
                )

            elif name == "dothelp":
                pass

            elif name == "SketchyBar":
                target.write_text(
                    "previous configuration\n"
                )
                originals[name] = target.read_bytes()

            else:
                target.write_bytes(source.read_bytes())
                originals[name] = target.read_bytes()

        # Confirm unrelated files survive the migration.
        unrelated = (
            home
            / ".config/sketchybar/plugins/old-backup.sh"
        )
        unrelated.write_text("untouched\n")

        plan = run(repo, home, "plan")
        assert "DIFFERENT_COPY" in plan
        assert "MATCHING_COPY" in plan

        # Different files require explicit authorisation.
        run(repo, home, "apply", "--yes", expected=2)

        assert not (
            home / ".dotfiles-backup"
        ).exists()

        output = run(
            repo,
            home,
            "apply",
            "--yes",
            "--replace-different",
        )

        assert "APPLY COMPLETE" in output
        assert "VERIFY: PASS" in run(
            repo,
            home,
            "verify",
        )

        assert unrelated.read_text() == "untouched\n"

        # Repeated application must do nothing.
        output = run(repo, home, "apply", "--yes")
        assert "ALREADY MANAGED" in output

        # Simulate a user modifying a deployed target.
        conflict = home / ".aerospace.toml"
        source = repo / "config/aerospace/aerospace.toml"

        conflict.unlink()
        conflict.write_text("user edit after apply\n")

        run(
            repo,
            home,
            "rollback",
            "--yes",
            expected=1,
        )

        assert (
            conflict.read_text()
            == "user edit after apply\n"
        )

        assert (
            home / ".local/bin/dothelp"
        ).is_symlink()

        conflict.unlink()
        conflict.symlink_to(source)

        # Restore the original configuration.
        output = run(
            repo,
            home,
            "rollback",
            "--yes",
        )

        assert "ROLLBACK COMPLETE" in output

        # Validate restoration of every target.
        for index, (name, _, dst_name) in enumerate(
            manager.MANIFEST
        ):
            target = home / dst_name

            if index < 5:
                assert target.is_symlink(), name

            elif name == "dothelp":
                assert not target.exists(), name
                assert not target.is_symlink(), name

            else:
                assert target.is_file(), name
                assert not target.is_symlink(), name
                assert (
                    target.read_bytes()
                    == originals[name]
                ), name

        assert unrelated.read_text() == "untouched\n"

        run(
            repo,
            home,
            "rollback",
            "--yes",
            expected=2,
        )

        # Two unresolved transactions must never be
        # selected automatically by directory name.
        backup_root = home / ".dotfiles-backup" / "v2"

        for name in ("txn-z-older", "txn-a-newer"):
            transaction = backup_root / name
            transaction.mkdir()
            (transaction / "journal.json").write_text(
                '{"state":"applied","entries":[]}\\n',
                encoding="utf-8",
            )

        run(
            repo,
            home,
            "rollback",
            "--yes",
            expected=1,
        )

        run(
            repo,
            home,
            "apply",
            "--yes",
            "--replace-different",
            expected=1,
        )

        assert (
            home / ".aerospace.toml"
        ).read_bytes() == originals["AeroSpace"]

        print("PASS: Ambiguous transaction protection")

        # Verify deployment onto a completely empty HOME.
        clean_home = root / "clean-home"
        clean_home.mkdir()

        clean_plan = run(repo, clean_home, "plan")
        assert "MISSING: 16" in clean_plan

        run(repo, clean_home, "verify", expected=1)
        run(repo, clean_home, "apply", expected=2)

        fresh_apply = run(
            repo,
            clean_home,
            "apply",
            "--yes",
        )
        assert "APPLY COMPLETE" in fresh_apply

        assert "VERIFY: PASS" in run(
            repo,
            clean_home,
            "verify",
        )

        second_apply = run(
            repo,
            clean_home,
            "apply",
            "--yes",
        )
        assert "ALREADY MANAGED" in second_apply

        restored = run(
            repo,
            clean_home,
            "rollback",
            "--yes",
        )
        assert "ROLLBACK COMPLETE" in restored

        for _, _, destination in manager.MANIFEST:
            target = clean_home / destination
            assert not target.exists()
            assert not target.is_symlink()

        print("PASS: Clean-HOME installation")
        print("PASS: Clean-HOME idempotency")
        print("PASS: Clean-HOME rollback")

        print("PASS: Read-only planning")
        print("PASS: Different-file protection")
        print("PASS: Transactional apply")
        print("PASS: Deployment verification")
        print("PASS: Idempotent repeated apply")
        print("PASS: Rollback conflict detection")
        print("PASS: Exact original-content restoration")
        print("PASS: Unrelated files preserved")
        print("PASS: No remaining active transaction")


if __name__ == "__main__":
    main()
