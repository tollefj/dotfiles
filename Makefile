# Dotfiles — GNU stow symlink farm.
# Editing a stowed file in ~ edits the repo file directly (it's a symlink),
# so daily edits need NO make target. Mirror across machines with git push/pull.
#
#   make          link/refresh symlinks (run only after adding NEW files)
#   make adopt    first time on a machine: absorb existing ~ files, then link
#   make unlink   remove all symlinks from ~

MAKEFLAGS += --no-print-directory
DOTFILES := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
STOW     := stow --dir="$(DOTFILES)" --target="$(HOME)"
PACKAGES := shell bash vim git nvim tmux btop gh zathura zsh iterm2

.DEFAULT_GOAL := link
.PHONY: link adopt unlink hooks

hooks:
	@git -C $(DOTFILES) config core.hooksPath .githooks

link: hooks
	@$(STOW) --restow $(PACKAGES)
	@echo "Linked: $(PACKAGES)"

adopt: hooks
	@$(STOW) --adopt --restow $(PACKAGES)
	@echo "Adopted into repo. Review with 'git diff'."

unlink:
	@$(STOW) --delete $(PACKAGES)
	@echo "Unlinked: $(PACKAGES)"
