# tmux — Sessions and Shortcuts
<!-- search: tmux pane window prefix attach detach split resize -->

## Session management

| Command | Description |
|---|---|
| `tmux ls` | List sessions |
| `tmux attach -t main` | Attach to main |
| `tmux new -s research` | Create research session |
| `tmux new-session -A -s main` | Attach or create |
| `tmux source-file ~/.tmux.conf` | Reload configuration |

## Prefix: Ctrl+A

Press Ctrl+A, release, then press the next key.

| Shortcut | Action |
|---|---|
| Prefix + c | Create a window |
| Prefix + d | Detach |
| Prefix + n | Next window |
| Prefix + p | Previous window |
| Prefix + 0-9 | Select numbered window |
| Prefix + vertical bar | Split left/right |
| Prefix + minus | Split top/bottom |
| Prefix + m | Zoom or restore pane |
| Prefix + r | Reload configuration |
| Prefix + s | Toggle synchronised panes |
| Prefix + [ | Enter copy mode |

## Pane navigation

Use `Ctrl+H/J/K/L` to move between tmux panes
and Neovim windows.

Resize panes with Prefix + h/j/k/l.

## Copy mode

Enter with Prefix + [.

Press `v` to begin selecting and `y` to copy.

## Installed plugins

- TPM
- vim-tmux-navigator
- tmux-resurrect
- tmux-continuum

The autosave hook is configured.
Automatic session restoration is disabled.

## Copy to local clipboard through Ubuntu RDP

On the Linux RDP session, tmux copy-mode can copy text
directly into the Ubuntu X11 clipboard using xclip.

The RDP clipboard redirection then allows the text
to be pasted on the local computer.

### Keyboard-only workflow

| Shortcut | Description |
| --- | --- |
| `Ctrl+A` then `[` | Enter tmux copy-mode |
| `h/j/k/l` | Navigate through terminal output |
| `Space` or `v` | Begin text selection |
| `y` | Copy selection to tmux and X11 clipboard |
| `Ctrl+V` (local) | Paste on the local computer |

This workflow requires no mouse selection.

### Clipboard requirements

- An X11 session with a valid DISPLAY.
- xclip installed and available in PATH.
- RDP clipboard redirection functioning correctly.

The Linux tmux configuration uses xclip when these
conditions are detected during configuration loading.
Otherwise, it retains the standard tmux copy behaviour.

### Important limitation

tmux keybindings apply to the tmux server, not to
individual RDP or SSH clients.

The X11 clipboard integration has been verified through
Ubuntu RDP. Clipboard forwarding through SSH terminals
such as Ghostty requires separate verification.

### Troubleshooting

Inspect the active binding:

~~~bash
tmux list-keys -T copy-mode-vi y
~~~

Inspect clipboard-related settings:

~~~bash
tmux show-option -s set-clipboard
tmux show-option -s copy-command
~~~

Test X11 clipboard redirection:

~~~bash
printf 'CLIPBOARD-TEST\n' | xclip -selection clipboard
~~~

Paste on the local computer to verify the result.
