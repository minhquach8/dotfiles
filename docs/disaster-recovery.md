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

#### Linux

```bash
./scripts/bootstrap-linux.sh
```

#### macOS

```bash
./scripts/bootstrap-macos.sh
```

### 4. Install Configuration

#### Linux

```bash
./scripts/install-linux.sh
```

#### macOS

```bash
./scripts/install-macos.sh
```

### 5. Restart Shell

```bash
exec zsh
```

### 6. Verify Environment

#### Linux

```bash
./scripts/verify-linux.sh
```

#### macOS

```bash
./scripts/verify-macos.sh
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

## Expected Recovery Flow

### Linux

```bash
git clone <repository>

cd dotfiles

./scripts/bootstrap-linux.sh

./scripts/install-linux.sh

exec zsh

./scripts/verify-linux.sh
```

### macOS

```bash
git clone <repository>

cd dotfiles

./scripts/bootstrap-macos.sh

./scripts/install-macos.sh

exec zsh

./scripts/verify-macos.sh
```

## Recovery Goal

A new machine should be able to recover:

- Shell configuration
- Git configuration
- tmux configuration
- Neovim configuration
- Starship prompt
- Development workflow

without requiring manual recollection of previous setup steps.
