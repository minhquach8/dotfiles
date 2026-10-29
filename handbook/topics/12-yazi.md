# Yazi — Terminal File Manager
<!-- search: yazi files folders preview image pdf markdown neovim editor cwd navigation -->

## Purpose

Yazi provides keyboard-driven file navigation and previews.

It can display source files, Markdown, images and PDF previews
when the necessary terminal and preview tools are available.

## Launch Yazi

~~~bash
yazi
~~~

On Midnight Research macOS, use the Zsh wrapper:

~~~zsh
y
~~~

The wrapper is configured in `shell/.zshrc.macos`.

It records the last Yazi directory and updates the shell
working directory after exiting with `q`.

This wrapper is specific to the configured Mac environment.
Do not assume it is installed on other Linux machines.

## Navigation shortcuts

| Shortcut | Action |
| --- | --- |
| `j` / `k` | Move down / up |
| `h` / `l` | Parent / child directory |
| `.` | Toggle hidden files |
| `F1` | Open Yazi help |
| `q` | Quit and report the current directory |
| `Q` | Quit without changing the shell directory |
| `O` | Choose how to open a file |
| `Tab` | Display file information |

## Open source files with Neovim

On Midnight Research macOS, new Zsh sessions use:

~~~zsh
echo "$EDITOR"
echo "$VISUAL"
~~~

Both are configured as `nvim`.

In Yazi, select a source file, press `O` and choose Edit.

Quit Neovim with `:q` to return to Yazi.

## Working with research projects

~~~bash
cd ~/dotfiles
y
~~~

Use Yazi to inspect project structures, Markdown documents,
research images and PDF files.

The original project launcher and tmux sessions are unchanged.

## Safety

Yazi also supports moving, renaming and deleting files.
These operations modify the filesystem.

Review the selected files and Yazi's help before using
destructive actions on research data.

## Installation and portability

On macOS, Yazi is recorded in `brew/Brewfile.core`.

On Linux, installation is independent and user-local
where necessary. Nothing in this document installs Yazi
or changes shared server configuration.
