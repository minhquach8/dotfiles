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

The five previously uncommitted Neovim, tmux and
Starship changes were consolidated in CP6:

    ffdcd16

The desktop deployment completed in CP7.

The multi-monitor configuration and wallpaper
assets were committed in CP8:

    d8018d7

## 3. Git-Managed Configuration

| Component | Repository source |
|---|---|
| Neovim | nvim/ |
| tmux | tmux/.tmux.conf |
| Starship | starship/starship.toml |
| macOS Zsh | shell/.zshrc.macos |
| Linux Zsh | shell/.zshrc.linux |
| Git | git/.gitconfig |

## 4. Desktop Configuration — Migrated

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

## 8. Current Issues and Limitations

Resolved on 26 October 2026:

- External-monitor SketchyBar overlap
- Desktop migration to 16 Git-managed targets
- Duplicate PATH entries in the tested Zsh environment
- Uncommitted Neovim, tmux and Starship changes

Remaining:

- Raycast personal settings recovery
- Full clean-machine bootstrap validation
- Machine-specific shell dependency provisioning
- Application-level recovery verification
- Off-device encrypted backup
- Installer concurrency and interruption hardening

## 9. Migration Status

Use the following states:

- Retain
- Consolidate
- Replace
- Archive
- Remove
- Needs investigation

Each decision requires a reason and verification.
