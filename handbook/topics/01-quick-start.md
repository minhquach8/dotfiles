# Quick Start
<!-- search: ssh connect server research workflow startup -->

## Connect to the server

~~~bash
ssh username@server.example.com
~~~

## Start or resume tmux

~~~bash
tmux new-session -A -s main
~~~

## Navigate to a project

~~~bash
z dotfiles
zi
~~~

## Inspect project files

~~~bash
eza -la --icons --git
eza --tree --level=2 --icons
~~~

## Open Neovim

~~~bash
nvim README.md
~~~

## Check GPU resources

~~~bash
nvidia-smi
~~~

## Disconnect safely

Press `Ctrl+A`, release, then press `d`.

The tmux session remains available after SSH disconnects.

Do not use `tmux kill-server` merely to disconnect.
