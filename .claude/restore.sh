#!/usr/bin/env bash
set -euo pipefail

# Claude Code Plugin Restore Script
# This script restores marketplaces and plugins on a new machine
# Usage: ./restore.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KNOWN_MARKETPLACES="$SCRIPT_DIR/plugins/known_marketplaces.json"
INSTALLED_PLUGINS="$SCRIPT_DIR/plugins/installed_plugins.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if required files exist
check_files() {
    local missing=0

    if [[ ! -f "$KNOWN_MARKETPLACES" ]]; then
        echo -e "${RED}Error: known_marketplaces.json not found at $KNOWN_MARKETPLACES${NC}"
        missing=1
    fi

    if [[ ! -f "$INSTALLED_PLUGINS" ]]; then
        echo -e "${RED}Error: installed_plugins.json not found at $INSTALLED_PLUGINS${NC}"
        missing=1
    fi

    if [[ $missing -eq 1 ]]; then
        exit 1
    fi
}

# Check if jq is available
check_dependencies() {
    if ! command -v jq &> /dev/null; then
        echo -e "${RED}Error: jq is required but not installed${NC}"
        echo "Install with: brew install jq (macOS) or apt-get install jq (Linux)"
        exit 1
    fi

    if ! command -v claude &> /dev/null; then
        echo -e "${RED}Error: claude CLI not found${NC}"
        echo "Please install Claude Code first"
        exit 1
    fi
}

# Restore marketplaces
restore_marketplaces() {
    echo -e "${BLUE}=== Restoring Marketplaces ===${NC}\n"

    local marketplaces
    marketplaces=$(jq -r 'keys[]' "$KNOWN_MARKETPLACES")

    if [[ -z "$marketplaces" ]]; then
        echo -e "${YELLOW}No marketplaces to restore${NC}\n"
        return
    fi

    while IFS= read -r marketplace_name; do
        echo -e "${YELLOW}Processing marketplace: $marketplace_name${NC}"

        local source_type
        source_type=$(jq -r --arg name "$marketplace_name" '.[$name].source.source' "$KNOWN_MARKETPLACES")

        case "$source_type" in
            git)
                local url
                url=$(jq -r --arg name "$marketplace_name" '.[$name].source.url' "$KNOWN_MARKETPLACES")
                echo "  Adding Git marketplace: $url"
                if claude plugin marketplace add "$url" 2>/dev/null; then
                    echo -e "  ${GREEN}✓ Added successfully${NC}"
                else
                    echo -e "  ${YELLOW}⚠ Already exists or failed${NC}"
                fi
                ;;
            github)
                local repo
                repo=$(jq -r --arg name "$marketplace_name" '.[$name].source.repo' "$KNOWN_MARKETPLACES")
                echo "  Adding GitHub marketplace: $repo"
                if claude plugin marketplace add "$repo" 2>/dev/null; then
                    echo -e "  ${GREEN}✓ Added successfully${NC}"
                else
                    echo -e "  ${YELLOW}⚠ Already exists or failed${NC}"
                fi
                ;;
            *)
                echo -e "  ${RED}✗ Unknown source type: $source_type${NC}"
                ;;
        esac
        echo
    done <<< "$marketplaces"
}

# Restore plugins
restore_plugins() {
    echo -e "${BLUE}=== Restoring Plugins ===${NC}\n"

    local plugin_count
    plugin_count=$(jq -r '.plugins | keys | length' "$INSTALLED_PLUGINS")

    if [[ "$plugin_count" -eq 0 ]]; then
        echo -e "${YELLOW}No plugins to restore${NC}\n"
        return
    fi

    echo -e "Found ${GREEN}$plugin_count${NC} plugins to install\n"

    local plugins
    plugins=$(jq -r '.plugins | keys[]' "$INSTALLED_PLUGINS")

    local installed=0
    local skipped=0
    local failed=0

    while IFS= read -r plugin_full_name; do
        echo -e "${YELLOW}Installing: $plugin_full_name${NC}"

        # Extract plugin scope
        local scope
        scope=$(jq -r --arg plugin "$plugin_full_name" '.plugins[$plugin][0].scope' "$INSTALLED_PLUGINS")

        # Build install command
        local install_cmd="claude plugin install"
        if [[ "$scope" != "user" ]]; then
            install_cmd="$install_cmd --scope $scope"
        fi
        install_cmd="$install_cmd $plugin_full_name"

        # Attempt installation
        if eval "$install_cmd" 2>/dev/null; then
            echo -e "  ${GREEN}✓ Installed successfully${NC}"
            ((installed++))
        else
            # Check if already installed
            if claude plugin list 2>/dev/null | grep -q "$plugin_full_name"; then
                echo -e "  ${YELLOW}⚠ Already installed${NC}"
                ((skipped++))
            else
                echo -e "  ${RED}✗ Installation failed${NC}"
                ((failed++))
            fi
        fi
        echo
    done <<< "$plugins"

    # Summary
    echo -e "${BLUE}=== Installation Summary ===${NC}"
    echo -e "  ${GREEN}Installed: $installed${NC}"
    echo -e "  ${YELLOW}Skipped:   $skipped${NC}"
    echo -e "  ${RED}Failed:    $failed${NC}"
    echo
}

# Update marketplaces
update_marketplaces() {
    echo -e "${BLUE}=== Updating Marketplaces ===${NC}\n"
    echo "This may take a few moments..."

    if claude plugin marketplace update 2>/dev/null; then
        echo -e "${GREEN}✓ Marketplaces updated${NC}\n"
    else
        echo -e "${YELLOW}⚠ Update completed with warnings${NC}\n"
    fi
}

# Main execution
main() {
    echo -e "${GREEN}"
    echo "╔═══════════════════════════════════════════╗"
    echo "║   Claude Code Plugin Restore Script      ║"
    echo "╚═══════════════════════════════════════════╝"
    echo -e "${NC}\n"

    check_dependencies
    check_files

    echo -e "Restoring from: ${BLUE}$SCRIPT_DIR${NC}\n"

    restore_marketplaces
    update_marketplaces
    restore_plugins

    echo -e "${GREEN}✓ Restore complete!${NC}"
    echo -e "\nRun ${BLUE}claude plugin list${NC} to verify installed plugins"
}

main "$@"
