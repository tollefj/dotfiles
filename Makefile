MAKEFLAGS += --no-print-directory
SHELL := /bin/bash

DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
HOME_DIR     := $(HOME)
OS           := $(shell uname -s)

STOW := stow --dir="$(DOTFILES_DIR)" --target="$(HOME_DIR)"

# Packages shared across machines.
COMMON := shell bash vim git nvim tmux btop gh zathura

ifeq ($(OS),Darwin)
PACKAGES := $(COMMON) zsh iterm2
else
PACKAGES := $(COMMON) zsh-wsl
endif

.DEFAULT_GOAL := help

# ── Core ──────────────────────────────────────────────

.PHONY: help
help: ## Show available targets
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ {printf "  \033[94m%-12s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "  Packages for $(OS): $(PACKAGES)"

.PHONY: init
init: ## Activate repo git hooks (blocks committing embedded git repos)
	@git -C $(DOTFILES_DIR) config core.hooksPath .githooks
	@echo "Hooks active: .githooks (gitlink guard)"

.PHONY: stow
stow: init ## Symlink all packages into $HOME
	@$(STOW) --stow $(PACKAGES)
	@echo "Stowed: $(PACKAGES)"

.PHONY: restow
restow: init ## Refresh symlinks (delete + stow); use after renaming files
	@$(STOW) --restow $(PACKAGES)
	@echo "Restowed: $(PACKAGES)"

.PHONY: unstow
unstow: ## Remove all symlinks this repo created from $HOME
	@$(STOW) --delete $(PACKAGES)
	@echo "Unstowed: $(PACKAGES)"

.PHONY: adopt
adopt: init ## First-time migration: pull existing ~ files into the repo, then symlink
	@echo "Adopting existing files in $(HOME_DIR) into the repo..."
	@$(STOW) --adopt --stow $(PACKAGES)
	@echo ""
	@echo "Done. Review with 'git diff' — committed content was overwritten by"
	@echo "whatever was live in \$$HOME. 'git checkout .' reverts unwanted drift."

.PHONY: dry
dry: ## Dry run: show what stow would link without changing anything
	@$(STOW) --no --verbose=2 --stow $(PACKAGES)

# ── Inspection ────────────────────────────────────────

.PHONY: doctor
doctor: ## Verify environment and symlink health
	@echo "=== Environment ===" && \
		echo "  OS:       $(OS)" && \
		echo "  Home:     $(HOME_DIR)" && \
		echo "  Repo:     $(DOTFILES_DIR)" && \
		echo "  Stow:     $$(stow --version 2>/dev/null | head -1 || echo 'NOT INSTALLED')" && \
		echo "  Git:      $$(git --version)" && \
		echo "" && \
		echo "=== Packages ===" && \
		echo "  $(PACKAGES)" && \
		echo "" && \
		echo "=== Conflicts (dry run) ===" && \
		($(STOW) --no --verbose=1 --stow $(PACKAGES) 2>&1 | grep -i 'conflict\|existing' || echo "  none")

# ── Backup & Snapshot ─────────────────────────────────

.PHONY: backup-brew
backup-brew: ## Export Homebrew packages to Brewfile
ifeq ($(OS),Darwin)
	@cd $(DOTFILES_DIR) && brew bundle dump --force --describe
	@echo "Brewfile updated ($(shell wc -l < $(DOTFILES_DIR)/Brewfile 2>/dev/null | tr -d ' ') entries)"
else
	@echo "Skipped: not macOS"
endif

# ── App Setup ─────────────────────────────────────────

.PHONY: iterm2
iterm2: ## Point iTerm2 at the stowed prefs folder
ifeq ($(OS),Darwin)
	@if [ "$$(defaults read com.googlecode.iTerm2 LoadPrefsFromCustomFolder 2>/dev/null)" != "1" ] || \
	   [ "$$(defaults read com.googlecode.iTerm2 PrefsCustomFolder 2>/dev/null)" != "$(HOME_DIR)/.config/iterm2/prefs" ]; then \
		defaults write com.googlecode.iTerm2 PrefsCustomFolder -string "$(HOME_DIR)/.config/iterm2/prefs"; \
		defaults write com.googlecode.iTerm2 LoadPrefsFromCustomFolder -bool YES; \
		echo "iTerm2: configured to use $(HOME_DIR)/.config/iterm2/prefs — restart iTerm2."; \
	else \
		echo "iTerm2: already configured."; \
	fi
else
	@echo "Skipped: not macOS"
endif

.PHONY: macos
macos: ## Apply macOS system preferences
ifeq ($(OS),Darwin)
	@echo "Applying macOS defaults..."
	defaults write NSGlobalDomain AppleShowAllExtensions -bool true
	defaults write com.apple.finder AppleShowAllFiles -bool true
	defaults write com.apple.finder ShowPathbar -bool true
	defaults write com.apple.finder ShowStatusBar -bool true
	defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
	defaults write com.apple.dock autohide -bool true
	defaults write NSGlobalDomain KeyRepeat -int 2
	defaults write NSGlobalDomain InitialKeyRepeat -int 15
	@echo "Done. Some changes require logout or restart."
else
	@echo "Skipped: not macOS"
endif

# ── Maintenance ───────────────────────────────────────

.PHONY: clean
clean: ## Remove caches and temp files from repo
	@find $(DOTFILES_DIR) -name '.DS_Store' -delete 2>/dev/null || true
	@find $(DOTFILES_DIR) -name '*.swp' -delete 2>/dev/null || true
	@echo "Cleaned."
