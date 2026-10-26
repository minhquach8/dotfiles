# Midnight Research — Documentation Hub

This is the starting point for understanding, using,
maintaining and rebuilding the workstation.

## I want to...

| Goal | Document |
|---|---|
| Learn how to use my workstation | [User Guide](user-guide.md) |
| Find a shortcut or command | [Quick Reference](quick-reference.md) |
| Find installed components and configurations | [Inventory](inventory.md) |
| Understand the system design | [Architecture](architecture-v2.md) |
| Review dependencies | [Dependencies](dependencies.md) |
| Restore Node.js and pnpm | [Node Toolchain](node-toolchain.md) |
| Restore Raycast and macOS preferences | [Personal Recovery](personal-recovery.md) |
| Protect secrets and credentials | [Security](security.md) |
| Set up a new Mac | [macOS Setup Guide](setup-macos.md) |
| Restore wallpaper and monitor layout | [Wallpaper](wallpapers.md) |
| Deploy managed configuration | [Deployment Guide](deployment.md) |
| Recover the workstation | [Disaster Recovery](disaster-recovery.md) |
| Find Neovim shortcuts | [Neovim Cheatsheet](../nvim/CheatSheet.md) |

## Quick Help

From the repository, run:

    ./bin/dothelp

This opens a searchable documentation menu.

## Documentation Status

- Verified: checked against the current system.
- Historical: previously observed or configured.
- Planned: not yet implemented.
- Needs verification: requires a live check.

Documentation must distinguish intended behaviour from
verified behaviour.

## Repository

https://github.com/minhquach8/dotfiles

This repository manages reproducible configuration.
It is not a complete backup of the workstation.

## Maintenance Principle

Every new workflow or configuration change should include:

1. A working implementation.
2. Relevant usage instructions.
3. A verification procedure.
4. Recovery information when applicable.
