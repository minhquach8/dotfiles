#!/usr/bin/env bash
set -euo pipefail

# Exercise read-only modes and confirm that installation
# cannot begin without explicit authorisation.

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bootstrap="$script_dir/bootstrap-macos-v2.sh"

echo "===== BOOTSTRAP REGRESSION TESTS ====="

/bin/bash -n "$bootstrap"

echo "PASS: Bash syntax"

if output="$("$bootstrap" install core desktop 2>&1)"; then
    echo "FAIL: Installation succeeded without --yes."
    exit 1
else
    case "$output" in
        *"INSTALL BLOCKED"*)
            echo "PASS: Unauthorised installation blocked"
            ;;
        *)
            echo "FAIL: Unexpected installation response."
            echo "$output"
            exit 1
            ;;
    esac
fi

if "$bootstrap" plan unknown-profile >/dev/null 2>&1; then
    echo "FAIL: Unknown profile accepted."
    exit 1
else
    echo "PASS: Unknown profile rejected"
fi

echo
echo "===== CHECK DEFAULT PROFILES ====="

"$bootstrap" check core desktop

echo
echo "===== CHECK OPTIONAL PROFILES ====="

"$bootstrap" check research optional

echo
echo "===== BOOTSTRAP REGRESSION TESTS PASSED ====="
