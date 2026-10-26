# Security Policy

## 1. Purpose

The dotfiles repository must reproduce the development
environment without exposing private information.

## 2. Do Not Commit

- SSH private keys
- Passwords and recovery codes
- API tokens
- Authentication cookies
- Database credentials
- Private certificates
- Personal application databases
- Private research datasets
- Unencrypted Raycast exports
- Conda environments and application caches

## 3. Configuration Boundaries

Shared configuration should not contain
machine-specific secrets.

Prefer local, untracked configuration overrides
for private paths and credentials.

Document the required variables without
publishing their values.

## 4. Before Committing

Review:

    git status --short
    git diff --check
    git diff --cached

Confirm that the staged changes contain only
the intended files.

Do not assume .gitignore prevents all secret leaks.

## 5. Before Pushing

- Check the current branch and remote.
- Review newly added files.
- Inspect configuration for secrets.
- Confirm backup archives are not included.
- Verify the commit contains approved changes.

## 6. Raycast

Raycast Script Commands may be tracked in Git.

Personal settings, private data and exports
require separate protection.

Unencrypted exports must not be committed.

## 7. Recovery

Local configuration checkpoints are stored under:

    ~/Documents/MacSetup-Recovery

They must remain outside this Git repository.

A separate encrypted or off-device backup should
eventually be established.

## 8. Installation Safety

Installation scripts must:

- Be reviewable.
- Describe intended changes.
- Avoid destructive defaults.
- Protect existing files.
- Support validation and recovery.
- Avoid interrupting active research jobs.

## 9. Credential Exposure

If a credential is accidentally published:

1. Revoke or rotate it.
2. Determine its exposure scope.
3. Remove it from the repository and history
   through an approved recovery procedure.
4. Confirm the old credential no longer works.

Deleting a file in a later commit does not
remove it from Git history.
