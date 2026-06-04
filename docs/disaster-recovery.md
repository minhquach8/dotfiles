# Disaster Recovery

This document describes how to rebuild a workstation from scratch.

## Scenario

Examples:

- New MacBook purchased
- Linux workstation replaced
- SSD failure
- OS reinstallation

## Recovery Procedure

### 1. Install Git

Verify:

```bash
git --version
```

### 2. Clone Dotfiles

```bash
git clone <repository>

cd dotfiles
```

### 3. Install Dependencies

Linux:

```bash
./scripts/bootstrap-linux.sh
```

macOS:

Install required packages manually or through Homebrew.

### 4. Install Configuration

Linux:

```bash
./scripts/install-linux.sh
```

macOS:

```bash
./scripts/install-macos.sh
```

### 5. Restart Shell

```bash
exec zsh
```

### 6. Verify Environment

Linux:

```bash
./scripts/verify-linux.sh
```

## Success Criteria

The following tools should be available:

- git
- zsh
- tmux
- starship
- uv
- Neovim

The following configurations should be active:

- tmux
- Neovim
- Starship
- Git aliases
- Zsh configuration

```

```
