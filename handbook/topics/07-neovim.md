# Neovim — Development Workflow
<!-- search: nvim vim neovim editor coding telescope oil lsp diagnostics buffers windows splits tmux navigation rename symbol -->

A keyboard-first development workflow using Neovim.

This guide documents verified Linux keybindings, standard
Neovim operations, and available plugins.

## Leader key

The configured leader key is Space.

For example, `Space w` means press Space, then `w`,
while in Normal mode.

## Verified custom keybindings

| Shortcut | Description |
| --- | --- |
| `Space w` | Save the current buffer |
| `Space q` | Quit the current window |
| `Ctrl+h` | Move to the left Neovim window |
| `Ctrl+j` | Move to the window below |
| `Ctrl+k` | Move to the window above |
| `Ctrl+l` | Move to the window on the right |
| `Space Space` | Clear search highlighting |
| `kj` | Leave Insert mode |
| `Space cs` | Insert a Python section comment |

These bindings are defined in `lua/config/keymaps.lua`.

The `kj` shortcut works in Insert mode. The others above
are Normal-mode shortcuts.

## Editing basics

| Command | Description |
| --- | --- |
| `i` | Enter Insert mode |
| `a` | Insert after the cursor |
| `Esc` | Return to Normal mode |
| `u` | Undo |
| `Ctrl+r` | Redo |
| `dd` | Delete the current line |
| `yy` | Yank the current line |
| `p` | Paste after the cursor |
| `gg` | Move to the first line |
| `G` | Move to the last line |
| `:w` | Save the current buffer |
| `:q` | Quit the current window |
| `:wq` | Save and quit |

## Searching within a file

| Command | Description |
| --- | --- |
| `/pattern` | Search forwards for text |
| `?pattern` | Search backwards for text |
| `n` | Go to the next search match |
| `N` | Go to the previous search match |
| `*` | Search forwards for the word under the cursor |
| `#` | Search backwards for the word under the cursor |
| `:noh` | Clear search highlighting |

The configured `Space Space` shortcut also clears
search highlighting.

## Windows and splits

| Command | Description |
| --- | --- |
| `:split` | Split the current window horizontally |
| `:vsplit` | Split the current window vertically |
| `Ctrl+w v` | Create a vertical split |
| `Ctrl+w s` | Create a horizontal split |
| `Ctrl+w h` | Move to the left window |
| `Ctrl+w j` | Move to the window below |
| `Ctrl+w k` | Move to the window above |
| `Ctrl+w l` | Move to the right window |
| `Ctrl+w =` | Make split sizes equal |
| `Ctrl+w q` | Close the current window |

Custom `Ctrl+h/j/k/l` mappings provide shorter window
navigation within Neovim.

## Buffers

| Command | Description |
| --- | --- |
| `:buffers` | List open buffers |
| `:bnext` | Move to the next buffer |
| `:bprevious` | Move to the previous buffer |
| `:buffer 2` | Switch to buffer number 2 |
| `:bdelete` | Remove the current buffer from the buffer list |
| `:edit filename` | Open a file in the current window |

A buffer is an open file or text document. A window is
a view displaying a buffer. Multiple windows can display
the same buffer.

## Telescope — File and text search

The Linux plugin configuration includes Telescope.

| Command | Description |
| --- | --- |
| `:Telescope find_files` | Search for files |
| `:Telescope live_grep` | Search file contents using ripgrep |
| `:Telescope buffers` | Search open buffers |
| `:Telescope help_tags` | Search Neovim help topics |
| `:Telescope keymaps` | Search registered keybindings |

These commands require Telescope to be installed and loaded.

Project-specific Telescope shortcuts may also be defined
in `lua/config/lazy.lua`. Check them before assuming
a particular key combination.

## Oil — File management

The Linux plugin configuration includes Oil.nvim,
which provides a file explorer as a Neovim buffer.

| Command | Description |
| --- | --- |
| `:Oil` | Open the Oil file browser |
| `:help oil.nvim` | View Oil documentation, when installed |

File management actions inside Oil depend on its
configured mappings.

## LSP — Language Server Protocol

LSP functions require a language server to be attached
to the current buffer.

| Command | Description |
| --- | --- |
| `:LspInfo` | Inspect LSP configuration, if provided by the installed configuration |
| `:lua vim.lsp.buf.definition()` | Go to symbol definition |
| `:lua vim.lsp.buf.references()` | Find symbol references |
| `:lua vim.lsp.buf.rename()` | Rename a symbol across references |
| `:lua vim.lsp.buf.hover()` | Show symbol information |
| `:lua vim.lsp.buf.code_action()` | Request available code actions |
| `:lua vim.diagnostic.open_float()` | Inspect diagnostics near the cursor |

