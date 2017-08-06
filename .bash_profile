export PATH="/usr/local/bin:$PATH"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session as a function
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
alias pyvirtual='virtualenv venv --distribute; source venv/bin/activate'
alias activate='source venv/bin/activate'
alias py='python'
alias py3='python3'
alias py3virtual='virtualenv -p python3 venv; source venv/bin/activate'

alias bashprof='vim ~/.bash_profile'
alias vimrc='vim ~/.vimrc'

alias ipconfig='ifconfig | grep inet'
alias updatedots='py3 ~/Documents/Git/dotfiles/updatefiles.py'

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

source ~/.profile
