# Dotfiles on Linux

Assumes Ubuntu/Debian.

## 1. Install

```bash
sudo apt update
sudo apt install git stow make zsh tmux neovim fzf ripgrep fd-find tree zsh-syntax-highlighting
chsh -s "$(which zsh)"
```

On Debian `fd` is called `fdfind`. Add `alias fd=fdfind` to your aliases.

## 2. Layout

Each top-level folder is a package. Files inside mirror their path under `$HOME`:

```
dotfiles/
  Makefile
  zsh/.zshrc
  git/.gitconfig
  tmux/.config/tmux/tmux.conf
  nvim/.config/nvim/init.lua
```

## 3. Makefile

```make
DOTFILES := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
STOW     := stow --dir="$(DOTFILES)" --target="$(HOME)"
PACKAGES := $(patsubst %/,%,$(wildcard */))

.PHONY: link adopt unlink

link:
	@$(STOW) --restow $(PACKAGES)

adopt:
	@$(STOW) --adopt --restow $(PACKAGES)

unlink:
	@$(STOW) --delete $(PACKAGES)
```

## 4. Create your repo

Start empty, add the Makefile above, then move your existing configs in:

```bash
mkdir ~/dotfiles && cd ~/dotfiles && git init
mkdir -p zsh git tmux/.config nvim/.config
mv ~/.zshrc zsh/
mv ~/.gitconfig git/
mv ~/.config/tmux tmux/.config/
mv ~/.config/nvim nvim/.config/
make
```

Only move what you actually have. `make` creates the symlinks back into `$HOME`. Then push it to your own GitHub repo.

## 5. Daily use

Files in `$HOME` are symlinks to the repo, so editing `~/.zshrc` edits the repo. Sync with git commit, push and pull.

New app: move its config into a new package folder the same way and run `make`.

## 6. Another machine

```bash
git clone <your-repo-url> ~/dotfiles && cd ~/dotfiles
make adopt     # takes any existing configs into the repo, then symlinks
git diff       # review; `git checkout -- <file>` to keep the repo version
```
