# Midnight Research — User Guide

Practical instructions for the daily use of the
macOS research and development workstation.

## 1. Understanding the Environment

| Tool | Purpose |
|---|---|
| Raycast | Application and workflow launcher |
| AeroSpace | macOS window management |
| Ghostty | Terminal emulator |
| tmux | Persistent terminal sessions |
| Neovim | Code and text editor |
| Starship | Shell prompt |
| SketchyBar | Desktop status bar |
| JankyBorders | Focused-window highlighting |

AeroSpace manages macOS windows.
tmux manages terminal sessions and panes.
Neovim manages editing buffers and windows.

## 2. Opening Applications

Previously configured Raycast Hyper Key shortcuts:

| Action | Shortcut |
|---|---|
| Ghostty | Caps + T |
| VS Code | Caps + E |
| Firefox | Caps + F |
| Project Picker | Caps + P |
| Escape | Tap Caps Lock |

Status: historical configuration, pending live verification.

## 3. Opening a Research Project

1. Press Caps + P.
2. Type a project name.
3. Select the project.
4. The Project Launcher opens or reuses its tmux session.

Previously configured project search locations:

- ~/Projects
- ~/projects
- ~/Documents
- ~/dotfiles

Current implementation locations:

- ~/.local/bin/research-projects
- ~/.local/bin/research-projects-v2
- ~/.config/raycast/scripts/research-projects.sh

These implementations require consolidation in v2.

## 4. Managing Windows with AeroSpace

| Action | Shortcut |
|---|---|
| Focus left | Alt + H |
| Focus down | Alt + J |
| Focus up | Alt + K |
| Focus right | Alt + L |
| Switch workspace | Alt + number |
| Move and follow window | Alt + Shift + number |
| Toggle floating | Alt + Shift + Space |
| Open Ghostty | Alt + Enter |

Status: historical configuration, pending verification
against the active AeroSpace configuration.

## 5. Using tmux

Useful commands:

    tmux ls
    tmux new -s research
    tmux attach -t research

Configured prefix:

    Ctrl + A

Configured session picker:

    Ctrl + A, then Shift + P

To detach from a session, press the prefix and then D
using the standard tmux binding.

Detaching preserves the running tmux session.

Avoid terminating active research processes
when switching between terminal sessions.

## 6. Using Neovim

Open Neovim:

    nvim

Open the current directory:

    nvim .

Basic editor commands:

| Action | Command |
|---|---|
| Save | :w |
| Quit | :q |
| Save and quit | :wq |
| Quit without saving | :q! |
| Open help | :help |

For customised mappings, read:

- nvim/CheatSheet.md
- nvim/README.md

## 7. Finding Configuration Files

| Component | Active path |
|---|---|
| Zsh | ~/.zshrc |
| Git | ~/.gitconfig |
| tmux | ~/.tmux.conf |
| Neovim | ~/.config/nvim |
| Starship | ~/.config/starship.toml |
| AeroSpace | ~/.aerospace.toml |
| Ghostty | ~/Library/Application Support/com.mitchellh.ghostty/config.ghostty |
| SketchyBar | ~/.config/sketchybar |
| JankyBorders | ~/.config/borders |
| Raycast scripts | ~/.config/raycast/scripts |

The first five were verified as dotfiles symlinks
on 26 October 2026.

## 8. Changing a Configuration

1. Identify the active configuration.
2. Find its authoritative source.
3. Review the current Git state.
4. Back up affected files if necessary.
5. Apply one controlled change.
6. Validate configuration syntax.
7. Test the affected workflow.
8. Update documentation.
9. Commit only reviewed changes.

## 9. Finding Help

From the dotfiles repository:

    ./bin/dothelp

Or open the documentation hub:

    docs/README.md

## 10. Known Desktop Issue

On 26 October 2026, external-monitor screenshots
showed SketchyBar overlapping window content.

The root cause is not yet confirmed.

This must be resolved and tested on the external
monitor before desktop setup is considered complete.
