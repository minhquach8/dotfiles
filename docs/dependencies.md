# Dependency Management

## Purpose

This document defines how software dependencies are
selected, installed and maintained for Midnight Research.

The Brewfiles describe desired packages, not a complete
snapshot of all software installed on the machine.

## Homebrew Profiles

| Profile | File | Purpose |
|---|---|---|
| Core | brew/Brewfile.core | Development fundamentals |
| Desktop | brew/Brewfile.desktop | macOS desktop workflow |
| Research | brew/Brewfile.research | Research and publishing tools |
| Optional | brew/Brewfile.optional | Specialised utilities |

Core and Desktop form the proposed default macOS setup.

Research and Optional require separate selection.

## Bootstrap Python

The Core profile explicitly requests python@3.14.

This provides a predictable Python minor version for
the current workstation bootstrap baseline.

Use python3.14 when selecting that interpreter
explicitly. Do not assume that python3 always points
to the same minor version on every machine.

Research projects may use other Python versions
through Conda, uv or virtual environments.

Do not modify existing project environments during
workstation bootstrap.

## Inspect Dependencies

From the repository:

    ./scripts/check-brewfiles.sh

This lists profiles and checks installation status.

A missing dependency is a report, not permission
to install software automatically.

## Installing a Profile

Installation must be performed only after reviewing
the profile and approving its dependencies.

Example for the Core profile:

    brew bundle install --no-upgrade --file=brew/Brewfile.core

Do not run this automatically during inventory work.

## Package Management Policy

- Do not automatically uninstall unrelated packages.
- Do not automatically upgrade the entire system.
- Do not enable database services during desktop setup.
- Do not run automatic Homebrew cleanup.
- Review dependencies before installation.
- Keep machine-specific tools optional.

## Version Reproducibility

Homebrew generally tracks available formula versions.
Brewfiles do not provide exact version locking.

Where exact versions are required, record them
separately and document compatible alternatives.

## Other Dependency Managers

The complete environment may additionally require:

- Conda for selected Python environments.
- nvm for Node.js versions.
- pnpm for JavaScript development.
- Neovim's plugin manager.
- macOS Accessibility permissions.
- Raycast settings restored separately.

These are not yet fully managed by the Brewfiles.

## Pending Audit

Further inventory work must establish ownership
and installation methods for:

- Firefox
- Visual Studio Code
- Miniconda
- PostgreSQL
- TeX distribution
- Other historical research applications

Do not assume a tool should be uninstalled merely
because it is absent from the Brewfiles.

## Current Status

The initial profiles are proposed configuration.
They require validation against installed packages
and testing on a clean macOS environment.

See setup-macos.md once the bootstrap workflow
is implemented.
