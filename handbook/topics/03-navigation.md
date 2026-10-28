# Navigation — fzf and zoxide
<!-- search: fzf zoxide history fuzzy ctrl-r ctrl-t alt-c -->

## fzf shortcuts

| Shortcut | Action |
|---|---|
| Ctrl+R | Search command history |
| Ctrl+T | Search files |
| Alt+C | Find and change directory |
| Esc | Cancel search |

## Open a file in Neovim

1. Type `nvim `.
2. Press Ctrl+T.
3. Search for a file.
4. Press Enter to insert its path.
5. Execute the command.

## Search files with ff

~~~bash
ff
~~~

## zoxide

| Command | Action |
|---|---|
| `z dotfiles` | Jump to dotfiles |
| `z genetics` | Jump to a remembered project |
| `zi` | Interactive directory selection |
| `zoxide query -l` | List remembered directories |

zoxide learns from normal directory visits.

If a directory is unknown, visit it using `cd` first.

## Verify installation

~~~bash
whence -w z zi
fzf --version
zoxide --version
~~~
