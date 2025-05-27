# Locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Default applications
export EDITOR="vim"
export BROWSER="/mnt/c/Program Files/BraveSoftware/Brave-Browser/Application/brave.exe"

# Base PATH
export PATH="$HOME/bin:/usr/local/bin:$PATH"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# OS-specific logic
OS="$(uname -s)"

if [[ "$OS" == "Linux" ]]; then
    export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

    FNM_PATH="$HOME/.local/share/fnm"
    if [ -d "$FNM_PATH" ]; then
        export PATH="$FNM_PATH:$PATH"
        eval "$(fnm env)"
    fi

    # Deno
    [ -f "$HOME/.deno/env" ] && . "$HOME/.deno/env"

elif [[ "$OS" == "Darwin" ]]; then
    export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
    export PATH="/opt/homebrew/bin:$PATH"
    export PATH="/opt/homebrew/sbin:$PATH"
    export PATH="/opt/homebrew/opt/python@3.11/libexec/bin:$PATH"
    export PATH="/opt/homebrew/opt/python@3.12/libexec/bin:$PATH"
    export PATH="/opt/homebrew/opt/python@3.13/libexec/bin:$PATH"
    export PATH="$HOME/.local/bin:$PATH"
    export ZSH="$HOME/.oh-my-zsh"
fi

# TeX Live (universal-darwin assumed on macOS; safe to include elsewhere)
export PATH="$PATH:/usr/local/texlive/2022/bin/universal-darwin"

