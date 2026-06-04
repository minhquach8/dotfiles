#!/usr/bin/env bash

set -euo pipefail

echo "Bootstrap Linux environment"

# -------------------------------------------------
# zsh
# -------------------------------------------------

if ! command -v zsh >/dev/null 2>&1; then
    sudo apt update
    sudo apt install -y zsh
fi

# -------------------------------------------------
# tmux
# -------------------------------------------------

if ! command -v tmux >/dev/null 2>&1; then
    sudo apt install -y tmux
fi

# -------------------------------------------------
# uv
# -------------------------------------------------

if ! command -v uv >/dev/null 2>&1; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# -------------------------------------------------
# starship
# -------------------------------------------------

if ! command -v starship >/dev/null 2>&1; then
    curl -sS https://starship.rs/install.sh | sh -s -- \
        --yes \
        --bin-dir "$HOME/.local/bin"
fi

echo "Bootstrap completed"
