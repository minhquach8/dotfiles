# Neovim + tmux + iTerm Cheatsheet

A concise but complete reference for your current setup:

- iTerm2
- tmux (prefix `Ctrl + a`)
- Neovim core keymaps
- All configured plugins (Telescope, Oil, LSP, Conform, Gitsigns, Trouble, DAP, Markdown preview, etc.)
- Useful ex commands and tips

---

## 🍎 iTerm2

| Action                 | Shortcut              |
| ---------------------- | --------------------- |
| New tab                | ⌘ + T                 |
| Close tab              | ⌘ + W                 |
| New split (vertical)   | ⌘ + D                 |
| New split (horizontal) | ⇧⌘ + D                |
| Next / previous tab    | ⌘ + ⇧ + ] / ⌘ + ⇧ + [ |
| Find in terminal       | ⌘ + F                 |
| Clear scrollback       | ⌘ + K                 |
| Copy / Paste           | ⌘ + C / ⌘ + V         |
| Fullscreen             | ⌘ + Enter             |

> Tip: Set terminal type to `xterm-256color` and sync colours with Catppuccin for a consistent look.

---

## 🔳 tmux (prefix = `Ctrl + a`)

Your tmux prefix has been remapped:

> **Prefix = `Ctrl + a`**

### Sessions & Windows

| Action                 | Keys                            |
| ---------------------- | ------------------------------- |
| New session            | `tmux new -s name`              |
| List sessions          | `tmux ls`                       |
| Attach session         | `tmux attach -t name`           |
| Detach                 | `Prefix` + `d`                  |
| New window             | `Prefix` + `c`                  |
| Next / previous window | `Prefix` + `n` / `Prefix` + `p` |
| Rename window          | `Prefix` + `,`                  |

### Panes

| Action                         | Keys                                        |
| ------------------------------ | ------------------------------------------- |
| Vertical split                 | `Prefix` + `\|`                             |
| Horizontal split               | `Prefix` + `-`                              |
| Move between panes (built-in)  | `Prefix` + Arrow keys                       |
| Resize pane down/up/right/left | `Prefix` + `j` / `k` / `l` / `h` (×5 cells) |
| Toggle zoom (maximise pane)    | `Prefix` + `m`                              |
| Toggle synchronise panes       | `Prefix` + `s`                              |

### Copy mode (vi-style)

- Enter copy mode: `Prefix` + `[`
- Movement: `h/j/k/l`, `0`, `$`, `w`, `b`, etc.
- Start selection: `v`
- Copy selection: `y`

Mouse is enabled:

- Scroll to enter copy mode.
- Drag to select; selection does **not** leave copy-mode automatically (you unbound `MouseDragEnd1Pane`).

### TPM + Resurrect + Continuum

- Install/update tmux plugins: `Prefix` + `I` (TPM default)
- `tmux-resurrect` and `tmux-continuum` manage saving/restoring sessions automatically (no extra keybind configured by you; they follow their defaults).

> Tip: `set-option -g focus-events on` is already set → helps Neovim detect file changes correctly when switching panes.

---

## 🟩 Neovim – Core Keymaps

### General

| Action                    | Key                      |
| ------------------------- | ------------------------ |
| Save buffer               | `<leader>w`              |
| Quit window               | `<leader>q`              |
| Clear search highlight    | `<leader><space>`        |
| Leave insert mode quickly | In insert mode type `kj` |

> `<leader>` is the **spacebar**.

### Window navigation (inside Neovim)

| Action               | Key     |
| -------------------- | ------- |
| Move to left window  | `<C-h>` |
| Move to lower window | `<C-j>` |
| Move to upper window | `<C-k>` |
| Move to right window | `<C-l>` |

With `vim-tmux-navigator`, the same `<C-h/j/k/l>` keys move between Neovim splits **and** tmux panes.

---

## 🔍 Telescope

| Action       | Key          |
| ------------ | ------------ |
| Find files   | `<leader>ff` |
| Live grep    | `<leader>fg` |
| List buffers | `<leader>fb` |
| Help tags    | `<leader>fh` |

Inside Telescope:

- Move selection down → `<C-j>`
- Move selection up → `<C-k>`

---

## 📁 File Explorer – Oil.nvim

| Action                 | Key         |
| ---------------------- | ----------- |
| Open Oil file explorer | `<leader>o` |

Inside Oil:

- Enter directory / open file → `<CR>`
- Go up one directory → `-`

---

## 🧠 LSP (from `lsp.lua`)

These are buffer-local keymaps applied when an LSP server attaches.

| Action                 | Key          |
| ---------------------- | ------------ |
| Go to definition       | `gd`         |
| Go to declaration      | `gD`         |
| Go to implementation   | `gi`         |
| List references        | `gr`         |
| Hover information      | `K`          |
| Rename symbol          | `<leader>rn` |
| Code action            | `<leader>ca` |
| Line diagnostics popup | `<leader>e`  |
| Previous diagnostic    | `[d`         |
| Next diagnostic        | `]d`         |

### ESLint-specific

| Action                 | Key          |
| ---------------------- | ------------ |
| ESLint fix all (JS/TS) | `<leader>ef` |

Additionally, on write for `*.js`, `*.jsx`, `*.ts`, `*.tsx` you automatically run:

- ESLint `"source.fixAll.eslint"` via an autocommand in `lsp.lua`.

---

## 🧼 Formatting – Conform.nvim

| Action                | Key         |
| --------------------- | ----------- |
| Format current buffer | `<leader>f` |

Backed by `config/format.lua`, which maps:

- Python → `ruff_format`
- JS/TS/Markdown/JSON → `prettierd` (+ `eslint_d` where relevant)
- Lua → `stylua`
- TOML → `taplo`

---

## 🐙 Git – Gitsigns

| Action          | Key          |
| --------------- | ------------ |
| Next hunk       | `]c`         |
| Previous hunk   | `[c`         |
| Stage hunk      | `<leader>hs` |
| Reset hunk      | `<leader>hr` |
| Undo stage hunk | `<leader>hu` |
| Preview hunk    | `<leader>hp` |
| Blame line      | `<leader>hb` |

---

## 🚨 Diagnostics / References – Trouble.nvim

| Action                | Key          |
| --------------------- | ------------ |
| Document diagnostics  | `<leader>xx` |
| Workspace diagnostics | `<leader>xX` |
| LSP references        | `<leader>xr` |

Commands:

- `:TroubleToggle document_diagnostics`
- `:TroubleToggle workspace_diagnostics`
- `:TroubleToggle lsp_references`

---

## 💬 Comments – Comment.nvim

| Action                         | Key                       |
| ------------------------------ | ------------------------- |
| Toggle comment on current line | `<leader>/` (normal mode) |
| Toggle comment on selection    | `<leader>/` (visual mode) |

Behaviour:

- In normal mode it toggles either the current line or a count of lines.
- In visual mode it toggles the selected block.

---

## 🧱 Indent Guides – indent-blankline (ibl)

- No explicit keybindings.
- Shows vertical indent guides automatically with character `│`.

---

## 🔍 Treesitter

Languages installed:

- `lua`, `python`, `bash`, `vim`, `markdown`, `json`, `yaml`,
  `dockerfile`, `sql`.

Useful commands:

- `:TSUpdate` – update all parsers
- `:TSInstallInfo` – see status

---

## 🧾 Markdown Preview – iamcco/markdown-preview.nvim

| Action         | Command                  |
| -------------- | ------------------------ |
| Start preview  | `:MarkdownPreview`       |
| Stop preview   | `:MarkdownPreviewStop`   |
| Toggle preview | `:MarkdownPreviewToggle` |

Behaviour:

- Opens preview in default browser (Safari on macOS).
- `g:mkdp_echo_preview_url = 1` → prints preview URL in Neovim command-line.

---

## 🐞 Debugging (DAP + DAP-UI)

Adapters via `mason-nvim-dap`:

- Python → `debugpy`
- JavaScript / TypeScript → `node-debug2-adapter`
- C / C++ → `cppdbg` (cpptools)

Keymaps from `config/dap.lua` (global):

| Action                              | Key                    |
| ----------------------------------- | ---------------------- |
| Start / Continue                    | `<F5>`                 |
| Step over                           | `<F10>`                |
| Step into                           | `<F11>`                |
| Step out                            | `<F12>`                |
| Toggle breakpoint                   | `<F9>` or `<leader>db` |
| Conditional breakpoint              | `<leader>dB`           |
| Open REPL                           | `<leader>dr`           |
| Hover variable / value under cursor | `<leader>dh`           |
| Terminate debug + close UI          | `<leader>dq`           |

Notes:

- `dap-ui` auto-opens when a session starts and auto-closes when it ends.
- C/C++ config prompts for the executable path (`./a.out`, `./main`, etc.).
- For C/C++ remember to compile with debug symbols (`-g`).

---

## 📚 Useful Ex Commands (Core Neovim)

### Files & buffers

```vim
:e file          " edit file
:w               " write file
:q               " quit window
:q!              " quit without saving
:wq              " write and quit
:wa              " write all
:ls              " list buffers
:bd              " delete buffer
:%bd             " delete all buffers
:%bd | e#        " delete all except current
```

### Windows & layout

```vim
:vs              " vertical split
:sp              " horizontal split
:only            " close all other windows
:terminal        " open terminal in a split
```

### Search / replace

```vim
/text            " search forward
n / N            " next / previous match
:%s/old/new/g    " global replace
:%s/old/new/gc   " global replace with confirm
```

### LSP / Plugins

```vim
:Mason           " open Mason UI (LSP / DAP / tools)
:Lazy            " open lazy.nvim UI
:LspInfo         " show active LSP servers
:LspRestart      " restart all LSP servers
:TSUpdate        " update Treesitter parsers
:Trouble         " open Trouble (with current mode)
:checkhealth     " run Neovim health checks
```

---

## 💡 Tips & Workflow Notes

- **Autoread in tmux**:
  `focus-events on` in tmux + `checktime` autocmds in Neovim mean files are auto-reloaded when changed in other panes.

- **Clipboard (macOS)**:
  Use system clipboard register:

  ```vim
  "+y    " yank to system clipboard
  "+p    " paste from system clipboard
  ```

- **Jump list**:

  ```vim
  <C-o>  " jump back
  <C-i>  " jump forward
  ```

- **Debugging**:
  - Python: open script, set breakpoint (`<F9>`), run (`<F5>`).
  - JS/TS: same, using Node.
  - C/C++: compile with `-g`, then `<F5>` and point to the executable.

- **Which-key**:
  Press `<leader>` and pause → which-key pops up with available mappings.

---
