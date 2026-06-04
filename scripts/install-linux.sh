#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"

backup_path() {
  local target_path="$1"

  if [ -e "$target_path" ] || [ -L "$target_path" ]; then
    mkdir -p "$BACKUP_DIR"
    mv "$target_path" "$BACKUP_DIR/"
    echo "Backed up: $target_path -> $BACKUP_DIR/"
  fi
}

link_path() {
  local source_path="$1"
  local target_path="$2"

  backup_path "$target_path"

  mkdir -p "$(dirname "$target_path")"
  ln -s "$source_path" "$target_path"
  echo "Linked: $target_path -> $source_path"
}

echo "Installing Linux dotfiles from: $DOTFILES_DIR"

link_path "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
link_path "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
link_path "$DOTFILES_DIR/shell/.zshrc.linux" "$HOME/.zshrc"
link_path "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"

echo "Linux dotfiles installed."
echo "Restart your shell or run: exec zsh"
