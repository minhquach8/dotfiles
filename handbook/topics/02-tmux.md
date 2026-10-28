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
