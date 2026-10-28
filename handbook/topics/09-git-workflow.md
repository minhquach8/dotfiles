# Git — Safe Research Workflow
<!-- search: git commit branch stage diff fetch pull push merge cherry-pick status checkpoint research reproducibility -->

Use Git to preserve meaningful research checkpoints.
Review changes before staging, committing or pushing.

## Inspect the repository

| Command | Description |
| --- | --- |
| `git status --short --branch` | Inspect branch and working-tree status |
| `git --no-pager diff` | Inspect unstaged changes |
| `git --no-pager diff --cached` | Inspect staged changes |
| `git --no-pager log -5 --oneline` | Inspect recent commits |
| `git --no-pager diff --check` | Check tracked unstaged diff formatting |
| `git --no-pager diff --cached --check` | Check staged diff formatting |

The `--no-pager` flag keeps Git output in the current
terminal and avoids an alternate-screen pager.

## Prepare a focused commit

Review the intended files, then stage specific paths.

~~bash
git status --short
git --no-pager diff -- path/to/file
git add -- path/to/file
git --no-pager diff --cached --stat
git --no-pager diff --cached --check
~~

Only commit after reviewing the complete staged diff.

~~bash
git --no-pager diff --cached
git commit -m "Describe the completed change"
~~

`git add` changes the Git index; `git commit` creates
a permanent local checkpoint.

Do not automatically stage the entire repository when
unrelated experiments or configuration edits are present.

## Research branches

| Command | Description |
| --- | --- |
| `git branch --show-current` | Show the active branch |
| `git branch -vv` | Inspect local branches and upstreams |
| `git switch -c experiment-name` | Create and switch to a research branch |
| `git switch main` | Return to the main branch |

Avoid switching branches if doing so would overwrite
uncommitted changes. Preserve them first.

## Compare local and remote histories

| Command | Description |
| --- | --- |
| `git fetch origin` | Update remote-tracking references |
| `git --no-pager log --left-right --oneline main...origin/main` | Compare divergent commit histories |
| `git --no-pager diff --stat main..origin/main` | Summarise tree differences |
| `git remote -v` | Inspect configured remotes |

Fetching does not merge remote changes into the current
working tree.

Inspect divergent histories before pulling or pushing.

Never use force push, hard reset, or an unreviewed
rebase as a shortcut around a conflict.

## Reproducibility

Exclude generated datasets, credentials, large model
weights and machine-specific paths when appropriate.

Check `.gitignore` before staging new research outputs.

For research checkpoints, record the question, method,
experiment configuration, results and limitations in
version-controlled documentation where practical.

## Shared dotfiles warning

The Midnight Research repository supports both Linux
and macOS.

Changes to shared files such as Neovim, Starship and
tmux configurations may affect both platforms.

Review cross-platform differences before committing
shared configuration changes.
