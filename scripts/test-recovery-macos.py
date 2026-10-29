#!/usr/bin/env python3
"""Simulate clean-HOME deployment and rollback without live changes."""

import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path
from urllib.parse import unquote, urlsplit


REPO = Path(__file__).resolve().parent.parent
LINK_PATTERN = re.compile(r"(?<!!)\[[^\]]+\]\(([^)]+)\)")


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def check_document_links():
    """Check local Markdown links without making network requests."""
    documents = sorted((REPO / "docs").rglob("*.md"))
    documents.append(REPO / "README.md")

    checked = 0
    missing = []

    for document in documents:
        content = document.read_text(encoding="utf-8")

        for raw in LINK_PATTERN.findall(content):
            destination = raw.strip().split(" ", 1)[0].strip("<>")
            parsed = urlsplit(destination)

            if parsed.scheme or parsed.netloc or not parsed.path:
                continue

            target = document.parent / unquote(parsed.path)
            checked += 1

            if not target.exists():
                missing.append(
                    f"{document.relative_to(REPO)}: {destination}"
                )

    for item in missing:
        print("BROKEN LINK:", item)

    require(not missing, "Broken local documentation links.")

    print(
        f"PASS: {checked} local links checked "
        f"across {len(documents)} documents"
    )


def run_manager(manager, repo, home, *arguments, expected=0):
    environment = os.environ.copy()

    environment.update({
        "HOME": str(home),
        "DOTFILES_TEST_MODE": "1",
        "DOTFILES_TEST_HOME": str(home),
        "DOTFILES_TEST_REPO": str(repo),
        "PYTHONDONTWRITEBYTECODE": "1",
    })

    result = subprocess.run(
        [sys.executable, str(manager), *arguments],
        env=environment,
        capture_output=True,
        text=True,
        check=False,
    )

    require(
        result.returncode == expected,
        f"Unexpected manager result for {arguments}:\n"
        f"{result.stdout}\n{result.stderr}",
    )

    return result.stdout


def test_clean_home():
    with tempfile.TemporaryDirectory(
        prefix="macsetup-cp9-recovery-"
    ) as temporary:
        root = Path(temporary)
        checkout = root / "repository"
        home = root / "home"
        home.mkdir()

        # A local clone tests the committed repository structure.
        # It does not fetch from GitHub or modify the source clone.
        subprocess.run(
            [
                "git", "clone", "--quiet", "--no-hardlinks",
                "--", str(REPO), str(checkout),
            ],
            check=True,
        )

        # Overlay local deployment changes onto the isolated clone.
        # This includes the uncommitted dashboard prototype.
        for relative_path in (
            "bin/dothelp",
            "bin/midnight",
            "scripts/manage-macos.py",
            "scripts/terminal-guide.sh",
        ):
            shutil.copy2(
                REPO / relative_path,
                checkout / relative_path,
            )

        manager = checkout / "scripts/manage-macos.py"

        plan = run_manager(
            manager, checkout, home, "plan"
        )
        require(
            "MISSING: 18" in plan,
            "A clean HOME must have 18 missing targets.",
        )
        print("PASS: Clean-HOME preflight")

        run_manager(
            manager, checkout, home, "verify", expected=1
        )
        run_manager(
            manager, checkout, home, "apply", expected=2
        )
        print("PASS: Unauthorised deployment blocked")

        output = run_manager(
            manager, checkout, home, "apply", "--yes"
        )
        require(
            "APPLY COMPLETE" in output,
            "Deployment did not complete.",
        )

        verification = run_manager(
            manager, checkout, home, "verify"
        )
        require(
            "VERIFY: PASS" in verification
            and "MANAGED: 18" in verification,
            "Not all targets were deployed.",
        )
        print("PASS: All 18 targets deployed")

        # A symlink can exist while the linked command is broken.
        dothelp = home / ".local/bin/dothelp"

        result = subprocess.run(
            [str(dothelp)],
            env={
                **os.environ,
                "HOME": str(home),
                "PATH": "/usr/bin:/bin",
            },
            capture_output=True,
            text=True,
            check=False,
        )

        require(
            result.returncode == 0
            and "Available documentation:" in result.stdout
            and "Start Here" in result.stdout,
            f"dothelp failed through its symlink:\n"
            f"{result.stdout}\n{result.stderr}",
        )
        print("PASS: dothelp through installed symlink")

        # Verify the dashboard launcher, not just its symlink.
        dashboard = home / ".local/bin/midnight"

        result = subprocess.run(
            [str(dashboard), "--preview", "projects"],
            env={
                **os.environ,
                "HOME": str(home),
                "PATH": "/usr/bin:/bin",
            },
            capture_output=True,
            text=True,
            check=False,
        )

        require(
            result.returncode == 0
            and "RESEARCH PROJECTS" in result.stdout,
            "Dashboard preview failed through installed symlink: "
            + result.stdout + result.stderr,
        )

        print("PASS: midnight through installed symlink")

        repeated = run_manager(
            manager, checkout, home, "apply", "--yes"
        )
        require(
            "ALREADY MANAGED" in repeated,
            "Repeated apply was not idempotent.",
        )
        print("PASS: Repeated deployment is idempotent")

        restored = run_manager(
            manager, checkout, home, "rollback", "--yes"
        )
        require(
            "ROLLBACK COMPLETE" in restored,
            "Rollback did not complete.",
        )

        manifest = [
            ".config/nvim",
            ".tmux.conf",
            ".config/starship.toml",
            ".zshrc",
            ".gitconfig",
            ".aerospace.toml",
            "Library/Application Support/"
            "com.mitchellh.ghostty/config.ghostty",
            ".config/sketchybar/sketchybarrc",
            ".config/sketchybar/plugins/battery.sh",
            ".config/sketchybar/plugins/clock.sh",
            ".config/sketchybar/plugins/front_app.sh",
            ".config/sketchybar/plugins/workspaces.sh",
            ".config/borders/bordersrc",
            ".config/raycast/scripts/research-projects.sh",
            ".local/bin/research-projects",
            ".local/bin/dothelp",
            ".local/bin/guide",
            ".local/bin/midnight",
        ]

        for relative in manifest:
            target = home / relative
            require(
                not target.exists() and not target.is_symlink(),
                f"Target survived clean-HOME rollback: {relative}",
            )

        journal_files = list(
            (home / ".dotfiles-backup/v2").glob(
                "txn-*/journal.json"
            )
        )
        require(
            len(journal_files) == 1,
            "Expected one recovery journal.",
        )

        require(
            '"state": "rolled_back"'
            in journal_files[0].read_text(encoding="utf-8"),
            "Rollback journal state is incorrect.",
        )

        print("PASS: All 18 targets rolled back")
        print("PASS: Recovery journal records rollback")


def main():
    check_document_links()
    test_clean_home()

    print()
    print("===== CP9 RECOVERY SIMULATION: PASS =====")
    print("No live desktop configurations were changed.")
    print("This is not a full clean-macOS provisioning test.")


if __name__ == "__main__":
    main()
