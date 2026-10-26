#!/usr/bin/env bash
set -euo pipefail

# Inspect Homebrew dependency profiles without installing packages.

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v brew >/dev/null 2>&1; then
    echo "ERROR: Homebrew is not installed."
    exit 1
fi

echo "===== HOMEBREW ====="
brew --version | head -n 1

echo
echo "===== PROFILE CHECKS ====="

for profile in core desktop research optional; do
    brewfile="$repo_dir/brew/Brewfile.$profile"

    echo
    echo "PROFILE: $profile"

    if [[ ! -s "$brewfile" ]]; then
        echo "ERROR: Missing Brewfile: $brewfile"
        exit 1
    fi

    # Parse and list the profile without installation.
    brew bundle list --file="$brewfile" --all

    echo
    echo "Installed dependency check:"

    if brew bundle check \
        --file="$brewfile" \
        --no-upgrade \
        --verbose; then
        echo "RESULT: SATISFIED"
    else
        echo "RESULT: INCOMPLETE OR NEEDS REVIEW"
    fi
done

echo
echo "===== READ-ONLY CHECK COMPLETE ====="
echo "No packages were installed or removed."
