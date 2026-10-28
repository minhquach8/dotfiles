# Troubleshooting and Recovery
<!-- search: error command not found path zsh RGB font pager -->

## Command not found

Locate the executable:

~~~bash
command -v zoxide
echo "$PATH"
~~~

Test a fresh interactive Zsh:

~~~bash
zsh -ic 'whence -w z zi'
~~~

If the command works in a fresh Zsh, open a new
tmux window or restart the current shell when safe:

~~~bash
exec zsh
~~~

Do not replace a shell managing important background jobs.

## Zsh PATH problem

Never use `path` as a temporary variable.

Zsh links `path` directly to `PATH`.

Use `file_path` or `directory_path` instead.

## Verify Zsh configuration

~~~bash
zsh -n ~/.zshrc
~~~

## Check Git configuration changes

~~~bash
git --no-pager -C ~/dotfiles diff
git -C ~/dotfiles diff --check
~~~

## Inspect tmux RGB support

~~~bash
tmux display-message -p '#{client_termfeatures}'
~~~

The current Windows Terminal connection supports RGB.

## Missing Nerd Font icons

Check the font in the local terminal application.

Font rendering is controlled by the SSH client.

## Avoid interactive pagers

~~~bash
git --no-pager diff
bat --paging=never README.md
~~~

## Configuration backups

~~~bash
eza -la ~/.local/state/midnight-research/
~~~

Review the backup before restoring any configuration.
