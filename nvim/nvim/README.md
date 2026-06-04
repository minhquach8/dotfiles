# ✅ **README.md – Complete Neovim Configuration (Modular, Lazy, LSP, DAP, tmux-ready)**

````md
# Neovim Configuration (Modular, Lazy, LSP, DAP, Tmux-ready)

This Neovim setup provides a clean, modern, fully-modular development environment
designed for Python, JavaScript/TypeScript, C/C++, Lua, Bash, TOML, YAML,
Markdown, and general-purpose editing.

It uses **lazy.nvim** for plugin management, integrates deeply with **tmux**, and
supports full **LSP**, **formatting**, **Git operations**, **debugging (DAP)**,
and **markdown preview**.

---

## ✨ Features

### Editor & UX

- Modern defaults (relative numbers, smart indent, no wrap, true colour).
- Smooth navigation between Neovim ↔ tmux splits.
- `which-key.nvim` for popup keybinding hints.
- Clean indent guides via `indent-blankline.nvim`.
- Fast file-switching, fuzzy search, and folder browsing.

---

## 🧠 LSP (Neovim 0.11 API)

- Native LSP with consistent on-attach keymaps.
- Mason installs and manages all language servers.
- Servers enabled:

| Language | LSP               |
| -------- | ----------------- |
| Python   | `pyright`, `ruff` |
| JS/TS    | `ts_ls`, `eslint` |
| Lua      | `lua_ls`          |
| Bash     | `bashls`          |
| TOML     | `taplo`           |

Keymaps:

- `gd` – Go to definition
- `K` – Hover documentation
- `<leader>rn` – Rename symbol
- `<leader>ca` – Code action
- `[d` / `]d` – Previous / next diagnostic
- `<leader>f` – Format file

---

## 🛠 Formatting (via `conform.nvim`)

Unified formatter mapping:

| Language        | Formatter               |
| --------------- | ----------------------- |
| Python          | `ruff_format`           |
| JS/TS           | `prettierd`, `eslint_d` |
| Lua             | `stylua`                |
| TOML            | `taplo`                 |
| Markdown / JSON | `prettierd`             |

Usage:

- Format current buffer → `<leader>f`

Optional:

- Auto-format on save (can be enabled in `format.lua`)

---

## 🌳 Git Support

Using `gitsigns.nvim`:

- `]c` / `[c` → Next / previous hunk
- `<leader>hs` → Stage hunk
- `<leader>hr` → Reset hunk
- `<leader>hp` → Preview hunk
- `<leader>hb` → Blame line

Tmux-safe auto-refresh ensures hunks update when Git actions occur in other panes.

---

## 🔍 Navigation & Search

### Telescope (with FZF-native)

- `<leader>ff` – Find files
- `<leader>fg` – Live grep
- `<leader>fb` – Buffer list
- `<leader>fh` – Help tags

### Oil.nvim file explorer

- `<leader>o` – Open Oil
- Works inside normal buffers, replaces netrw.

---

## 🧭 Diagnostics UI

Powered by `trouble.nvim`:

- `<leader>xx` – File diagnostics
- `<leader>xX` – Workspace diagnostics
- `<leader>xr` – LSP references

---

## 📄 Markdown Preview

Using **iamcco/markdown-preview.nvim**:

- Run: `:MarkdownPreview`
- Opens automatically in your system browser (Safari default on macOS).

---

# 🐞 Debugging (DAP) — Python, JS/TS, C/C++

This configuration includes a full debugging setup:

- **nvim-dap** → core debugging engine
- **dap-ui** → side panels (variables, stacks, breakpoints, REPL)
- **mason-nvim-dap** → installs adapters:
  - `debugpy` → Python
  - `node-debug2-adapter` → JavaScript / TypeScript (deprecated upstream but stable)
  - `cpptools` → C/C++ (vscode-cpptools debugger)
- **nvim-nio** → required runtime for dap-ui

### Debug Keymaps

| Action                         | Key                  |
| ------------------------------ | -------------------- |
| Start / Continue               | `F5`                 |
| Step Over                      | `F10`                |
| Step Into                      | `F11`                |
| Step Out                       | `F12`                |
| Toggle Breakpoint              | `F9` or `<leader>db` |
| Conditional Breakpoint         | `<leader>dB`         |
| Debug Hover (inspect variable) | `<leader>dh`         |
| Open REPL                      | `<leader>dr`         |
| Terminate Debug                | `<leader>dq`         |

### Python Debugging

- Uses **debugpy**
- Configuration runs the **current file**
- Works with any Python script
- Fast & reliable

### JavaScript / TypeScript Debugging

- Uses **node-debug2-adapter**
- Suitable for:
  - Node scripts
  - CLI tools
  - Simple backend debugging

> Note: This adapter is deprecated upstream.  
> It still works well, and remains supported by Mason.  
> You can upgrade later to `js-debug-adapter` if needed.

### C/C++ Debugging

- Uses **C/C++ Tools Debugger** (`cppdbg`)
- Prompts for path to executable
- Requires compiling with debug symbols:
  ```sh
  cc -g main.c -o main
  ```
````

---

# 📁 Folder Structure

```
~/.config/nvim/
│
├── init.lua
├── README.md
├── CheatSheet.md
│
└── lua/
    └── config/
        ├── options.lua       # core editor settings
        ├── keymaps.lua       # global keybindings
        ├── autocmds.lua      # autocommands (checktime, etc.)
        ├── lazy.lua          # plugin manager + all plugins
        ├── lsp.lua           # LSP setup + server configs
        ├── format.lua        # conform.nvim formatting rules
        └── dap.lua           # full debugging setup (dap + dap-ui)
```

Each module has exactly one responsibility → easy to maintain and extend.

---

# 🔧 Requirements

### Required CLI tools

```
rg        # ripgrep (Telescope)
fd        # file picker (Telescope)
stylua    # Lua formatting
taplo     # TOML formatting + LSP
ruff      # Python lint/format
prettierd # JS/TS/Markdown formatting
eslint_d  # JS/TS linting on save
```

Install via Homebrew:

```sh
brew install ripgrep fd stylua taplo ruff prettierd
npm install -g eslint_d
```

### DAP Adapters (auto-installed by Mason)

- `debugpy`
- `node-debug2-adapter`
- `cpptools`

---

# 🚀 Quick Reference (Cheatsheet)

### Buffers

```
:ls       list buffers
:bd       close buffer
:%bd      close all buffers
:%bd | e# close all except current
```

### Splits

```
:vs       vertical split
:sp       horizontal split
:only     keep current window only
```

### File operations

```
:e file
:w
:q / :q!
:wq
```

---

# ❤️ Philosophy

This configuration follows:

- **Modularity** → every feature lives in its own file
- **Performance** → lazy-loading, fzf-native, Lua loader
- **Stability** → minimal, safe plugin choices
- **Tmux-friendly ergonomics**
- **Long-term maintainability**
- **Language-agnostic workflow** suitable for:
  - AI/ML research (Python)
  - Backend (Node, C++)
  - Systems programming
  - Academic writing & note-taking

It is intended to be a **professional-grade daily driver** for development.

---
