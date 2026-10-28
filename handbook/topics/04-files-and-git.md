# Files and Git — eza, bat and Git
<!-- search: eza bat ls cat tree git diff status pager -->

## eza: File listing

~~~bash
eza -la --icons --git
eza --tree --level=2 --icons
~~~

The original `ls` command remains unchanged.

## bat: Read source files

~~~bash
bat --paging=never README.md
bat --paging=never --style=numbers script.py
bat --paging=never --style=numbers,changes script.py
~~~

Use `--paging=never` to avoid an interactive pager.

## Git without pagers

~~~bash
git --no-pager status --short
git --no-pager diff
git --no-pager diff --cached
git --no-pager log -5 --oneline
~~~

## Personal dotfiles

~~~bash
git --no-pager -C ~/dotfiles status --short
git --no-pager -C ~/dotfiles diff
git -C ~/dotfiles diff --check
~~~

Always review changes before committing.

Never reset or overwrite uncommitted configuration
without reviewing it first.
