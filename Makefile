# Dotfiles — GNU stow symlink farm.
# Editing a stowed file in ~ edits the repo file directly (it's a symlink),
# so daily edits need NO make target. Mirror across machines with git push/pull.
#
#   make              link/refresh symlinks (run only after adding NEW files)
#   make update       check every package for drift vs ~, restow only what changed
#   make claim        NEW MACHINE default: repo wins over ~, prompts before
#                       overwriting each real conflicting file (e.g. a default
#                       ~/.zshrc created before this repo was cloned)
#   make adopt        opposite direction: absorb existing ~ files into the
#                       repo (device wins), then link — no prompts
#   make unlink       remove all symlinks from ~
#   make candidates   list ~ files/dirs not yet stowed (tune noise in .candidates-ignore)
#   make new          scaffold a package from a candidate and stow it, e.g.:
#                       make new NAME=alacritty FILE=.config/alacritty/alacritty.toml
#   make move         relocate this repo to a new path, e.g.:
#                       make move NEW=~/projects/dotfiles
#
# The repo can live anywhere: DOTFILES below is derived from the Makefile's
# own location, never hardcoded. Only `make move` moves an already-stowed
# checkout safely — a plain `mv` leaves dangling relative symlinks in ~,
# which stow then refuses to touch (treats them as foreign, not its own).

MAKEFLAGS += --no-print-directory
DOTFILES := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
STOW     := stow --dir="$(DOTFILES)" --target="$(HOME)"
# Every top-level directory is a stow package, except tooling dirs that
# aren't meant to be linked into $(HOME).
NON_PACKAGE_DIRS := bin ~
PACKAGES := $(filter-out $(NON_PACKAGE_DIRS),$(patsubst %/,%,$(wildcard */)))

.DEFAULT_GOAL := link
.PHONY: link update claim adopt unlink hooks candidates new move

hooks:
	@git -C $(DOTFILES) config core.hooksPath .githooks

link: hooks
	@$(STOW) --restow $(PACKAGES)
	@echo "Linked: $(PACKAGES)"

update: hooks
	@$(DOTFILES)/bin/update

claim: hooks
	@$(DOTFILES)/bin/claim

adopt: hooks
	@$(STOW) --adopt --restow $(PACKAGES)
	@echo "Adopted into repo. Review with 'git diff'."

unlink:
	@$(STOW) --delete $(PACKAGES)
	@echo "Unlinked: $(PACKAGES)"

candidates:
	@$(DOTFILES)/bin/candidates

new:
	@test -n "$(NAME)" -a -n "$(FILE)" || { \
		echo "Usage: make new NAME=<package> FILE=<path relative to \$$HOME>"; \
		echo "e.g.:  make new NAME=alacritty FILE=.config/alacritty/alacritty.toml"; \
		exit 1; \
	}
	@test -e "$(HOME)/$(FILE)" || { echo "No such file: $(HOME)/$(FILE)"; exit 1; }
	@mkdir -p "$(DOTFILES)/$(NAME)/$$(dirname $(FILE))"
	@touch "$(DOTFILES)/$(NAME)/$(FILE)"
	@$(STOW) --adopt --restow $(NAME)
	@echo "Adopted $(HOME)/$(FILE) into $(NAME)/$(FILE)."
	@echo "Review:  git -C $(DOTFILES) diff -- $(NAME)"

move:
	@dest=$$(echo $(NEW)); \
	test -n "$$dest" || { echo "Usage: make move NEW=<new path for this repo>"; exit 1; }; \
	test ! -e "$$dest" || { echo "Target already exists: $$dest"; exit 1; }; \
	$(STOW) --delete $(PACKAGES); \
	mkdir -p "$$(dirname "$$dest")"; \
	mv "$(DOTFILES)" "$$dest"; \
	$(MAKE) -C "$$dest" link; \
	echo "Moved dotfiles: $(DOTFILES) -> $$dest"
