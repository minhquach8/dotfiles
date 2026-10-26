# Midnight Research — Quick Reference

Use this page when you forget a command or shortcut.

The AeroSpace and tmux bindings are represented in
Git-managed configuration. Raycast personal shortcuts
require manual verification during machine recovery.

## Raycast

| Action | Shortcut |
|---|---|
| Open Ghostty | Caps + T |
| Open VS Code | Caps + E |
| Open Firefox | Caps + F |
| Open Project Picker | Caps + P |
| Escape | Tap Caps Lock |

## AeroSpace

| Action | Shortcut |
|---|---|
| Focus left/down/up/right | Alt + H/J/K/L |
| Switch workspace | Alt + number |
| Move and follow | Alt + Shift + number |
| Toggle floating | Alt + Shift + Space |
| Open Ghostty | Alt + Enter |

## tmux

| Action | Command |
|---|---|
| Prefix | Ctrl + A |
| Session Picker | Ctrl + A, then Shift + P |
| List sessions | tmux ls |
| Create session | tmux new -s NAME |
| Attach session | tmux attach -t NAME |
| Detach | Ctrl + A, then D |

## Neovim

| Action | Command |
|---|---|
| Open editor | nvim |
| Open directory | nvim . |
| Save | :w |
| Quit | :q |
| Save and quit | :wq |
| Help | :help |

See nvim/CheatSheet.md for customised mappings.

## Git

| Action | Command |
|---|---|
| Check status | git status --short |
| Recent commits | git log -5 --oneline |
| Current branch | git branch --show-current |
| Unstaged diff | git diff |
| Staged diff | git diff --cached |
| Fetch | git fetch |

## Documentation

From a fresh login shell:

    dothelp

Alternatively, run ~/dotfiles/bin/dothelp.

## Important Configuration Locations

- AeroSpace: ~/.aerospace.toml
- Neovim: ~/.config/nvim
- tmux: ~/.tmux.conf
- Starship: ~/.config/starship.toml
- Zsh: ~/.zshrc
- SketchyBar: ~/.config/sketchybar
- JankyBorders: ~/.config/borders

## Recovery

Initial local recovery checkpoint:

    ~/Documents/MacSetup-Recovery/20261026-125307

This is a configuration snapshot, not a full
workstation or off-device backup.