These are direct API calls, not claims about configured
keyboard shortcuts.

The available mappings depend on the active LSP setup.

## Git integration

The configuration includes Gitsigns.

Gitsigns can provide visual Git change indicators and
actions related to changed lines or hunks.

Check the active mappings rather than assuming the
plugin's example keybindings are configured.

## Troubleshooting and diagnostics

The configuration includes Trouble.nvim.

Trouble can present diagnostics and other developer
information in a dedicated interface.

Check its installed version and actual command mappings
before relying on a specific command.

Standard Neovim inspection commands:

| Command | Description |
| --- | --- |
| `:checkhealth` | Check Neovim and plugin health |
| `:messages` | Show recent editor messages |
| `:verbose nmap` | List Normal-mode mappings and their sources |
| `:verbose imap` | List Insert-mode mappings and their sources |
| `:map` | Inspect currently registered mappings |
| `:help keymap` | Read Neovim key mapping documentation |

## Neovim and tmux navigation

The configuration includes vim-tmux-navigator.

The Linux keymap file also defines Ctrl+h/j/k/l
for Neovim window navigation.

The effective behaviour across Neovim windows and tmux
panes depends on which mappings are active.

To inspect the left-navigation mapping:

~~vim
:verbose nmap <C-h>
~~

Repeat with `<C-j>`, `<C-k>` and `<C-l>` as needed.

## Practical workflow

Open a project from your shell:

~~bash
cd ~/projects/my-project
nvim .
~~

Inside Neovim, use Telescope to find files and text.
Open splits when comparing code, inspect LSP diagnostics,
and use Git indicators to review changes.

Before exiting, save with `Space w` and quit with
`Space q`.

## Verified plugin shortcuts

The following mappings were verified against the Linux
configuration in `nvim/lua/config/lazy.lua`.

Space is the leader key. All shortcuts below use Normal
mode unless another mode is specified.

### Telescope

| Shortcut | Description |
| --- | --- |
| `Space ff` | Find project files |
| `Space fg` | Search text with live grep |
| `Space fb` | Search open buffers |
| `Space fh` | Search Neovim help |

Inside Telescope's Insert-mode picker:

| Shortcut | Description |
| --- | --- |
| `Ctrl+j` | Select next result |
| `Ctrl+k` | Select previous result |

### Oil and commenting

| Shortcut | Description |
| --- | --- |
| `Space o` | Open Oil file explorer |
| `Space /` | Toggle current-line comment |
| `Space /` (Visual) | Toggle comment on selection |

### Gitsigns

| Shortcut | Description |
| --- | --- |
| `Space hs` | Stage current Git hunk |
| `Space hr` | Reset current Git hunk |
| `Space hu` | Undo Gitsigns hunk staging |
| `Space hp` | Preview current Git hunk |
| `Space hb` | Show Git blame for current line |

Gitsigns mappings are buffer-local and depend on the
plugin attaching successfully.

**Caution:** Staging and resetting hunks change Git state
or working files. Review the selected hunk first.

### Trouble and TODO comments

| Shortcut | Description |
| --- | --- |
| `Space xx` | Show current-buffer diagnostics |
| `Space xX` | Show workspace diagnostics |
| `Space xr` | Show LSP references |
| `Space xt` | Show TODO comments in Trouble |

### nvim-cmp completion

These mappings apply inside the completion interface
in Insert mode, not globally.

| Shortcut | Description |
| --- | --- |
| `Ctrl+y` | Trigger completion |
| `Ctrl+e` | Cancel completion |
| `Enter` | Confirm completion |
| `Ctrl+j` | Select next completion item |
| `Ctrl+k` | Select previous completion item |

### Context matters

`Ctrl+j` and `Ctrl+k` have different functions
depending on the active interface:

- Normal mode: navigate Neovim windows.
- Telescope Insert mode: navigate search results.
- nvim-cmp Insert mode: navigate completion candidates.

Plugin-specific mappings may override general mappings
within their respective interfaces.

## Configuration locations

The user-local Neovim configuration is located at:

~~text
~/.config/nvim
~~

On the configured Linux environment, this is linked
to the Neovim directory inside `~/dotfiles`.

Relevant files:

~~text
nvim/init.lua
nvim/lua/config/keymaps.lua
nvim/lua/config/lazy.lua
nvim/lazy-lock.json
~~

The Linux configuration may differ from macOS.
Do not overwrite either platform's working setup
without reviewing those differences.
