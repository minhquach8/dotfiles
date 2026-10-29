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
| Yazi | Terminal file manager |
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

The Git-managed launcher is available at
~/.local/bin/research-projects.
The historical research-projects-v2 copy has not
been approved for deletion.

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
| Focus previous/next monitor | Alt + Ctrl + H/L |
| Move focused window between monitors | Alt + Ctrl + Shift + H/L |
| Move entire workspace to next monitor | Alt + Shift + Tab |

Status: bindings verified in the Git-managed
AeroSpace configuration. Individual shortcuts should
still be checked during clean-machine recovery.

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

All 17 managed deployment targets, including Guide,
were verified on 29 October 2026.

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

Two documentation tools are available.

`guide` opens the interactive Midnight Research Handbook.
It uses fzf for searching and Glow for Markdown previews.
It can be launched from any directory, including inside tmux.

`dothelp` opens the MacSetup documentation picker.

The two commands serve different purposes and are
maintained separately.

The handbook source is located at:

    handbook/README.md

The MacSetup documentation hub is located at:

    docs/README.md

## 10. Desktop Layout

The SketchyBar overlap was resolved and verified
on 26 October 2026.

AeroSpace uses a top gap of 44 on external Philips
monitors and 12 on the built-in Retina display.

See docs/wallpapers.md for the display layout
and Midnight Research wallpaper assets.

## 11. Using Yazi

Run `y` to open the Yazi file manager with directory tracking.

Navigate with `h`, `j`, `k` and `l`. Press `q` to return
to Zsh in the selected directory, or `Q` to leave the
original directory unchanged.

Press `O` on a source file and choose Edit to open Neovim.

New Zsh sessions configure `EDITOR=nvim` and `VISUAL=nvim`.

The source file for the wrapper is `shell/.zshrc.macos`.

For complete keyboard guidance, run `guide` and search
for Yazi.

## 12. Midnight Research Dashboard

The `midnight` command opens a minimal, on-demand
terminal dashboard.

It is intended for macOS with Ghostty and tmux.

The dashboard provides four actions:

- Projects: open the existing tmux Project Picker.
- Handbook: launch the searchable terminal guide.
- Files: open Yazi in the current terminal pane.
- System: display basic macOS system information.

Use Up/Down to navigate, Enter to select and Esc to exit.

Inside tmux, fzf displays the dashboard as a popup.
The selected tool opens after the menu closes.

Opening Projects may switch to another tmux session.
Existing sessions are preserved.

The Files action runs Yazi directly. To browse files
and then change the current Zsh directory, use `y`
instead.

The dashboard does not start automatically, install
background services or replace existing shortcuts.

Source: `bin/midnight`
Installed command: `~/.local/bin/midnight`

The dashboard is macOS-specific. Linux workstations
can continue using `guide` independently.
