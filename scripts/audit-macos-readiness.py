#!/usr/bin/env python3
"""Audit macOS workstation recovery prerequisites without changes."""

from pathlib import Path
import platform
import re
import shutil
import os
import subprocess


REPO = Path(__file__).resolve().parent.parent
HOME = Path.home()


def section(title):
    print(f"\n===== {title} =====")


def check(label, available):
    state = "PRESENT" if available else "MISSING"
    print(f"{state:<9} {label}")
    return available


def read_brewfiles():
    declared = set()

    for file in sorted((REPO / "brew").glob("Brewfile.*")):
        for line in file.read_text(encoding="utf-8").splitlines():
            match = re.match(
                r'^\s*(?:brew|cask)\s+"([^"]+)"',
                line,
            )
            if match:
                declared.add(match.group(1))

    return declared


def main():
    section("PLATFORM")

    print(f"System: {platform.system()}")
    print(f"Architecture: {platform.machine()}")

    section("CORE COMMANDS")

    core = (
        "brew", "git", "python3", "zsh", "nvim",
        "tmux", "starship", "fzf", "rg", "fd",
        "uv", "bat",
    )

    core_found = sum(
        check(command, shutil.which(command) is not None)
        for command in core
    )

    section("SHELL DEPENDENCIES")

    shell = {
        "Oh My Zsh": HOME / ".oh-my-zsh/oh-my-zsh.sh",
        "zsh-autosuggestions":
            HOME / ".oh-my-zsh/custom/plugins/zsh-autosuggestions",
        "zsh-syntax-highlighting":
            HOME / ".oh-my-zsh/custom/plugins/zsh-syntax-highlighting",
        "NVM": HOME / ".nvm/nvm.sh",
        "Conda (default location)": HOME / "miniconda3/bin/conda",
        "pnpm home": HOME / "Library/pnpm",
        "PostgreSQL 18 bin": Path("/Library/PostgreSQL/18/bin"),
    }

    for label, path in shell.items():
        check(label, path.exists())

    section("PROJECT COMMANDS — INHERITED PATH")

    commands = (
        "dothelp",
        "research-projects",
        "node",
        "pnpm",
        "npm",
        "corepack",
    )

    for name in commands:
        resolved = shutil.which(name)
        print(f"{name:<20} {resolved or 'NOT FOUND'}")

    section("PROJECT COMMANDS — FRESH LOGIN SHELL")

    environment = {
        "HOME": str(HOME),
        "USER": os.environ.get("USER", HOME.name),
        "SHELL": "/bin/zsh",
        "TERM": "xterm-256color",
        "PATH": "/usr/bin:/bin:/usr/sbin:/sbin",
    }

    command = """
for name in dothelp research-projects node pnpm npm corepack; do
    if command -v "$name" >/dev/null 2>&1; then
        printf "PRESENT %-20s %s\\n" "$name" "$(command -v "$name")"
    else
        printf "MISSING %-20s\\n" "$name"
    fi
done
"""

    result = subprocess.run(
        ["/bin/zsh", "-lic", command],
        env=environment,
        capture_output=True,
        text=True,
        check=False,
    )

    if result.returncode != 0:
        print("LOGIN SHELL CHECK FAILED")
        print(result.stderr[-2000:])
    else:
        print(result.stdout.rstrip())

    section("PNPM LOCATIONS")

    locations = (
        HOME / "Library/pnpm",
        HOME / ".local/share/pnpm",
        HOME / ".nvm",
    )

    for location in locations:
        print(
            f"{'PRESENT' if location.exists() else 'MISSING':<9} "
            f"{location}"
        )

    section("DESKTOP APPLICATIONS")

    applications = (
        ("Ghostty", "Ghostty.app"),
        ("Raycast", "Raycast.app"),
        ("AeroSpace", "AeroSpace.app"),
        ("Firefox", "Firefox.app"),
        ("VS Code", "Visual Studio Code.app"),
    )

    for label, bundle in applications:
        installed = (
            (Path("/Applications") / bundle).exists()
            or (HOME / "Applications" / bundle).exists()
        )
        check(label, installed)

    print("Note: Other installation locations are not checked.")

    section("PERSONAL SETTINGS — PRESENCE ONLY")

    check(
        "Raycast application state",
        (HOME / "Library/Application Support/com.raycast.macos").exists(),
    )

    check(
        "Raycast Script Command",
        (HOME / ".config/raycast/scripts/research-projects.sh").exists(),
    )

    print("Raycast preferences and private data were not opened.")

    section("HOMEBREW DECLARATION COVERAGE")

    declared = read_brewfiles()

    candidates = {
        "Firefox": ("firefox",),
        "VS Code": ("visual-studio-code",),
        "NVM": ("nvm",),
        "pnpm": ("pnpm",),
        "Miniconda": ("miniconda", "miniforge"),
        "Oh My Zsh": ("oh-my-zsh",),
        "chafa image preview": ("chafa",),
    }

    for label, options in candidates.items():
        included = any(name in declared for name in options)
        state = "DECLARED" if included else "NOT DECLARED"
        print(f"{state:<13} {label}")

    print(
        "Note: Not declared does not imply not installed. "
        "Other installation methods may apply."
    )

    section("REPOSITORY RECOVERY ASSETS")

    required = {
        "Bootstrap v2": "scripts/bootstrap-macos-v2.sh",
        "Transactional deployment": "scripts/manage-macos.py",
        "Recovery tests": "scripts/test-recovery-macos.py",
        "macOS setup guide": "docs/setup-macos.md",
        "Recovery guide": "docs/disaster-recovery.md",
        "Wallpaper assets": (
            "assets/wallpapers/midnight-research/"
            "03-MacBook-Retina-3024x1964.png"
        ),
    }

    for label, relative in required.items():
        check(label, (REPO / relative).exists())

    section("KNOWN MANUAL RESTORATION")

    print("MANUAL    Raycast Hyper Key and personal shortcuts")
    print("MANUAL    macOS Accessibility/Automation permissions")
    print("MANUAL    Multi-monitor arrangement and wallpaper assignment")
    print("MANUAL    Login items and application-specific settings")
    print("REVIEW    Encrypted off-device recovery backup")

    section("SUMMARY")

    print(f"Core commands available: {core_found}/{len(core)}")
    print("Audit complete; no system configuration modified.")
    print("Presence checks do not prove application functionality.")


if __name__ == "__main__":
    main()
