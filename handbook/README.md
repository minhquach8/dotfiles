# Midnight Research Handbook

An interactive, keyboard-first terminal handbook for the
Midnight Research development environment.

The handbook provides searchable documentation for terminal
commands, keyboard shortcuts and development workflows.

It is designed for user-local installation on Linux, including
shared servers where sudo access is unavailable.

## 1. Overview

Run:

```bash
guide
```

The interface combines three components:

| Component | Responsibility |
| --- | --- |
| fzf | Interactive fuzzy search and navigation |
| Glow | Render Markdown in the terminal |
| Python indexer | Extract searchable entries from documentation |

The handbook supports searching for:

- Topics, such as `tmux` or `Glow`.
- Commands, such as `git --no-pager diff`.
- Keyboard shortcuts, such as `Ctrl+R`.
- Keywords included in the documentation.

Selecting a result displays the relevant documentation.

**The handbook never executes a command selected from its search results.**

## 2. Repository structure

```text
dotfiles/
├── handbook/
│   ├── README.md
│   └── topics/
│       ├── 01-quick-start.md
│       ├── 02-tmux.md
│       ├── 03-navigation.md
│       ├── 04-files-and-git.md
│       ├── 05-troubleshooting.md
│       └── 06-glow.md
└── scripts/
    ├── terminal-guide.sh
    └── handbook-index.py
```

`terminal-guide.sh` launches the interactive interface.

`handbook-index.py` reads Markdown files and generates the
search catalogue.

`handbook/topics/` contains the actual documentation.

## 3. Requirements

Required tools:

- Bash
- Python 3.9 or newer
- fzf
- Glow
- GNU `readlink` and standard Linux command-line utilities

The required executables must be available through `PATH`.

Check the installation:

```bash
command -v bash
command -v python3
command -v fzf
command -v glow

python3 --version
fzf --version
glow --version
```

On the original server, the verified tool versions include:

- fzf 0.74.5
- Glow 3.0.0

These versions describe the tested environment, not strict
minimum compatibility requirements.

Official release sources:

- fzf: https://github.com/junegunn/fzf/releases
- Glow: https://github.com/charmbracelet/glow/releases

The handbook does not install its own dependencies.

Tools described inside the documentation, such as `eza`,
`bat`, `zoxide` and `tmux`, are separate from the requirements
for running the handbook interface.

## 4. Installation

The commands below assume the dotfiles repository is located
at `~/dotfiles`.

First, install the required dependencies in user-local
directories and ensure they are available through `PATH`.

No sudo access is required by the handbook itself.

Verify that the scripts exist:

```bash
ls -l ~/dotfiles/scripts/terminal-guide.sh
ls -l ~/dotfiles/scripts/handbook-index.py
```

Ensure the launcher is executable:

```bash
chmod u+x ~/dotfiles/scripts/terminal-guide.sh
```

Create the user-local command directory:

```bash
mkdir -p ~/.local/bin
```

If `~/.local/bin/guide` does not already exist, create
the launcher symlink:

```bash
ln -s \
  "$HOME/dotfiles/scripts/terminal-guide.sh" \
  "$HOME/.local/bin/guide"
```

Do not overwrite an existing file or symlink without
checking its destination first.

Ensure `~/.local/bin` is included in `PATH`.

For the current shell, if necessary:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

To make that change persistent, incorporate it into the
existing shell configuration rather than replacing the
configuration wholesale.

For Zsh, refresh the command lookup cache if necessary:

```bash
rehash
```

Finally, launch:

```bash
guide
```

If the repository is stored somewhere other than
`~/dotfiles`, adjust the symlink source accordingly.

The launcher resolves its repository location from its
own executable path.

## 5. Keyboard controls

| Key | Action |
| --- | --- |
| Type text | Search topics, commands and shortcuts |
| Up / Down | Navigate search results |
| Enter | Render the selected entry |
| Esc | Leave the search interface |
| Ctrl+/ | Toggle the preview pane |

The interface displays the selected documentation using Glow.

