# macOS Setup Guide

## Status

Dotfiles v2 is under active development.

The Homebrew profiles have passed checks on the
existing workstation.

The configuration manager has successfully migrated
and verified all 16 targets on the live desktop.

A complete clean-machine provisioning test has not
yet been performed.

Do not treat this guide as a fully validated
one-command workstation installation.

## 1. Prerequisites

Target platform:

- macOS
- Apple Silicon
- Internet access for package installation
- Git and Apple Command Line Tools
- Homebrew

Install Apple Command Line Tools if missing:

    xcode-select --install

Follow the official Homebrew instructions:

https://brew.sh

## 2. Clone the Repository

Using an HTTPS URL avoids depending on a personal
SSH host alias.

    cd ~
    git clone https://github.com/minhquach8/dotfiles.git
    cd dotfiles

## 3. Inspect Dependencies

    ./scripts/bootstrap-macos-v2.sh plan core desktop

Check the installed dependencies:

    ./scripts/bootstrap-macos-v2.sh check core desktop

A missing dependency does not automatically
authorise installation.

## 4. Review the Brewfiles

The default proposed profiles are:

- brew/Brewfile.core
- brew/Brewfile.desktop

Additional profiles:

- brew/Brewfile.research
- brew/Brewfile.optional

Inspect them before installation.

The bootstrap install mode requires explicit --yes,
but it is not yet the recommended clean-machine
installation procedure.

## 5. Inspect Configuration Deployment

    ./scripts/manage-macos.sh plan

The configuration manager supports:

- plan
- verify
- apply
- rollback

Read docs/deployment.md before using write modes.

Do not apply the current shared shell configuration
on a new machine until portability issues are resolved.

## 6. Current Portability Limitations

The existing macOS Zsh configuration references:

- Oh My Zsh
- Shell plugins
- Starship
- Conda
- NVM
- pnpm
- PostgreSQL

Some dependencies are not yet managed by the
new bootstrap profiles.

Certain paths are specific to the existing machine.

See node-toolchain.md for NVM, Node.js and pnpm recovery.
Do not automatically install pnpm or replace existing
Node.js environments during bootstrap.

These issues must be resolved before a clean-machine
setup can be declared complete.

For Raycast exports, Hyper Key, login items and privacy permissions,
see personal-recovery.md.

## 7. Desktop Permissions

Application installation alone does not reproduce
all macOS settings.

Additional setup may be needed for:

- Accessibility permissions
- Raycast Hyper Key
- Global keyboard shortcuts
- Application login items
- Display configuration
- macOS System Settings

These steps must be documented and verified separately.

## 8. Verification

Current checks:

    ./scripts/test-bootstrap-macos-v2.sh

    PYTHONDONTWRITEBYTECODE=1 \
      python3 scripts/test-manage-macos.py

    ./scripts/manage-macos.sh plan

Deployment verification:

    ./scripts/manage-macos.sh verify

A successful deployment verification checks managed
symlinks; it does not establish full application
functionality.

## 9. Recovery

See:

- docs/deployment.md
- docs/disaster-recovery.md
- docs/security.md

Do not erase the previous workstation or remove
existing recovery snapshots during migration.
