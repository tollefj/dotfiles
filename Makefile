MAKEFLAGS += --no-print-directory
SHELL := /bin/bash

DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
HOME_DIR     := $(HOME)
OS           := $(shell uname -s)
PYTHON       := python3

.DEFAULT_GOAL := help

# ── Core ──────────────────────────────────────────────

.PHONY: help
help: ## Show available targets
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ {printf "  \033[94m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: sync
sync: ## Sync all dotfiles (default: auto, -i for interactive)
	@$(PYTHON) $(DOTFILES_DIR)/dotupdate.py

.PHONY: sync-interactive
sync-interactive: ## Sync dotfiles interactively (prompt per item)
	@$(PYTHON) $(DOTFILES_DIR)/dotupdate.py -i

.PHONY: push
push: ## Commit and push all changes
	@cd $(DOTFILES_DIR) && \
		git add -A && \
		git commit -m "Automated commit at $$(date '+%H:%M - %d/%m/%y')" && \
		git push

.PHONY: pull
pull: ## Pull latest from remote (rebase)
	@cd $(DOTFILES_DIR) && git pull --rebase

# ── Inspection ────────────────────────────────────────

.PHONY: status
status: ## Show sync status without making changes
	@echo "=== Git Status ===" && \
		cd $(DOTFILES_DIR) && git status --short && \
		echo "" && echo "=== Dotfile Diff ===" && \
		$(PYTHON) -c "\
from pathlib import Path; \
from dotupdate import DotfileSync, load_yaml_config, Colors, log; \
repo = Path('$(DOTFILES_DIR)'); \
cfg = load_yaml_config(repo / 'dotupdate.config.yaml'); \
ds = DotfileSync(Path.home(), repo, set(cfg.get('ignore_items', []))); \
items = ds.discover_dotfiles(); \
[log(f'{color}{symbol}  {item:30s} {desc}') for item in items for status, desc, action, color, symbol in [ds.get_sync_info(item)]]"

.PHONY: diff
diff: ## Show file-level diffs between home and repo
	@$(PYTHON) -c "\
from pathlib import Path; \
from dotupdate import DotfileSync, load_yaml_config; \
import subprocess, sys; \
repo = Path('$(DOTFILES_DIR)'); \
cfg = load_yaml_config(repo / 'dotupdate.config.yaml'); \
ds = DotfileSync(Path.home(), repo, set(cfg.get('ignore_items', []))); \
items = ds.discover_dotfiles(); \
found = False; \
[( \
    found := True, \
    print(f'\n\033[1m--- {item} ---\033[0m'), \
    subprocess.run(['diff', '--color=always', '-u', str(repo / item), str(Path.home() / item)]) \
) for item in items \
  if (repo / item).exists() and (Path.home() / item).exists() \
  and not ds.contents_match(repo / item, Path.home() / item) \
  and (repo / item).is_file() and (Path.home() / item).is_file()]; \
found or print('All files in sync.')"

.PHONY: list
list: ## List tracked dotfiles
	@$(PYTHON) -c "\
from pathlib import Path; \
from dotupdate import DotfileSync, load_yaml_config; \
repo = Path('$(DOTFILES_DIR)'); \
cfg = load_yaml_config(repo / 'dotupdate.config.yaml'); \
ds = DotfileSync(Path.home(), repo, set(cfg.get('ignore_items', []))); \
[print(f'  {item}') for item in ds.discover_dotfiles()]"

# ── Backup & Snapshot ─────────────────────────────────

.PHONY: backup-brew
backup-brew: ## Export Homebrew packages to Brewfile
ifeq ($(OS),Darwin)
	@cd $(DOTFILES_DIR) && brew bundle dump --force --describe
	@echo "Brewfile updated ($(shell wc -l < $(DOTFILES_DIR)/Brewfile) entries)"
else
	@echo "Skipped: not macOS"
endif

.PHONY: backup-pip
backup-pip: ## Export pip packages to requirements.txt
	@$(PYTHON) -m pip list --not-required --format=freeze > $(DOTFILES_DIR)/requirements.txt 2>/dev/null || \
		uv pip list --format=freeze > $(DOTFILES_DIR)/requirements.txt
	@echo "requirements.txt updated"

# ── Maintenance ───────────────────────────────────────

.PHONY: clean
clean: ## Remove caches and temp files from repo
	@rm -rf $(DOTFILES_DIR)/__pycache__
	@find $(DOTFILES_DIR) -name '.DS_Store' -delete 2>/dev/null || true
	@find $(DOTFILES_DIR) -name '*.swp' -delete 2>/dev/null || true
	@echo "Cleaned."

.PHONY: doctor
doctor: ## Verify dotfiles health
	@echo "=== Environment ===" && \
		echo "  OS:       $(OS)" && \
		echo "  Home:     $(HOME_DIR)" && \
		echo "  Repo:     $(DOTFILES_DIR)" && \
		echo "  Python:   $$($(PYTHON) --version 2>&1)" && \
		echo "  Git:      $$(git --version)" && \
		echo "" && \
		echo "=== Git ===" && \
		cd $(DOTFILES_DIR) && \
		echo "  Branch:   $$(git symbolic-ref --short HEAD)" && \
		echo "  Remote:   $$(git remote get-url origin 2>/dev/null || echo 'none')" && \
		echo "  Clean:    $$(git status --porcelain | wc -l | tr -d ' ') uncommitted change(s)" && \
		echo "" && \
		echo "=== Config ===" && \
		(test -f $(DOTFILES_DIR)/dotupdate.config.yaml && echo "  dotupdate.config.yaml: ok" || echo "  dotupdate.config.yaml: MISSING") && \
		echo "" && \
		echo "=== Dotfiles ===" && \
		$(PYTHON) -c "\
from pathlib import Path; \
from dotupdate import DotfileSync, load_yaml_config; \
repo = Path('$(DOTFILES_DIR)'); \
cfg = load_yaml_config(repo / 'dotupdate.config.yaml'); \
ds = DotfileSync(Path.home(), repo, set(cfg.get('ignore_items', []))); \
items = ds.discover_dotfiles(); \
synced = sum(1 for i in items if ds.get_sync_info(i)[0] == 'in_sync'); \
print(f'  Tracked:  {len(items)}'); \
print(f'  In sync:  {synced}/{len(items)}')"

.PHONY: edit
edit: ## Open dotfiles in default editor
	@$${EDITOR:-vim} $(DOTFILES_DIR)

# ── macOS Defaults ────────────────────────────────────

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
