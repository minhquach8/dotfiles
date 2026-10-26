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

Dotfiles v2 is being developed and verified.

Start with the [macOS Setup Guide](docs/setup-macos.md).

For inspection on an existing Mac:

    ./scripts/bootstrap-macos-v2.sh plan core desktop
    ./scripts/manage-macos.sh plan

Do not run the historical macOS installer as part
of the v2 migration.

The new installation procedure is not yet certified
for complete clean-machine provisioning.

## Documentation

See the [Documentation Hub](docs/README.md) for:

- Daily user guide
- Keyboard shortcuts and commands
- Deployment and recovery procedures
- Dependency profiles
- System architecture and inventory

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
