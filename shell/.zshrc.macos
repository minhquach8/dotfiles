# -------------------------------------------------
# Homebrew
# -------------------------------------------------
eval "$(/opt/homebrew/bin/brew shellenv)"

# -------------------------------------------------
# Core PATH
# -------------------------------------------------
export PATH="/Library/PostgreSQL/18/bin:$PATH"

# -------------------------------------------------
# Oh My Zsh
# -------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  web-search
)

source "$ZSH/oh-my-zsh.sh"

# -------------------------------------------------
# Starship prompt
# -------------------------------------------------
eval "$(starship init zsh)"

# -------------------------------------------------
# Conda
# -------------------------------------------------
__conda_setup="$('/Users/minhquach/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
  eval "$__conda_setup"
else
  if [ -f "/Users/minhquach/miniconda3/etc/profile.d/conda.sh" ]; then
    . "/Users/minhquach/miniconda3/etc/profile.d/conda.sh"
  else
    export PATH="/Users/minhquach/miniconda3/bin:$PATH"
  fi
fi
unset __conda_setup

# -------------------------------------------------
# NVM
# -------------------------------------------------
export NVM_DIR="$HOME/.nvm"

if [ -s "$NVM_DIR/nvm.sh" ]; then
  . "$NVM_DIR/nvm.sh"
fi

if [ -s "$NVM_DIR/bash_completion" ]; then
  . "$NVM_DIR/bash_completion"
fi

# -------------------------------------------------
# pnpm
# -------------------------------------------------
export PNPM_HOME="$HOME/Library/pnpm"

case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# -------------------------------------------------
# fzf
# -------------------------------------------------
if [ -f "$HOME/.fzf.zsh" ]; then
  source "$HOME/.fzf.zsh"
fi

ff() {
  find . -type f | fzf
}

# -------------------------------------------------
# macOS app launcher
# -------------------------------------------------
app() {
  local chosen
  chosen=$(ls /Applications | grep '\.app$' | sed 's/\.app$//' | fzf)
  [ -n "$chosen" ] && open -a "$chosen"
}
