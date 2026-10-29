#!/usr/bin/env bash
# Ubuntu dotfiles bootstrap: zsh + oh-my-zsh + starship, managed with stow.
# Usage: bash new-user.sh [target dir, default ~/dotfiles]
# Safe to rerun, and on a new machine after cloning your dotfiles repo:
# existing files in the repo are never overwritten.
set -euo pipefail

DOTFILES="${1:-$HOME/dotfiles}"

write() {
  local path="$DOTFILES/$1"
  [ -e "$path" ] && return
  mkdir -p "$(dirname "$path")"
  cat >"$path"
  echo "created $1"
}

install_packages() {
  sudo apt update
  sudo apt install -y \
    git stow make curl unzip fontconfig \
    zsh fzf ripgrep command-not-found \
    btop jq tree gh direnv

  mkdir -p "$HOME/.local/bin"
  command -v starship >/dev/null || curl -sS https://starship.rs/install.sh | sh -s -- -y -b "$HOME/.local/bin"
  command -v uv >/dev/null || curl -LsSf https://astral.sh/uv/install.sh | sh
  command -v mise >/dev/null || curl -fsSL https://mise.run | sh

  if ! command -v code >/dev/null && command -v codium >/dev/null; then
    ln -s "$(command -v codium)" "$HOME/.local/bin/code"
  fi
}

install_oh_my_zsh() {
  [ -d "$HOME/.oh-my-zsh" ] ||
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  local custom="$HOME/.oh-my-zsh/custom/plugins"
  for plugin in zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search; do
    [ -d "$custom/$plugin" ] || git clone --depth 1 "https://github.com/zsh-users/$plugin" "$custom/$plugin"
  done
}

install_font() {
  local dir="$HOME/.local/share/fonts/JetBrainsMonoNerd"
  [ -d "$dir" ] && return
  mkdir -p "$dir"
  curl -fsSL -o /tmp/JetBrainsMono.zip \
    https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
  unzip -q /tmp/JetBrainsMono.zip -d "$dir"
  rm /tmp/JetBrainsMono.zip
  fc-cache -f
}

scaffold() {
  mkdir -p "$DOTFILES"
  [ "$(realpath "$0")" = "$DOTFILES/setup.sh" ] || cp "$0" "$DOTFILES/setup.sh"

  local name email
  name="$(git config --global user.name 2>/dev/null || true)"
  email="$(git config --global user.email 2>/dev/null || true)"
  if [ ! -e "$DOTFILES/git/.gitconfig" ]; then
    [ -n "$name" ] || read -rp "Git name: " name
    [ -n "$email" ] || read -rp "Git email: " email
  fi

  write Makefile <<'EOF'
DOTFILES := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
STOW     := stow --dir="$(DOTFILES)" --target="$(HOME)"
PACKAGES := $(patsubst %/,%,$(wildcard */))

.PHONY: link adopt unlink

link:
	@$(STOW) --restow $(PACKAGES)
	@echo "Linked: $(PACKAGES)"

adopt:
	@$(STOW) --adopt --restow $(PACKAGES)
	@echo "Adopted into repo. Review with 'git diff'."

unlink:
	@$(STOW) --delete $(PACKAGES)
EOF

  write zsh/.zshrc <<'EOF'
export PATH="$HOME/.local/bin:$PATH"
export EDITOR="code --wait"

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(
  git
  sudo
  history
  colored-man-pages
  command-not-found
  fzf
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-history-substring-search
)
source "$ZSH/oh-my-zsh.sh"

HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS SHARE_HISTORY

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

alias reload="source ~/.zshrc"

command -v starship >/dev/null && eval "$(starship init zsh)"
command -v direnv   >/dev/null && eval "$(direnv hook zsh)"
command -v mise     >/dev/null && eval "$(mise activate zsh)"

[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
EOF

  write starship/.config/starship.toml <<'EOF'
format = "$directory$git_branch$git_status$python$nodejs$cmd_duration$line_break$character"

[directory]
truncation_length = 3
style = "bold cyan"

[git_branch]
format = "[$symbol$branch]($style) "
style = "bold purple"

[git_status]
style = "yellow"

[python]
format = "[$symbol$version( \\($virtualenv\\))]($style) "

[nodejs]
format = "[$symbol$version]($style) "

[cmd_duration]
min_time = 2000
format = "[took $duration]($style) "

[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"
EOF

  write git/.gitconfig <<EOF
[user]
	name = $name
	email = $email
[core]
	editor = code --wait
	excludesfile = ~/.config/git/ignore
[init]
	defaultBranch = main
[pull]
	rebase = true
[push]
	autoSetupRemote = true
[fetch]
	prune = true
[alias]
	st = status -sb
	co = checkout
	sw = switch
	br = branch
	df = diff
	dc = diff --cached
	lg = log --graph --pretty=format:'%C(red)%h%C(reset) %s %C(yellow)%d%C(reset) %C(green)(%cr)%C(reset) [%an]' --abbrev-commit
	undo = reset --soft HEAD~1
EOF

  write git/.config/git/ignore <<'EOF'
.env
.env.local
.venv/
__pycache__/
node_modules/
.idea/
*.swp
EOF

  [ -d "$DOTFILES/.git" ] || git -C "$DOTFILES" init -q
}

link() {
  for file in .zshrc .gitconfig .config/starship.toml .config/git/ignore; do
    if [ -e "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
      mv "$HOME/$file" "$HOME/$file.bak"
      echo "backed up ~/$file to ~/$file.bak"
    fi
  done
  make -C "$DOTFILES" link
}

install_packages
scaffold
link
install_oh_my_zsh
install_font
[ "$SHELL" = "$(command -v zsh)" ] || chsh -s "$(command -v zsh)"

cat <<EOF

Done. Next:
  1. Log out and back in.
  2. Set your terminal font to "JetBrainsMono Nerd Font".
  3. cd $DOTFILES && git add -A && git commit -m "Initial dotfiles", then push to your own GitHub.

Edit ~/.zshrc etc directly, they are symlinks into $DOTFILES.
New app config: put it in $DOTFILES/<app>/<path under ~> and run 'make'.
Another machine: clone your repo and run 'bash setup.sh'.
EOF
