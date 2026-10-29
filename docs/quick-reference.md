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
| Focus previous/next monitor | Alt + Ctrl + H/L |
| Move focused window between monitors | Alt + Ctrl + Shift + H/L |
| Move entire workspace to next monitor | Alt + Shift + Tab |

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

## Yazi

| Action | Command / Shortcut |
|---|---|
| Open file manager | `y` |
| Move up / down | `k` / `j` |
| Parent / child directory | `h` / `l` |
| Choose file opener | `O` |
| Quit and change directory | `q` |
| Quit without directory change | `Q` |
| Help | `F1` |

See handbook/topics/12-yazi.md for details.

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

Run `guide` to search terminal commands, shortcuts and workflows.

Run `dothelp` to browse MacSetup configuration documentation.

In `guide`, use Alt + P to change the preview layout.
Use Ctrl + / to toggle the preview.

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
