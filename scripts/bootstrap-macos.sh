#!/usr/bin/env bash

set -euo pipefail

if [[ "$OSTYPE" != darwin* ]]; then
    echo "This script is intended for macOS only."
    exit 1
fi

echo "Bootstrap macOS environment"

if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew is missing."
    echo "Install Homebrew first: https://brew.sh"
    exit 1
fi

brew update

brew install git || true
brew install zsh || true
brew install tmux || true
brew install starship || true
brew install fzf || true
brew install neovim || true
brew install uv || true

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi

echo "macOS bootstrap completed."
echo "Run: ./scripts/install-macos.sh"
