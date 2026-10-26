# Dotfiles v2 — System Architecture

## 1. Mission

Build a reproducible, maintainable and keyboard-first
development workstation configuration.

The system must support:

- macOS as the primary development workstation.
- Linux as a development and research environment.
- Neovim-centred development workflows.
- Consistent terminal and desktop configuration.
- Safe installation, verification and recovery.
- Version-controlled documentation and configuration.

The repository is the source of truth for managed
configuration, not a complete backup of the computer.

## 2. Design Principles

### 2.1 Reproducibility

A new machine should be recoverable using documented
steps without relying on the user's memory.

### 2.2 Idempotency

Running an installation operation repeatedly must not
unnecessarily alter a correctly configured system.

### 2.3 Modularity

Core development tools, desktop customisation and
specialised research tools must remain separable.

### 2.4 Safety

The default behaviour must be non-destructive.

Existing configurations must not be overwritten without
explicit approval and a verified recovery mechanism.

### 2.5 Observability

Every operation should report:

- What was inspected.
- What changes were proposed.
- What changes were performed.
- What succeeded or failed.
- How to recover from failure.

### 2.6 Portability

Machine-specific paths, credentials and settings must
not be embedded into shared configuration unnecessarily.

## 3. System Layers

### Layer 1 — Platform Foundation

Responsibilities:

- Operating system identification.
- Hardware architecture detection.
- Package manager availability.
- System prerequisites.
- Installation permissions.

macOS and Linux must have separate platform procedures.

### Layer 2 — Development Foundation

Components:

- Git
- Zsh
- Neovim
- tmux
- Starship
- fzf
- ripgrep
- fd
- uv

Additional tools are installed through optional profiles.

### Layer 3 — Desktop Environment

macOS components:

- AeroSpace
- Ghostty
- Raycast
- SketchyBar
- JankyBorders

This layer must remain optional and macOS-specific.

### Layer 4 — Workflow Automation

Components:

- Project Launcher
- tmux session management
- Raycast Script Commands
- Keyboard shortcuts
- Development utilities

Workflow automation must not interrupt active tasks
or replace existing sessions unexpectedly.

### Layer 5 — Verification and Recovery

Responsibilities:

- Configuration validation.
- Dependency verification.
- Symlink verification.
- Service verification.
- Backup integrity.
- Rollback procedures.
- Recovery documentation.

## 4. Repository Organisation

Existing components should be preserved where possible:

- nvim/
- tmux/
- starship/
- shell/
- git/

New components may include:

- brew/
- config/
- bin/

The scripts/ directory will contain installation,
verification and recovery operations.

The docs/ directory will document architecture,
dependencies, operational procedures and decisions.

Changes to the repository structure must be reviewed
before implementation.

## 5. Installation Lifecycle

The target workflow is:

    Inspect
       |
       v
    Plan
       |
       v
    Review and Approve
       |
       v
    Backup
       |
       v
    Apply
       |
       v
    Verify
       |
       v
    Record Checkpoint

### 5.1 Inspect

Read the current system state without modification.

### 5.2 Plan

Produce an explicit description of proposed changes.

A dry run must not modify system state.

### 5.3 Approve

Require explicit user approval for changes.

### 5.4 Backup

Preserve affected existing configurations before
replacement or migration.

### 5.5 Apply

Perform only the approved changes.

### 5.6 Verify

Validate both configuration and relevant behaviour.

### 5.7 Checkpoint

Record changes, verification results and recovery
information before considering Git publication.

## 6. Configuration Ownership

Each managed configuration must have one canonical
source within the repository.

Deployment may use symbolic links where appropriate.

Installation must distinguish between:

- Missing configuration.
- Correct existing symlink.
- Incorrect existing symlink.
- Existing regular file.
- Existing directory.
- Broken symlink.

A correct existing configuration must be left unchanged.

Conflicts must be reported before replacement.

## 7. Dependency Management

Homebrew dependencies should be organised into profiles:

- Core
- Desktop
- Research
- Optional

Installing a profile must not automatically remove
packages outside that profile.

Versions and compatibility constraints should be
documented where reproducibility requires them.

System services must not be enabled automatically
without approval.

## 8. Platform Separation

Shared configuration may be reused across platforms,
but platform-specific dependencies must remain isolated.

macOS-specific installation logic must not affect Linux.

Linux installation must prefer user-space changes where
appropriate, particularly on shared research servers.

No setup operation may disrupt active research jobs.

## 9. Security Boundaries

The repository must not contain:

- Private SSH keys.
- Passwords.
- API tokens.
- Authentication cookies.
- Database credentials.
- Private research datasets.
- Unencrypted personal application exports.
- Machine-specific secrets.

Sensitive settings must be provided through secure,
local mechanisms outside version control.

All files must be reviewed before publication.

## 10. Recovery Strategy

Recovery must operate at multiple levels:

1. Individual configuration restoration.
2. Dotfiles deployment rollback.
3. Application and dependency reconstruction.
4. Full workstation recovery guidance.

A readable backup archive alone does not demonstrate
successful recovery.

Recovery procedures must eventually be tested in
an isolated or disposable environment.

## 11. Git Workflow

The existing Git repository and history will be retained.

Development changes should follow:

    Inspect -> Edit -> Validate -> Review
            -> Commit -> Push -> Verify

Uncommitted changes must not be discarded automatically.

Commits should represent meaningful, reviewable changes.

No force push or destructive Git operation is permitted
without explicit approval.

## 12. Verification Requirements

Verification must cover:

- Expected commands and versions.
- Configuration syntax.
- Correct symlink destinations.
- Required application availability.
- Service health.
- Keyboard shortcut behaviour.
- Terminal and editor integration.
- Multi-monitor desktop behaviour.
- Recovery readiness.

A successful command exit code is not always sufficient
to establish functional correctness.

## 13. Known Issues and Technical Debt

The following issues are known at the start of v2:

- Existing installation scripts are not fully idempotent.
- Some development paths are machine-specific.
- macOS desktop configuration is not fully tracked.
- Multiple historical configuration backups exist.
- Dependency inventories require consolidation.
- Raycast configuration is not fully reproducible.
- SketchyBar and window layout require multi-monitor
  compatibility verification.
- Existing documentation contains outdated references.

These issues must be resolved through controlled,
individually verified changes.

## 14. Completion Criteria

Dotfiles v2 is considered operational when:

- A clean macOS environment can be provisioned from
  documented instructions.
- Repeated installation is safe.
- Core development workflows function correctly.
- Desktop configuration can be reconstructed.
- Linux setup remains functional.
- Backup and rollback procedures are verified.
- Secrets remain outside the repository.
- Documentation accurately reflects implementation.

## 15. Change Control

The user retains final authority over all changes.

Before performing a new change:

1. Present the objective.
2. Explain the expected impact.
3. Identify risks and alternatives.
4. Obtain approval.
5. Perform the approved operation.
6. Verify the result.

This document defines the intended architecture.
It does not claim that every component is implemented.
