# macOS Configuration Deployment

Status: Dotfiles v2 installer foundation.

This guide describes configuration deployment only.
It does not yet perform complete workstation provisioning,
install all dependencies, or restore macOS application permissions.

## Requirements

- macOS
- Git
- Python 3
- A local clone of this repository

External dependencies and Homebrew profiles will be
managed in later checkpoints.

## Managed Configuration

The manager currently tracks 16 destinations covering:

- Neovim
- tmux
- Starship
- Zsh
- Git
- AeroSpace
- Ghostty
- SketchyBar and its plugins
- JankyBorders
- Raycast Script Commands
- Project Launcher
- dothelp

It manages individual files rather than replacing
entire SketchyBar, Borders or Raycast directories.

## Inspect Before Installation

From the repository:

    ./scripts/manage-macos.sh plan

This is read-only.

Possible states:

- MANAGED: target links to the repository source.
- MATCHING_COPY: existing file has identical content.
- DIFFERENT_COPY: existing file has different content.
- MISSING: no target exists.
- OTHER_SYMLINK: target links somewhere else.
- BROKEN_SYMLINK: target link is broken.
- EXISTING_DIRECTORY: unmanaged directory exists.
- TYPE_CONFLICT: source and target have incompatible types.
- SOURCE_MISSING: repository source is missing.

## Verify Installation

    ./scripts/manage-macos.sh verify

Verification succeeds only when all 16 destinations
are recognised as managed symlinks.

It does not guarantee that graphical applications,
permissions or keyboard shortcuts work correctly.

## Apply Configuration

IMPORTANT: Do not use apply on the current workstation
until a live migration has been separately reviewed
and approved.

After reviewing the plan:

    ./scripts/manage-macos.sh apply --yes

This permits installation of missing targets and
migration of matching regular-file copies.

Different existing files require explicit permission:

    ./scripts/manage-macos.sh apply --yes --replace-different

This option backs up and replaces differing regular
files. It does not override conflicting directories
or unrelated symlinks.

The --yes flag authorises changes without another
interactive confirmation. Review the plan first.

## Transaction Backups

Original target files are moved into a transaction
directory under:

    ~/.dotfiles-backup/v2/

Each transaction contains a journal recording the
operations performed and original file locations.

Do not delete a transaction directory while its
deployment may need rollback.

Backup data remains on the same machine and is not
a substitute for an external backup.

## Rollback

To restore the sole unresolved transaction:

    ./scripts/manage-macos.sh rollback --yes

Rollback refuses to overwrite a target that no
longer matches the deployed symlink.

Multiple unresolved transactions require manual
review instead of automatically selecting one.

Rollback restores managed target paths. It does
not automatically reverse edits made to source
files within the Git repository.

## Idempotency

An already managed symlink is left unchanged.

Reapplying an unchanged, fully managed configuration
should perform no new deployment.

## Important Limitations

The current implementation has been tested in
disposable HOME directories but has not yet been
used to migrate the live macOS desktop.

Additional work is required for:

- Complete Homebrew dependency provisioning.
- Machine-specific shell configuration.
- Raycast settings and Hyper Key restoration.
- macOS Accessibility permissions.
- Full application-level functional verification.
- Concurrent-invocation locking.
- Additional interrupted-transaction failure tests.
- Recovery testing beyond the local filesystem.

Some applications automatically reload their
configuration. Linking a live configuration to
the repository may make future repository edits
visible immediately, without restarting the app.

Never modify the repository while assuming deployed
configuration is an independent frozen copy.

## Integration Tests

Run:

    PYTHONDONTWRITEBYTECODE=1 python3 scripts/test-manage-macos.py

The tests use disposable HOME and repository
directories and do not install live configuration.

## Current Workstation

The initial recovery snapshot is at:

    ~/Documents/MacSetup-Recovery/20261026-125307

Refer to disaster-recovery.md for the broader
recovery strategy.
