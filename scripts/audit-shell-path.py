#!/usr/bin/env python3
"""Inspect PATH duplication and shell startup configuration."""

import os
import re
from collections import Counter
from pathlib import Path


def main():
    home = Path.home()

    print("===== CURRENT PATH DUPLICATES =====")

    entries = [
        entry
        for entry in os.environ.get("PATH", "").split(":")
        if entry
    ]

    counts = Counter(entries)
    duplicates = [
        (directory, count)
        for directory, count in counts.items()
        if count > 1
    ]

    if not duplicates:
        print("No repeated PATH entries found.")
    else:
        for directory, count in duplicates:
            print(f"{count}x {directory}")

    print()
    print("===== SHELL INITIALISATION FILES =====")

    candidates = [
        home / ".zshenv",
        home / ".zprofile",
        home / ".zshrc",
        home / ".zlogin",
        Path("/etc/zshenv"),
        Path("/etc/zprofile"),
        Path("/etc/zshrc"),
        Path("/etc/zlogin"),
    ]

    zdotdir = os.environ.get("ZDOTDIR")

    if zdotdir:
        for filename in (
            ".zshenv",
            ".zprofile",
            ".zshrc",
            ".zlogin",
        ):
            candidates.append(Path(zdotdir) / filename)

    rules = {
        "PATH assignment": re.compile(
            r"(?i)(?:export\s+PATH\s*=|"
            r"^\s*PATH\s*=|^\s*path\s*=)"
        ),
        "Homebrew shellenv": re.compile(
            r"brew\s+shellenv"
        ),
        "Conda initialisation": re.compile(
            r"(?i)(?:conda.*hook|conda\.sh)"
        ),
        "NVM initialisation": re.compile(
            r"(?:nvm\.sh|NVM_DIR)"
        ),
        "PostgreSQL PATH": re.compile(
            r"/Library/PostgreSQL/"
        ),
        "pnpm initialisation": re.compile(
            r"PNPM_HOME"
        ),
    }

    seen = set()

    for config_file in candidates:
        if not config_file.is_file():
            continue

        canonical = config_file.resolve()

        if canonical in seen:
            continue

        seen.add(canonical)

        print(f"\nFILE: {config_file}")

        if canonical != config_file:
            print(f"Source: {canonical}")

        try:
            lines = config_file.read_text(
                encoding="utf-8",
                errors="replace",
            ).splitlines()
        except OSError as error:
            print(f"Unreadable: {error}")
            continue

        found = False

        for line_number, line in enumerate(lines, 1):
            if line.lstrip().startswith("#"):
                continue

            matches = [
                label
                for label, pattern in rules.items()
                if pattern.search(line)
            ]

            if matches:
                found = True
                print(
                    f"  Line {line_number}: "
                    + ", ".join(matches)
                )

        if not found:
            print("  No tracked PATH initialisation patterns.")

    print()
    print("===== AUDIT COMPLETE =====")
    print("Only categories and line numbers were shown.")
    print("No shell configurations were executed or modified.")


if __name__ == "__main__":
    main()
