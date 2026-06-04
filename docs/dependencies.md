# Environment Dependencies

This document records external dependencies used by the development environment. These tools are not fully contained within the dotfiles repository and may need to be installed separately on a new machine.

## Core Terminal Environment

| Tool                    | Purpose               |
| ----------------------- | --------------------- |
| zsh                     | Primary shell         |
| oh-my-zsh               | Shell framework       |
| zsh-autosuggestions     | Command suggestions   |
| zsh-syntax-highlighting | Syntax highlighting   |
| starship                | Cross-platform prompt |
| tmux                    | Terminal multiplexer  |
| fzf                     | Fuzzy finder          |

## Editor Environment

| Tool       | Purpose           |
| ---------- | ----------------- |
| Neovim     | Primary editor    |
| lazy.nvim  | Plugin manager    |
| Treesitter | Syntax parsing    |
| Mason      | LSP installer     |
| nvim-dap   | Debugging support |

## Development Tools

| Tool           | Purpose                       |
| -------------- | ----------------------------- |
| Git            | Version control               |
| uv             | Python package manager        |
| Conda          | Python environment manager    |
| Docker         | Containers                    |
| Docker Compose | Multi-container orchestration |

## JavaScript Environment

| Tool    | Purpose                    |
| ------- | -------------------------- |
| nvm     | Node.js version management |
| Node.js | JavaScript runtime         |
| pnpm    | Package manager            |

## macOS Specific

| Tool     | Purpose           |
| -------- | ----------------- |
| Homebrew | Package manager   |
| iTerm2   | Terminal emulator |

## Linux Specific

| Tool                           | Purpose           |
| ------------------------------ | ----------------- |
| apt                            | Package manager   |
| GNOME Terminal / XFCE Terminal | Terminal emulator |

## Verification Commands

```bash
git --version
zsh --version
tmux -V
starship --version
uv --version
nvim --version

node --version
pnpm --version
nvm --version

docker --version
docker compose version
```

## Bootstrap Order

```bash
git clone <dotfiles>

cd dotfiles

./scripts/bootstrap-linux.sh

./scripts/install-linux.sh

exec zsh

./scripts/verify-linux.sh
```
