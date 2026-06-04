# My Development Dotfiles

Personal development environment repository used across macOS workstations and Linux servers.

## Goals

- Reproducible development environment
- Local-first installation on shared Linux systems
- Consistent Neovim workflow
- Consistent tmux workflow
- Shared shell and terminal experience
- Fast workstation recovery

## Repository Structure

```text
docs/
├── dependencies.md
└── workstation-overview.md

git/
└── .gitconfig

nvim/
├── init.lua
├── lazy-lock.json
└── lua/

shell/
├── .zshrc.linux
└── .zshrc.macos

starship/
└── starship.toml

tmux/
└── .tmux.conf

scripts/
├── bootstrap-linux.sh
├── install-linux.sh
└── verify-linux.sh
```

## Supported Platforms

### macOS

Primary workstation environment.

Includes:

- Neovim
- tmux
- zsh
- Oh My Zsh
- Starship
- Conda
- Git
- fzf
- NVM
- pnpm

### Linux

User-space development environment intended for shared research and university servers.

Principles:

- Prefer local installation under `$HOME`
- Avoid system-wide changes whenever possible
- Minimise conflicts with other users

## Installation Workflow

### Linux

```bash
git clone <repository>

cd dotfiles

./scripts/bootstrap-linux.sh

./scripts/install-linux.sh

exec zsh

./scripts/verify-linux.sh
```

## Verification

The verification script checks:

- git
- zsh
- tmux
- starship
- uv
- Neovim
- Oh My Zsh
- zsh-autosuggestions
- zsh-syntax-highlighting

and validates the expected symlink structure.

## Documentation

- `docs/workstation-overview.md`
  - Hardware and workstation inventory

- `docs/dependencies.md`
  - External tools and package dependencies

## Philosophy

Configuration should live in Git.

A new machine should be recoverable through documented and repeatable steps rather than manual memory.
