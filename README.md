# My Development Dotfiles

Personal development environment repository used across macOS workstations and Linux servers.

## Philosophy

Configuration should live in Git.

A new machine should be recoverable through documented and repeatable steps rather than relying on memory.

For shared Linux servers, always prefer user-space and local installations before considering system-wide changes.

## Repository Structure

```text
docs/
├── dependencies.md
├── workstation-overview.md
└── disaster-recovery.md

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
├── bootstrap-macos.sh
├── install-linux.sh
├── install-macos.sh
├── verify-linux.sh
└── verify-macos.sh
```

## Supported Platforms

### macOS

Primary development workstation.

### Linux

Shared research servers and development machines.

Local-first installation is preferred whenever possible.

## Linux Setup

```bash
git clone <repository>

cd dotfiles

./scripts/bootstrap-linux.sh

./scripts/install-linux.sh

exec zsh

./scripts/verify-linux.sh
```

## macOS Setup

```bash
git clone <repository>

cd dotfiles

./scripts/bootstrap-macos.sh
./scripts/install-macos.sh
exec zsh
./scripts/verify-macos.sh

exec zsh
```

## Verification

Linux verification:

```bash
./scripts/verify-linux.sh
```

Checks:

- git
- zsh
- tmux
- starship
- uv
- Neovim
- Oh My Zsh
- zsh-autosuggestions
- zsh-syntax-highlighting
- dotfiles symlinks

## Documentation

- dependencies.md
- workstation-overview.md
- disaster-recovery.md
