# Disaster Recovery

## Purpose

Recover the development workstation without relying
on remembered manual configuration steps.

The repository restores managed configuration, but
does not contain personal data, credentials or complete
application state.

## macOS Recovery — Dotfiles v2

Status: live migration verified on 26 October 2026.
Complete clean-machine provisioning is not yet verified.

### 1. Prepare macOS

Install Apple Command Line Tools and Homebrew using
their official instructions.

Check:

    xcode-select -p
    brew --version

### 2. Clone the Repository

    git clone https://github.com/minhquach8/dotfiles.git
    cd dotfiles

### 3. Inspect Dependencies

    ./scripts/bootstrap-macos-v2.sh plan core desktop

    ./scripts/bootstrap-macos-v2.sh check core desktop

Read docs/dependencies.md before approving installation.

Do not install or upgrade dependencies automatically
during recovery without reviewing the proposed changes.

### 4. Review Configuration Deployment

    ./scripts/manage-macos.sh plan

Read docs/deployment.md before applying changes.

On a new workstation, existing files and application
settings must be examined before replacing them.

Installation requires explicit authorisation:

    ./scripts/manage-macos.sh apply --yes

This command is an example of the approved write mode,
not an instruction to run automatically.

Do not use --replace-different without reviewing
every existing differing configuration.

### 5. Verify Managed Configuration

    ./scripts/manage-macos.sh verify

Expected result for a complete deployment:

    MANAGED: 16
    VERIFY: PASS

This validates symlinks, not application behaviour.

### 6. Restore Wallpaper

See docs/wallpapers.md.

The source artwork and monitor-specific images are
stored under assets/wallpapers/midnight-research/.

Wallpaper assignments must currently be restored
through macOS System Settings.

### 7. Restore Application Settings

Manual work may still be required for:

- Raycast shortcuts, Hyper Key and preferences
- Accessibility and Automation permissions
- Display arrangement
- Application login items
- Oh My Zsh and shell plugins
- NVM, pnpm and Conda
- Database applications and local data

Do not copy credentials or private application
databases into the public dotfiles repository.

### 8. Functional Verification

Inspect:

- Ghostty terminal operation
- AeroSpace window navigation and workspace switching
- SketchyBar visibility and window clearance
- Neovim and tmux integration
- Starship prompt
- Raycast Script Commands
- dothelp and research-projects
- Wallpaper placement across all displays

The reference setup uses two Philips 1920x1080
displays and a built-in MacBook Retina display.

### 9. Recovery Backups

The CP7 migration retained its original files in:

    ~/.dotfiles-backup/v2/txn-9e5o55el

An independent snapshot is also retained under:

    ~/Documents/MacSetup-Recovery/CP7-pre-deployment-20261026-143904-490248

These paths refer to the original workstation.
They will not automatically exist on a replacement Mac.

Do not delete these recovery copies while they may
still be required.

Local backups alone do not protect against complete
disk loss. An encrypted off-device backup is still
required for disaster resilience.

### 10. Rollback

Read docs/deployment.md.

The transaction manager supports:

    ./scripts/manage-macos.sh rollback --yes

Do not execute rollback merely to test it on the
working desktop. It changes live symlink targets.

Review the active transaction, affected files and
recovery snapshot before approving a rollback.

## Linux

The Linux configuration is maintained separately.

The macOS v2 migration does not authorise changes
to existing Linux hosts or their installation process.

Inspect the Linux-specific scripts and documentation
before running them on a server.

## Historical macOS Scripts

The legacy scripts remain in the repository for
historical reference:

- scripts/bootstrap-macos.sh
- scripts/install-macos.sh

DO NOT use these legacy scripts for the macOS v2
recovery procedure.

## Remaining Validation

The following are not yet certified:

- End-to-end provisioning on a completely new Mac
- Full Raycast settings recovery
- Automatic macOS privacy-permission restoration
- External/off-device recovery
- Full application-level disaster recovery
