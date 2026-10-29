#!/usr/bin/env python3
"""Transactional macOS dotfiles deployment."""

import argparse
import filecmp
import hashlib
import stat
import json
import os
import sys
import tempfile
from datetime import datetime, timezone
from pathlib import Path


MANIFEST = [
    ("Neovim", "nvim", ".config/nvim"),
    ("tmux", "tmux/.tmux.conf", ".tmux.conf"),
    ("Starship", "starship/starship.toml", ".config/starship.toml"),
    ("Zsh", "shell/.zshrc.macos", ".zshrc"),
    ("Git", "git/.gitconfig", ".gitconfig"),
    ("AeroSpace", "config/aerospace/aerospace.toml", ".aerospace.toml"),
    (
        "Ghostty",
        "config/ghostty/config.ghostty",
        "Library/Application Support/com.mitchellh.ghostty/config.ghostty",
    ),
    (
        "SketchyBar",
        "config/sketchybar/sketchybarrc",
        ".config/sketchybar/sketchybarrc",
    ),
    (
        "Bar Battery",
        "config/sketchybar/plugins/battery.sh",
        ".config/sketchybar/plugins/battery.sh",
    ),
    (
        "Bar Clock",
        "config/sketchybar/plugins/clock.sh",
        ".config/sketchybar/plugins/clock.sh",
    ),
    (
        "Bar Front App",
        "config/sketchybar/plugins/front_app.sh",
        ".config/sketchybar/plugins/front_app.sh",
    ),
    (
        "Bar Workspaces",
        "config/sketchybar/plugins/workspaces.sh",
        ".config/sketchybar/plugins/workspaces.sh",
    ),
    ("JankyBorders", "config/borders/bordersrc", ".config/borders/bordersrc"),
    (
        "Raycast Script",
        "config/raycast/scripts/research-projects.sh",
        ".config/raycast/scripts/research-projects.sh",
    ),
    (
        "Project Launcher",
        "bin/research-projects",
        ".local/bin/research-projects",
    ),
    ("dothelp", "bin/dothelp", ".local/bin/dothelp"),
    ("Guide", "scripts/terminal-guide.sh", ".local/bin/guide"),
    ("Dashboard", "bin/midnight", ".local/bin/midnight"),
]


def get_paths():
    test_mode = os.environ.get("DOTFILES_TEST_MODE") == "1"

    if sys.platform != "darwin" and not test_mode:
        raise RuntimeError("This manager requires macOS.")

    if test_mode:
        repo = Path(os.environ["DOTFILES_TEST_REPO"]).resolve()
        home = Path(os.environ["DOTFILES_TEST_HOME"]).resolve()
    else:
        repo = Path(__file__).resolve().parent.parent
        home = Path.home()

    if not repo.is_dir() or not home.is_dir():
        raise RuntimeError("Repository or HOME does not exist.")

    return repo, home


def exists(path):
    return path.exists() or path.is_symlink()


def points_to_source(source, target):
    """Recognise equivalent absolute or relative symlink targets."""
    if not target.is_symlink():
        return False

    if os.readlink(target) == str(source):
        return True

    return (
        source.exists()
        and target.exists()
        and source.resolve() == target.resolve()
    )


def classify(source, target):
    if not source.exists():
        return "SOURCE_MISSING"

    if target.is_symlink():
        if points_to_source(source, target):
            return "MANAGED"

        if target.exists():
            return "OTHER_SYMLINK"

        return "BROKEN_SYMLINK"

    if not target.exists():
        return "MISSING"

    if source.is_file() and target.is_file():
        if filecmp.cmp(source, target, shallow=False):
            return "MATCHING_COPY"
        return "DIFFERENT_COPY"

    if source.is_dir() and target.is_dir():
        return "EXISTING_DIRECTORY"

    return "TYPE_CONFLICT"


def get_inventory(repo, home):
    entries = []

    for index, (label, source_name, target_name) in enumerate(MANIFEST):
        source = repo / source_name
        target = home / target_name

        entries.append({
            "label": label,
            "source": str(source),
            "target": str(target),
            "status": classify(source, target),
            "phase": "planned",
            "backup": f"originals/{index:02d}",
        })

    return entries


