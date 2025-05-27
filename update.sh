#!/bin/bash

# - stashes local uncommitted changes (including untracked files) before syncing.
# - fetches remote changes.
# - determines relationship between local and remote branch.
# - pulls with rebase if remote is ahead.
# - pushes if local is ahead.
# - informs user if branches have diverged, requiring manual intervention.
# - attempts to reapply stashed changes after sync operations.
# - provides guidance for conflicts or remaining changes after stash pop.
# - returns to the original directory upon completion or error.

local dfdir="$HOME/dotfiles"
local original_dir
original_dir=$(pwd) # Save original directory to return to later

# --- 1. Setup & Checks ---
if [ ! -d "$dfdir/.git" ]; then
    echo "Error: $dfdir is not a git repository." >&2
    return 1
fi

# Use pushd / popd to manage directory changes robustly
if ! pushd "$dfdir" > /dev/null; then
    echo "Error: Could not change directory to $dfdir" >&2
    return 1
fi
# Ensure popd is called on exit, regardless of how the function exits
# trap 'popd > /dev/null' EXIT # Removed as it can interfere with multiple calls / sourcing

echo "=== Syncing dotfiles in $dfdir ==="

# --- 2. Handle Local Uncommitted Changes ---
local stashed_changes=false
# Check if there are any changes (staged, unstaged, or untracked)
if [ -n "$(git status --porcelain)" ]; then
    echo "Uncommitted changes or untracked files detected. Stashing..."
    # Use -u to include untracked files, -m for a stash message
    if git stash push -u -m "syncdotfiles autostash: $(date '+%Y-%m-%d %H:%M:%S')"; then
        stashed_changes=true
        echo "Local changes stashed."
    else
        echo "Error: Failed to stash local changes." >&2
        popd > /dev/null # Return to original directory
        return 1
    fi
else
    echo "Working directory is clean. No local changes to stash."
fi

# --- 3. Fetch Remote ---
echo "Fetching remote updates..."
if ! git fetch; then
    echo "Error: Failed to fetch from remote." >&2
    # Attempt to reapply stash if stashing occurred, before exiting
    if [ "$stashed_changes" = true ]; then
        echo "Attempting to reapply stashed changes before exiting due to fetch error..."
        # Try to pop, but don't error out if it fails, just warn.
        git stash pop --index || echo "Warning: Could not automatically reapply stashed changes. Please do it manually with 'git stash pop'." >&2
    fi
    popd > /dev/null # Return to original directory
    return 1
fi

# --- 4. Determine Status (Local vs. Remote) ---
local local_rev remote_rev base_rev current_branch
current_branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)

if [ -z "$current_branch" ]; then
    echo "Error: Could not determine current branch." >&2
    # Attempt to reapply stash if necessary
    if [ "$stashed_changes" = true ]; then
        git stash pop --index || echo "Warning: Could not reapply stashed changes. Use 'git stash pop' manually." >&2
    fi
    popd > /dev/null
    return 1
fi

# Check for upstream branch configuration for the current branch
if ! git rev-parse --verify "@"{u} > /dev/null 2>&1; then
    echo "Error: No upstream branch configured for branch '$current_branch'." >&2
    echo "Please set it, e.g., with: git branch --set-upstream-to=origin/$current_branch" >&2
    echo "Or, if this is a new branch, push with: git push -u origin $current_branch" >&2
    if [ "$stashed_changes" = true ]; then
        echo "Attempting to reapply stashed changes..."
        git stash pop --index || echo "Warning: Could not reapply stashed changes. Use 'git stash pop' manually." >&2
    fi
    popd > /dev/null
    return 1
fi

local_rev=$(git rev-parse @)
remote_rev=$(git rev-parse @{u}) # Current branch's upstream
base_rev=$(git merge-base @ @{u})

# --- 5. Synchronization Logic ---
if [ "$local_rev" = "$remote_rev" ]; then
    echo "Dotfiles are up to date with remote."
elif [ "$local_rev" = "$base_rev" ]; then
    echo "Remote has updates. Attempting to pull with rebase..."
    if git pull --rebase; then
        echo "Successfully pulled and rebased remote changes."
    else
        echo "Error: 'git pull --rebase' failed. Conflicts may exist." >&2
        echo "Please resolve conflicts manually. You might need:" >&2
        echo "  git rebase --abort   (to cancel the rebase)" >&2
        echo "  (resolve conflicts, git add <files>, git rebase --continue)" >&2
        # Stash will be handled in section 6, but no automatic pop if rebase is in progress.
        popd > /dev/null
        return 1 # Critical failure, requires manual intervention
    fi
elif [ "$remote_rev" = "$base_rev" ]; then
    echo "Local branch is ahead of remote. Pushing..."
    if git push; then
        echo "Successfully pushed local changes."
    else
        echo "Error: Failed to push local changes. Remote might have rejected them." >&2
        # Stash will be handled in section 6.
        popd > /dev/null
        return 1
    fi
else
    echo "Diverged history: Local and remote have different changes." >&2
    echo "Manual intervention required. Please inspect the state." >&2
    echo "Suggestions:" >&2
    echo "  1. To rebase your local changes on top of remote: git pull --rebase" >&2
    echo "  2. To merge remote changes into your local branch: git pull" >&2
    echo "After resolving any conflicts, remember to 'git push'." >&2
    echo "Current status:"
    git status -s
    # Stash will be handled in section 6. User needs to manage divergence.
fi

# --- 6. Reapply Stashed Changes ---
if [ "$stashed_changes" = true ]; then
    echo "Attempting to reapply stashed changes..."
    # Check if a rebase (from pull --rebase) or merge is currently in progress
    if [ -d ".git/rebase-merge" ] || [ -d ".git/REBASE_HEAD" ] || [ -f ".git/MERGE_HEAD" ]; then
        echo "Warning: A rebase or merge is currently in progress." >&2
        echo "Please resolve it first, then manually run 'git stash pop' to reapply your stashed changes." >&2
    elif git stash pop --index; then # --index tries to restore the staging area state as well
        echo "Stashed changes successfully reapplied."
        if [ -n "$(git status --porcelain)" ]; then
            echo "There are uncommitted changes after reapplying the stash."
            echo "Please review and commit them manually if desired:"
            echo "  git status"
            echo "  git add -A"
            echo "  git commit -m \"Apply stashed changes after sync\""
        else
            echo "Reapplied stash resulted in no new uncommitted changes."
        fi
    else
        echo "Warning: Could not automatically reapply stashed changes (possibly due to conflicts with updated files)." >&2
        echo "Your changes are still stashed. Use 'git stash list' to see them." >&2
        echo "Apply manually with: 'git stash apply --index' (or 'git stash pop --index')." >&2
        echo "Then resolve any conflicts and commit."
        git status -s # Show status to help with conflict resolution
    fi
fi

# --- 7. Cleanup ---
popd > /dev/null # Return to the original directory
echo "=== Dotfiles sync process complete. ==="
