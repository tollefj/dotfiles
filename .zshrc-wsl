export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=`gem environment gemdir`/bin:$PATH
# linux nvim
# verify OS first:
OS=$(uname -s)
if [[ "$OS" == "Linux" ]]; then
    export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
fi

export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:/usr/local/texlive/2022/bin/universal-darwin"

if [[ "$OS" == "Darwin" ]]; then
    export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
    export PATH="/opt/homebrew/bin:$PATH"

    export PATH="$PATH:/opt/homebrew/bin"
    export PATH="$PATH:/opt/homebrew/sbin"
    export PATH="$PATH:/opt/homebrew/opt/ruby/bin"
    export PATH="$PATH:/opt/homebrew/opt/python@3.11/libexec/bin"
    export PATH="$PATH:/opt/homebrew/opt/python@3.12/libexec/bin"
    export PATH="$PATH:/opt/homebrew/opt/python@3.13/libexec/bin"
    export PATH="$PATH:/opt/homebrew/opt/ruby/bin"
    export PATH="$PATH:/Users/tollef/.local/bin"
    export ZSH="/Users/tollef/.oh-my-zsh"
fi
# if WSL:
if [[ "$OS" == "Linux" && $(uname -r) == *microsoft* ]]; then
    echo "Running on WSL"
fi
#
#%%%%%%%%%% ZSH %%%%%%%%%%%
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="tollef"
# ZSH_THEME="agnoster"
# ZSH_THEME="aussiegeek"
# # ZSH_THEME="bira"
# plugins=(
#   git
#   colorize
#   macos
# )
# source $ZSH/oh-my-zsh.sh
# source /Users/tollef/.oh-my-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# macos commands
# | `tab`         | Open the current directory in a new tab                  |
# | `split_tab`   | Split the current terminal tab horizontally              |
# | `vsplit_tab`  | Split the current terminal tab vertically                |
# | `ofd`         | Open passed directories (or $PWD by default) in Finder   |
# | `pfd`         | Return the path of the frontmost Finder window           |
# | `pfs`         | Return the current Finder selection                      |
# | `cdf`         | `cd` to the current Finder directory                     |
# | `pushdf`      | `pushd` to the current Finder directory                  |
# | `pxd`         | Return the current Xcode project directory               |
# | `cdx`         | `cd` to the current Xcode project directory              |
# | `quick-look`  | Quick-Look a specified file                              |
# | `man-preview` | Open man pages in Preview app                            |
# | `showfiles`   | Show hidden files in Finder                              |
# | `hidefiles`   | Hide the hidden files in Finder                          |
# | `itunes`      | _DEPRECATED_. Use `music` from macOS Catalina on         |
# | `music`       | Control Apple Music. Use `music -h` for usage details    |
# | `spotify`     | Control Spotify and search by artist, album, track…      |
# | `rmdsstore`   | Remove .DS_Store files recursively in a directory        |
# | `btrestart`   | Restart the Bluetooth daemon                             |
# | `freespace`   | Erases purgeable disk space with 0s on the selected disk |
#

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
alias spaceDock="defaults write -array com.apple.dock persistent-apps-add '{tile-data = {}; tile-type = "spacer-tile";}'"
alias la='ls -a'
alias lc='ls -col'
alias lr='ls -ltr'

alias pyvirtual='virtualenv venv --distribute; source venv/bin/activate'
alias activate='source venv/bin/activate'
alias python='python3'
alias py='python'
alias py3='python3'
alias py3virtual='virtualenv -p python3 venv; source venv/bin/activate'

alias bashprof='nvim ~/.bash_profile'
alias z='nvim ~/.zshrc'
alias vimrc='nvim ~/.vimrc'
alias vim="nvim"
alias nv="vim ~/.config/nvim"
alias alac="vim ~/.config/alacritty/alacritty.toml"
alias phd="vim ~/git/thesis/tex"

alias home='cd ~'
alias dl='cd ~/Downloads'
alias docs='cd ~/git'

alias st='git status'
alias logp='git log --pretty=oneline --abbrev-commit'

