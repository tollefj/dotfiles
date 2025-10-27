export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PATH=$HOME/bin:/usr/local/bin:$PATH
# export PATH="/opt/homebrew/opt/python@3.11/libexec/bin:$PATH"
# export PATH="/Users/tollef/.modular/pkg/packages.modular.com_mojo/bin:$PATH"
export PATH="$PATH:/usr/local/texlive/2022/bin/universal-darwin"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
# export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
export PATH=`gem environment gemdir`/bin:$PATH
export PATH="$PATH:/Users/tollef/.local/bin"
#%%%%%%%%%% SIKT %%%%%%%%%%
export VAULT_ADDR=https://vault.sikt.no:8200
#%%%%%%%%%% ZSH %%%%%%%%%%%
export ZSH="/Users/tollef/.oh-my-zsh"

# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="tollef"
# ZSH_THEME="agnoster"
ZSH_THEME="aussiegeek"
# ZSH_THEME="bira"
plugins=(
  git
  colorize
  macos

)

source $ZSH/oh-my-zsh.sh

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

#%%%%%%%%%% ZSH %%%%%%%%%%%
#
# %% brew stuff %%
# brew install fd fzf bat tree
# brew install stylua black go
# npm install -g prettier

# ---- START FZF AND FD SEARCH -----
# export FZF_DEFAULT_COMMAND="fd --type f --strip-cwd-prefix --hidden --exclude node_modules --exclude __pycache__ --exclude .git --exclude .venv --exclude .mypy_cache --exclude .pytest_cache --exclude dist --exclude build --exclude env --exclude venv --exclude '*.egg-info' ."
export FZF_DEFAULT_COMMAND="fd --type f --strip-cwd-prefix --exclude node_modules --exclude __pycache__ --exclude .git --exclude .venv --exclude .mypy_cache --exclude .pytest_cache --exclude dist --exclude build --exclude env --exclude venv --exclude '*.egg-info' ."


export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# ---- END FZF AND FD SEARCH -----

# alias glg='fzf_git_log' # Example alias


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

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
#
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
alias spaceDock="defaults write -array com.apple.dock persistent-apps-add '{tile-data = {}; tile-type = "spacer-tile";}'"
alias la='ls -a'
alias lc='ls -col'
alias lr='ls -ltr'
alias lines='ls -1 | wc -l'

alias pyvirtual='virtualenv .venv --distribute; source venv/bin/activate'
alias activate='source .venv/bin/activate'
alias python='python3'
alias pip='pip3'
alias py='python'
alias py3='python3'
alias py3virtual='python3 -m venv .venv; source .venv/bin/activate'

alias bashprof='nvim ~/.bash_profile'
alias z='nvim ~/.zshrc'
alias vimrc='nvim ~/.vimrc'
alias vim="nvim"
alias nv="vim ~/.config/nvim"
alias alac="vim ~/.config/alacritty/alacritty.toml"
alias phd="vim ~/git/thesis/tex"

alias home='cd ~'
alias dl='cd ~/Downloads'
alias docs='cd ~/sikt'

alias st='git status'
alias logp='git log --pretty=oneline --abbrev-commit'

alias reload='source ~/.zshrc'

alias ddc='ddcctl'
alias ignore='echo "$1" >> .gitignore'

alias lower='pbpaste | tr "[:upper:]" "[:lower:]" | pbcopy'

alias x='tmux new-session -d \; split-window -h \; split-window -v \; select-pane -t 0 \; split-window -v \; attach'
alias ip="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"

# %%%%% helpers for github %%%%%
alias addignore='wget -O .gitignore https://gist.githubusercontent.com/tollefj/0c435215496b9c7e5af64e34bac0b0cb/raw'


# https://github.com/agnoster/agnoster-zsh-theme/issues/39
prompt_context() {
  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment black default "%(!.%{%F{yellow}%}.)$USER"
  fi
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

set -o vi
bindkey '^R' history-incremental-search-backward

# activate .venv environment if it exists upon opening
if [ -d "./.venv" ] && [ -f "./.venv/bin/activate" ]; then
    source ./.venv/bin/activate
fi

# TMUX
mux() {
    local session_name="${1:-default}"

    if tmux has-session -t "$session_name" 2>/dev/null; then
        tmux attach-session -t "$session_name"
    else
        tmux new-session -s "$session_name" \; split-window -h \; select-pane -t 0
    fi
}

gls() {
    local limit="${1:-}"
    local output

    output=$((git ls-files; git ls-files --others --exclude-standard) | while read file; do
        if [ -f "$file" ]; then
            timestamp=$(git log -1 --format=%ai -- "$file" 2>/dev/null || stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$file")
            echo "$timestamp $file"
        fi
    done | sort -r)

    if [ -n "$limit" ]; then
        echo "$output" | head -n "$limit"
    else
        echo "$output"
    fi
}
