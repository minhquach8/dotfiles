#!/usr/bin/env bash

set -euo pipefail

print_ok() {
    printf "✓ %s\n" "$1"
}

print_missing() {
    printf "✗ %s\n" "$1"
}

check_command() {
    local command_name="$1"

    if command -v "$command_name" >/dev/null 2>&1; then
        print_ok "$command_name: $(command -v "$command_name")"
    else
        print_missing "$command_name is missing"
        return 1
    fi
}

check_symlink() {
    local target_path="$1"

    if [ -L "$target_path" ]; then
        print_ok "$target_path is a symlink"
    else
        print_missing "$target_path is not a symlink"
        return 1
    fi
}

echo "Verifying Linux development environment"
echo

check_command git
check_command zsh
check_command tmux
check_command starship
check_command uv
check_command nvim

echo

if [ -d "$HOME/.oh-my-zsh" ]; then
    print_ok "oh-my-zsh installed"
else
    print_missing "oh-my-zsh missing"
fi

if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    print_ok "zsh-autosuggestions installed"
else
    print_missing "zsh-autosuggestions missing"
fi

if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    print_ok "zsh-syntax-highlighting installed"
else
    print_missing "zsh-syntax-highlighting missing"
fi

echo

check_symlink "$HOME/.zshrc"
check_symlink "$HOME/.tmux.conf"
check_symlink "$HOME/.config/nvim"
check_symlink "$HOME/.config/starship.toml"
check_symlink "$HOME/.gitconfig"

echo
echo "Verification completed"
