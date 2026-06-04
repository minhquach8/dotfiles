# Workstation Overview

This repository defines my reproducible development environment.

## Core principle

The dotfiles repository is the source of truth. Individual machines should be treated as replaceable.

## Target machines

- macOS workstation
- Linux personal workstation
- Linux shared server

## Current golden environment

The current reference environment is my MacBook Pro.

## Shell

- zsh
- Oh My Zsh
- Starship prompt

## Prompt theme

- Starship
- Gruvbox Dark palette
- Nerd Font symbols

## Editor

- Neovim
- Catppuccin Mocha colour scheme
- Telescope
- Oil.nvim
- LSP
- Conform.nvim
- Gitsigns
- Trouble.nvim
- Comment.nvim
- Treesitter
- DAP and DAP UI

## Terminal workflow

- iTerm2 on macOS
- tmux
- vim-tmux-navigator
- Neovim

## Shared-server rule

On shared Linux servers, prefer user-local installation first:

- ~/.local/bin
- ~/.config
- ~/.nvm
- ~/.cargo
- ~/miniconda3

Avoid global installation unless there is no practical local alternative.