def display_inventory(entries):
    for entry in entries:
        print(
            f"{entry['label']:<19} "
            f"{entry['status']:<20} "
            f"{entry['target']}"
        )

    print()

    for status in (
        "MANAGED",
        "MATCHING_COPY",
        "DIFFERENT_COPY",
        "MISSING",
    ):
        count = sum(
            entry["status"] == status
            for entry in entries
        )
        print(f"{status}: {count}")


def save_journal(transaction, journal):
    descriptor, temporary = tempfile.mkstemp(
        prefix=".journal-",
        dir=transaction,
    )

    try:
        with os.fdopen(descriptor, "w", encoding="utf-8") as handle:
            json.dump(journal, handle, indent=2)
            handle.write("\n")
            handle.flush()
            os.fsync(handle.fileno())

        os.replace(temporary, transaction / "journal.json")

    finally:
        if os.path.exists(temporary):
            os.unlink(temporary)


def original_fingerprint(path):
    """Record content and permissions before deployment."""
    digest = hashlib.sha256()

    with path.open("rb") as handle:
        for chunk in iter(
            lambda: handle.read(1024 * 1024),
            b"",
        ):
            digest.update(chunk)

    return {
        "sha256": digest.hexdigest(),
        "mode": stat.S_IMODE(path.stat().st_mode),
    }


def original_matches(path, entry):
    """Recognise an original file restored before journal update."""
    expected = entry.get("original")

    if not isinstance(expected, dict):
        return False

    if path.is_symlink() or not path.is_file():
        return False

    return original_fingerprint(path) == expected


def restore_transaction(transaction, journal):
    # Check all restoration targets before changing any.
    for entry in reversed(journal["entries"]):
        if entry["phase"] not in ("pending", "done"):
            continue

        target = Path(entry["target"])
        backup = transaction / entry["backup"]

        managed = points_to_source(
            Path(entry["source"]),
            target,
        )

        if exists(backup):
            if exists(target) and not managed:
                raise RuntimeError(
                    f"Rollback conflict: {target}"
                )

        elif entry["status"] == "MISSING":
            if exists(target) and not managed:
                raise RuntimeError(
                    f"Rollback conflict: {target}"
                )

        elif not original_matches(target, entry):
            raise RuntimeError(
                "Rollback backup missing and original "
                f"cannot be verified: {backup}"
            )

    # Restore in reverse deployment order.
    for entry in reversed(journal["entries"]):
        if entry["phase"] not in ("pending", "done"):
            continue

        target = Path(entry["target"])
        backup = transaction / entry["backup"]

        managed = points_to_source(
            Path(entry["source"]),
            target,
        )

        if managed:
            target.unlink()

        if exists(backup):
            os.rename(backup, target)

        entry["phase"] = "restored"
        save_journal(transaction, journal)

    journal["state"] = "rolled_back"
    save_journal(transaction, journal)


def find_active_transaction(home):
    """Refuse ambiguous or overlapping recovery transactions."""
    backup_root = home / ".dotfiles-backup" / "v2"

    if not backup_root.is_dir():
        return None

    active = []

    for transaction in backup_root.glob("txn-*"):
        journal_file = transaction / "journal.json"

        if not journal_file.is_file():
            continue

        journal = json.loads(
            journal_file.read_text(encoding="utf-8")
        )

        if journal.get("state") in (
            "applied",
            "applying",
            "failed",
        ):
            active.append((transaction, journal))

    if len(active) > 1:
        locations = ", ".join(
            str(transaction)
            for transaction, _ in active
        )
        raise RuntimeError(
            "Multiple unresolved transactions; "
            f"manual review required: {locations}"
        )

    return active[0] if active else None