When a command is indexed within a Markdown section, the
preview attempts to show the relevant section or command.

Some commands can appear in multiple results because they
are documented in more than one context.

## 6. Adding documentation

Create a new Markdown file inside:

```text
handbook/topics/
```

Use a descriptive filename such as:

```text
07-ssh.md
```

The first two lines should follow this structure:

```markdown
# SSH — Remote Access
<!-- search: ssh remote login secure shell port forwarding -->
```

The first line defines the topic title.

The second line provides additional search keywords.

Organise the remainder of the document using Markdown
headings, command tables and fenced code blocks.

For example:

````markdown
## Basic commands

| Command | Description |
| --- | --- |
| `ssh user@server` | Connect to a remote server |
| `ssh -V` | Display the SSH client version |

## Connect to a server

```bash
ssh user@server
```
````

The indexer extracts:

- Topic titles and their keywords.
- Command examples from fenced code blocks.
- Commands and shortcuts from Markdown tables.

Each command result retains its source file and line number.

The catalogue is regenerated whenever `guide` starts.

There is no separate index file to maintain.

## 7. Inspecting the search index

The indexer can be run independently:

```bash
python3 ~/dotfiles/scripts/handbook-index.py
```

Its output is tab-separated and intended primarily
for the fzf launcher.

Check the number of entries:

```bash
python3 ~/dotfiles/scripts/handbook-index.py |
  wc -l
```

Find entries associated with Glow:

```bash
python3 ~/dotfiles/scripts/handbook-index.py |
  grep -i glow
```

The indexer reads documentation only.

It does not inspect every executable installed on the system.

Consequently, an installed command will not necessarily
appear in `guide` unless it has been documented.

## 8. Markdown rendering

Glow renders the preview and selected documentation.

For direct, non-interactive rendering:

```bash
GLOW_PAGER=false PAGER=cat \
  glow -s dark -w 90 README.md
```

The `dark` style is intended for dark terminal themes.

Disabling the interactive pager allows the rendered
documentation to remain in the current terminal output.

The launcher also adjusts preview rendering width
according to the available terminal space.

## 9. Troubleshooting

### guide: command not found

Check the launcher:

```bash
ls -l ~/.local/bin/guide
```

Verify that the user-local executable directory is
included in `PATH`:

```bash
printf '%s\n' "$PATH"
```

### Missing dependency

Check the required executables:

```bash
command -v python3
command -v fzf
command -v glow
```

Install the missing dependency in an appropriate
user-local directory before relaunching.

### No search results

The search index contains documented entries, not
the complete list of installed software.

Inspect the Markdown files in `handbook/topics/`
and add the relevant documentation if needed.

### Glow output disappears

Avoid interactive pager mode when rendering content
that should remain visible in the current terminal.

Use:

```bash
GLOW_PAGER=false PAGER=cat glow -s dark README.md
```

### Launcher syntax verification

```bash
bash -n ~/dotfiles/scripts/terminal-guide.sh
```

### Indexer syntax verification

```bash
python3 -B -c \
  'import ast, pathlib; ast.parse(pathlib.Path.home().joinpath("dotfiles/scripts/handbook-index.py").read_text())'
```

### Inspect local changes

```bash
git --no-pager -C ~/dotfiles status --short
git --no-pager -C ~/dotfiles diff
```

Review existing changes before modifying or restoring
configuration files.

## 10. Reproducibility and Git

The repository stores:

- The handbook launcher.
- The Python search indexer.
- Markdown documentation.

A Git clone does not automatically restore:

- The fzf or Glow executables.
- User-local application installations.
- The `~/.local/bin/guide` symlink.
- Shell-specific `PATH` configuration.

These components must be verified or recreated on
each machine.

For changes limited to the handbook, review and stage
only the intended documentation and scripts.

Do not automatically include unrelated Zsh, tmux,
Starship or Neovim configuration changes.

The handbook is a documentation and navigation tool.
It does not replace the underlying dotfiles or
development environment configuration.
