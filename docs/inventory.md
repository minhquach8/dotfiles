# System Inventory

## 1. Scope

Primary workstation: Apple Silicon macOS.

Baseline observation date: 26 October 2026.

This is a historical inventory and must be updated
as the v2 migration progresses.

## 2. Git Repository

Repository:

https://github.com/minhquach8/dotfiles

Architecture checkpoint:

    f6fa31c

Five pre-existing uncommitted changes:

- nvim/lazy-lock.json
- nvim/lua/config/keymaps.lua
- nvim/lua/config/lazy.lua
- starship/starship.toml
- tmux/.tmux.conf

These files were included in the verified
local recovery checkpoint.

## 3. Git-Managed Configuration

| Component | Repository source |
|---|---|
| Neovim | nvim/ |
| tmux | tmux/.tmux.conf |
| Starship | starship/starship.toml |
| macOS Zsh | shell/.zshrc.macos |
| Linux Zsh | shell/.zshrc.linux |
| Git | git/.gitconfig |

## 4. Desktop Configuration to Migrate

| Component | Current location |
|---|---|
| AeroSpace | ~/.aerospace.toml |
| Ghostty | ~/Library/Application Support/com.mitchellh.ghostty/config.ghostty |
| SketchyBar | ~/.config/sketchybar |
| JankyBorders | ~/.config/borders |
| Raycast scripts | ~/.config/raycast/scripts |
| Project Launcher | ~/.local/bin/research-projects* |

## 5. Services

Previously observed running Homebrew services:

- SketchyBar
- JankyBorders
- MySQL

Database services must not be stopped or removed
during desktop cleanup without explicit approval.

## 6. Package Inventory

The original Homebrew inventory is stored in:

    ~/Documents/MacSetup-Recovery/20261026-125307

Relevant files:

- homebrew-formulae.txt
- homebrew-casks.txt
- homebrew-taps.txt
- homebrew-services.txt

## 7. Investigation Candidates

- Historical iTerm2 configuration
- Historical fish configuration
- Duplicate Starship backups
- Duplicate SketchyBar backups
- Project Launcher versions and backups
- Duplicate PATH entries
- Outdated application references
- Raycast application settings and exports

None of these items is approved for deletion.

## 8. Known Issues

- External monitor: status bar overlaps windows.
- Desktop configuration is not fully Git-managed.
- Raycast recovery is incomplete.
- Installation scripts are not fully idempotent.
- Verification scripts need stronger checks.
- Some shell paths are machine-specific.

## 9. Migration Status

Use the following states:

- Retain
- Consolidate
- Replace
- Archive
- Remove
- Needs investigation

Each decision requires a reason and verification.