def apply_configuration(entries, home, replace_different):
    allowed = {
        "MANAGED",
        "MATCHING_COPY",
        "MISSING",
    }

    if replace_different:
        allowed.add("DIFFERENT_COPY")

    blocked = [
        entry
        for entry in entries
        if entry["status"] not in allowed
    ]

    if blocked:
        print("APPLY BLOCKED:")

        for entry in blocked:
            print(
                f"  {entry['label']}: "
                f"{entry['status']}"
            )

        return 2

    changes = [
        entry
        for entry in entries
        if entry["status"] != "MANAGED"
    ]

    if not changes:
        print("ALREADY MANAGED. No changes required.")
        return 0

    if find_active_transaction(home) is not None:
        print(
            "APPLY BLOCKED: An earlier transaction "
            "must be resolved before further changes."
        )
        return 2

    # Fingerprint existing regular files before any migration.
    for entry in changes:
        if entry["status"] in (
            "MATCHING_COPY",
            "DIFFERENT_COPY",
        ):
            entry["original"] = original_fingerprint(
                Path(entry["target"])
            )

    backup_root = home / ".dotfiles-backup" / "v2"
    backup_root.mkdir(
        parents=True,
        exist_ok=True,
        mode=0o700,
    )

    transaction = Path(
        tempfile.mkdtemp(
            prefix="txn-",
            dir=backup_root,
        )
    )

    (transaction / "originals").mkdir(mode=0o700)

    journal = {
        "version": 1,
        "state": "applying",
        "timestamp": datetime.now(
            timezone.utc
        ).isoformat(),
        "entries": entries,
    }

    save_journal(transaction, journal)

    print(f"TRANSACTION: {transaction}")

    try:
        for entry in changes:
            source = Path(entry["source"])
            target = Path(entry["target"])

            # Abort if the target changed after preflight.
            if classify(source, target) != entry["status"]:
                raise RuntimeError(
                    f"Target changed during apply: {target}"
                )

            if (
                entry.get("original") is not None
                and not original_matches(target, entry)
            ):
                raise RuntimeError(
                    f"Target content changed during apply: {target}"
                )

            entry["phase"] = "pending"
            save_journal(transaction, journal)

            target.parent.mkdir(
                parents=True,
                exist_ok=True,
            )

            if exists(target):
                os.rename(
                    target,
                    transaction / entry["backup"],
                )

            target.symlink_to(
                source,
                target_is_directory=source.is_dir(),
            )

            entry["phase"] = "done"
            save_journal(transaction, journal)

            print(f"LINKED: {target}")

    except Exception as error:
        journal["state"] = "failed"
        save_journal(transaction, journal)

        print(f"APPLY FAILED: {error}")

        try:
            restore_transaction(transaction, journal)
            print("Automatic rollback completed.")

        except Exception as rollback_error:
            print(
                "ROLLBACK REQUIRES MANUAL REVIEW: "
                f"{rollback_error}"
            )
            print(
                "Recovery journal: "
                f"{transaction / 'journal.json'}"
            )

        return 1

    journal["state"] = "applied"
    save_journal(transaction, journal)

    print("APPLY COMPLETE.")
    print("Original files retained in transaction backup.")
    return 0


def main():
    os.umask(0o077)

    parser = argparse.ArgumentParser(
        description="Dotfiles v2 macOS deployment manager"
    )

    parser.add_argument(
        "command",
        nargs="?",
        default="plan",
        choices=("plan", "apply", "verify", "rollback"),
    )

    parser.add_argument(
        "--yes",
        action="store_true",
        help="Authorise write operations",
    )

    parser.add_argument(
        "--replace-different",
        action="store_true",
        help="Back up and replace differing regular files",
    )

    arguments = parser.parse_args()
    repo, home = get_paths()
    entries = get_inventory(repo, home)

    if arguments.command in ("plan", "verify"):
        print(
            "===== DOTFILES V2: "
            f"{arguments.command.upper()} ====="
        )

        display_inventory(entries)

        if arguments.command == "plan":
            print("READ-ONLY. No changes made.")
            return 0

        success = all(
            entry["status"] == "MANAGED"
            for entry in entries
        )

        print(
            "VERIFY: PASS"
            if success
            else "VERIFY: NOT FULLY DEPLOYED"
        )

        return 0 if success else 1

    if not arguments.yes:
        print(
            "WRITE BLOCKED: use --yes only "
            "after reviewing the deployment plan."
        )
        return 2

    if arguments.command == "apply":
        print("===== APPLY PRE-FLIGHT =====")
        display_inventory(entries)

        return apply_configuration(
            entries,
            home,
            arguments.replace_different,
        )

    latest = find_active_transaction(home)

    if latest is None:
        print("NO ACTIVE TRANSACTION TO ROLL BACK.")
        return 2

    transaction, journal = latest

    print(f"ROLLING BACK: {transaction}")
    restore_transaction(transaction, journal)
    print("ROLLBACK COMPLETE.")

    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())

    except (OSError, RuntimeError, ValueError) as error:
        print(f"ERROR: {error}", file=sys.stderr)
        sys.exit(1)
