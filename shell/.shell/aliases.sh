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

# temporary nvim stuff
# alias peeknvim="cd ~/.local/share/nvim/lazy/peek.nvim"
