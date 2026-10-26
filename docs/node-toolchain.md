# Node.js and pnpm Recovery

## Purpose

Restore the JavaScript development toolchain without
disrupting existing research projects or global tools.

## Observed Workstation State

Verified on 26 October 2026:

- Node.js: v22.23.3
- npm: 10.9.9
- Corepack: 0.36.0
- Node.js installed through NVM
- pnpm CLI: unavailable
- Historical pnpm home: ~/Library/pnpm

The historical pnpm directory contains utilities and
package data. Preserve it until its contents have
been reviewed.

## Node.js Ownership

NVM manages Node.js installations on this workstation.

Do not install another global Node.js runtime merely
because a Homebrew profile does not list Node.

On a replacement workstation:

1. Install NVM using its official instructions.
2. Restore the required Node.js version.
3. Verify node and npm in a fresh login shell.
4. Restore project-specific Node.js versions as needed.

The observed Node.js version is a workstation
reference, not a requirement for every project.

## pnpm

The pnpm CLI is currently unavailable on the
reference workstation.

The official pnpm installation documentation is:

https://pnpm.io/installation/

As of October 2026, pnpm 12 is the current release
line. Its npm-based installer supports Node.js
22.13 or newer.

Official installation command:

    npx get-pnpm

This command downloads and installs software.
It must not run automatically during readiness
audits or bootstrap inspection.

Do not assume Corepack is the preferred installer
for current pnpm releases. The pnpm maintainers
changed their recommendation in August 2026.

After installation, verify:

    command -v pnpm
    pnpm --version

For project reproducibility, prefer an explicit
packageManager version in the project's package.json
and retain its lockfile.

Do not overwrite project packageManager fields
or modify lockfiles during workstation setup.

## Existing Global Utilities

The pnpm home may contain:

- acorn
- eslint
- eslint_d
- global package metadata
- historical package store

Their presence does not establish that pnpm is
installed or working.

Do not delete this directory during cleanup.

## Other Shell Dependencies

Oh My Zsh, shell plugins, NVM and Conda require
separate restoration procedures.

The existing Zsh configuration detects some
optional dependencies but does not install them.

The PostgreSQL path is currently machine-specific
and must be checked during a clean-Mac migration.

## External Applications

Firefox and Visual Studio Code are installed on
the reference workstation but were not installed
as Homebrew casks according to the CP10 audit.

Their absence from the Brewfiles does not mean
they are absent from the current machine.

Install them using approved official sources on
a replacement Mac. Do not automatically replace
working applications to change package ownership.

## Verification

Run:

    python3 scripts/audit-macos-readiness.py

Interpret inherited PATH and fresh login-shell PATH
as separate environments.

A reported missing optional tool does not authorise
automatic installation.

## Outstanding Work

- Restore and validate pnpm when required.
- Verify NVM and Oh My Zsh installation on a clean Mac.
- Audit machine-specific shell paths.
- Restore Raycast personal settings securely.
- Test complete application provisioning.
