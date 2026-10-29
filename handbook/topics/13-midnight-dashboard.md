# Midnight Research Dashboard — macOS
<!-- search: midnight dashboard popup macos ghostty tmux projects handbook yazi launcher -->

## Purpose

Midnight Research Dashboard provides a small,
keyboard-driven launcher for existing terminal tools.

It runs only when requested and requires no background
service.

The dashboard is intended for macOS. It is not part
of the shared Linux server configuration.

## Open the dashboard

~~~bash
midnight
~~~

## Keyboard controls

| Shortcut | Action |
| --- | --- |
| Up / Down | Navigate menu |
| Enter | Open selected tool |
| Esc | Close dashboard |

## Available actions

| Tool | Description |
| --- | --- |
| Projects | Open the tmux Project Picker |
| Handbook | Open Guide |
| Files | Open Yazi |
| System | Show basic Mac information |

Projects requires an active tmux session.
Selecting a project may switch tmux sessions.

Files launches Yazi directly. Use the Zsh command
`y` instead when directory tracking is required.

## Direct commands

~~~bash
guide
yazi
midnight
~~~

The Zsh wrapper `y` is also available on the
configured macOS environment.

The Dashboard is optional. All underlying tools
remain independently accessible.

## Safety and recovery

The dashboard does not modify project files
or automatically execute Git operations.

Its launcher is stored at:

    bin/midnight

On the managed Mac, the command is linked at:

    ~/.local/bin/midnight

The macOS deployment manager verifies this symlink.

Do not assume the dashboard is installed on Linux.
