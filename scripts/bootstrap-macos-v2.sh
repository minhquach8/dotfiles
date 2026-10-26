#!/usr/bin/env bash
set -euo pipefail

# Midnight Research — macOS Bootstrap v2.
# Default behaviour is inspection only.
# Compatible with the system-provided macOS Bash 3.2.

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

usage() {
    echo "Usage:"
    echo "  $0 plan [profiles...]"
    echo "  $0 check [profiles...]"
    echo "  $0 install --yes [profiles...]"
    echo
    echo "Profiles: core desktop research optional"
}

mode="${1:-plan}"

if [[ "$#" -gt 0 ]]; then
    shift
fi

case "$mode" in
    plan|check|install) ;;
    *)
        usage
        exit 2
        ;;
esac

authorised=0

if [[ "${1:-}" == "--yes" ]]; then
    authorised=1
    shift
fi

if [[ "$mode" == "install" && "$authorised" -ne 1 ]]; then
    echo "INSTALL BLOCKED: Explicit --yes required."
    exit 2
fi

if [[ "$#" -eq 0 ]]; then
    profiles=(core desktop)
else
    profiles=("$@")
fi

# Validate every requested profile before doing any work.
for profile in "${profiles[@]}"; do
    case "$profile" in
        core|desktop|research|optional) ;;
        *)
            echo "ERROR: Unknown profile: $profile"
            usage
            exit 2
            ;;
    esac

    if [[ ! -s "$repo_dir/brew/Brewfile.$profile" ]]; then
        echo "ERROR: Missing Brewfile for $profile"
        exit 1
    fi
done

echo "===== MACOS BOOTSTRAP V2 ====="
echo "Mode: $mode"
echo "Profiles: ${profiles[*]}"
echo "Repository: $repo_dir"
echo

echo "===== PLATFORM ====="

platform="$(uname -s)"
architecture="$(uname -m)"

echo "Operating system: $platform"
echo "Architecture: $architecture"

if [[ "$platform" != "Darwin" ]]; then
    echo "ERROR: macOS is required."
    exit 1
fi

echo
echo "===== DEVELOPER TOOLS ====="

if xcode-select -p >/dev/null 2>&1; then
    echo "Command Line Tools: available"
else
    echo "Command Line Tools: not detected"
    echo "Setup guidance: xcode-select --install"
fi

echo
echo "===== HOMEBREW ====="

if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew: missing"
    echo "Official installation instructions: https://brew.sh"

    if [[ "$mode" == "plan" ]]; then
        echo "PLAN COMPLETE: Homebrew prerequisite missing."
        exit 0
    fi

    exit 1
fi

echo "Homebrew: $(command -v brew)"
brew --version | head -n 1

echo
echo "===== PYTHON INTERPRETER ====="

if command -v python3 >/dev/null 2>&1; then
    echo "Active Python: $(command -v python3)"
    python3 --version
else
    echo "Active Python: missing"
fi

echo
echo "===== HOMEBREW PYTHON FORMULAE ====="

for formula in python python@3.14 python@3.11 python@3.10; do
    if brew list --formula --versions "$formula" \
        >/dev/null 2>&1; then
        version="$(brew list --formula --versions "$formula")"
        echo "Installed: $version"
    else
        echo "Not installed: $formula"
    fi
done

echo
echo "===== DEPENDENCY PROFILES ====="

missing=0

for profile in "${profiles[@]}"; do
    brewfile="$repo_dir/brew/Brewfile.$profile"

    echo
    echo "PROFILE: $profile"

    if brew bundle check \
        --file="$brewfile" \
        --no-upgrade \
        --verbose; then

        echo "STATUS: SATISFIED"
    else
        echo "STATUS: INCOMPLETE"
        missing=$((missing + 1))
    fi
done

echo
echo "===== SUMMARY ====="

echo "Profiles checked: ${#profiles[@]}"
echo "Incomplete profiles: $missing"

case "$mode" in
    plan)
        echo "PLAN COMPLETE."
        echo "No package installation requested."
        exit 0
        ;;

    check)
        if [[ "$missing" -eq 0 ]]; then
            echo "CHECK: PASS"
            exit 0
        fi

        echo "CHECK: INCOMPLETE"
        exit 1
        ;;

    install)
        echo
        echo "===== APPROVED INSTALLATION ====="

        for profile in "${profiles[@]}"; do
            brewfile="$repo_dir/brew/Brewfile.$profile"

            echo "Installing profile: $profile"

            brew bundle install \
                --no-upgrade \
                --file="$brewfile"
        done

        echo
        echo "===== FINAL VERIFICATION ====="

        for profile in "${profiles[@]}"; do
            brew bundle check \
                --no-upgrade \
                --file="$repo_dir/brew/Brewfile.$profile"
        done

        echo "BOOTSTRAP COMPLETE."
        ;;
esac
