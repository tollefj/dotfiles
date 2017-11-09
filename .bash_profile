export PATH="/usr/local/bin:$PATH"
export PS1="\[\e[31;1m\]\W \\[\e[32;1m\]"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session as a function
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
alias la='ls -a'
alias lc='ls -col'

alias pyvirtual='virtualenv venv --distribute; source venv/bin/activate'
alias activate='source venv/bin/activate'
alias py='python'
alias py3='python3'
alias py3virtual='virtualenv -p python3 venv; source venv/bin/activate'

alias bashprof='vim ~/.bash_profile'
alias vimrc='vim ~/.vimrc'

alias ipconfig='ifconfig | grep inet'
alias updatedots='py3 ~/Documents/Git/dotfiles/updatefiles.py'
alias docs='cd ~/Documents/Git'

alias st='git status'
alias logp='git log --pretty=oneline --abbrev-commit'

alias lint='./node_modules/.bin/eslint'

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

export NVM_DIR="$HOME/.nvm"
  . "/usr/local/opt/nvm/nvm.sh"
export ANDROID_HOME=/usr/local/Caskroom/android-sdk
source ~/.profile