alias reload='source ~/.zshrc'

alias ddc='ddcctl'
alias ignore='echo "$1" >> .gitignore'

alias lower='pbpaste | tr "[:upper:]" "[:lower:]" | pbcopy'

alias x='tmux new-session -d \; split-window -h \; split-window -v \; select-pane -t 0 \; split-window -v \; attach'


# %%%%%%%%%%%%%%%%% START FNs %%%%%%%%%%%%%%%%%
latex-build() {
  local tex_files=(*.tex)

  if [ ${#tex_files[@]} -eq 0 ]; then
    echo "❌ No .tex files found in the current directory."
    return 1
  fi

  echo "📄 Select a .tex file to build:"
  select choice in "${tex_files[@]}"; do
    if [[ -n "$choice" ]]; then
      name="${choice%.tex}"
      break
    else
      echo "❌ Invalid selection. Please choose a number."
    fi
  done

  echo -n "📦 Do you want to create a zip of the entire folder after build? (y/n): "
  read zip_choice

  echo "🔧 Building $name.tex..."
  if ! pdflatex "$name.tex"; then echo "❌ pdflatex failed"; return 1; fi
  if ! bibtex "$name"; then echo "❌ bibtex failed"; return 1; fi
  if ! pdflatex "$name.tex"; then echo "❌ pdflatex 2nd pass failed"; return 1; fi
  if ! pdflatex "$name.tex"; then echo "❌ pdflatex 3rd pass failed"; return 1; fi

  echo "✅ Build complete: $name.pdf"

  if [[ "$zip_choice" =~ ^[Yy]$ ]]; then
    local current_dir
    current_dir=$(basename "$PWD")
    local parent_dir
    parent_dir=$(dirname "$PWD")
    local timestamp
    timestamp=$(date +"%Y%m%d_%H%M%S")
    local zip_name="${current_dir}_build_${timestamp}.zip"

    echo "📦 Zipping entire folder to: $parent_dir/$zip_name"
    (cd .. && zip -r "$zip_name" "$current_dir" > /dev/null)

    if [ -f "$parent_dir/$zip_name" ]; then
      echo "✅ Archive created: $zip_name"
    else
      echo "⚠️  ZIP creation failed."
    fi
  fi
}
# %%%%%%%%%%%%%%%%% END FNs   %%%%%%%%%%%%%%%%%



# https://github.com/agnoster/agnoster-zsh-theme/issues/39
prompt_context() {
  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment black default "%(!.%{%F{yellow}%}.)$USER"
  fi
}

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
#
if [[ "$OS" == "Darwin" ]]; then
    CONDA_INSTALL_PATH="/opt/miniconda3"
elif [[ "$OS" == "Linux" && $(uname -r) == *microsoft* ]]; then
    CONDA_INSTALL_PATH="/home/$(whoami)/miniconda3"
else
  CONDA_INSTALL_PATH="/opt/miniconda3"
fi

if [[ -n "$CONDA_INSTALL_PATH" && -d "$CONDA_INSTALL_PATH" ]]; then
  if [[ -f "${CONDA_INSTALL_PATH}/bin/conda" ]]; then
    __conda_setup="$("${CONDA_INSTALL_PATH}/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
      eval "$__conda_setup"
    else
      if [ -f "${CONDA_INSTALL_PATH}/etc/profile.d/conda.sh" ]; then
        . "${CONDA_INSTALL_PATH}/etc/profile.d/conda.sh"
      else
        export PATH="${CONDA_INSTALL_PATH}/bin:$PATH"
      fi
    fi
    unset __conda_setup
  elif [[ -f "${CONDA_INSTALL_PATH}/etc/profile.d/conda.sh" ]]; then
    . "${CONDA_INSTALL_PATH}/etc/profile.d/conda.sh"
  else
    export PATH="${CONDA_INSTALL_PATH}/bin:$PATH"
  fi
fi
# __conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
#         . "/opt/miniconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="/opt/miniconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup

# <<< conda initialize <<<

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# fnm
FNM_PATH="/home/tollef/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/tollef/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi
