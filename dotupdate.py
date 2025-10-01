#!/usr/bin/env python3
"""
dotupdate.py - Comprehensive dotfiles synchronization tool

Automatically discovers dotfiles in the repository and prompts for each one.
Handles both files and directories (like .config/nvim) intelligently,
copying only contents into existing directories to avoid overwrites.
"""

import os
import sys
import time
import shutil
import subprocess
from pathlib import Path
from typing import List, Set, Optional, Dict, Any


class Colors:
    """ANSI color codes for terminal output"""
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    RESET = '\033[0m'
    BOLD = '\033[1m'


def log(message: str, color: str = Colors.RESET):
    """Print colored log message"""
    print(f"{color}{message}{Colors.RESET}")


def log_error(message: str):
    """Print error message in red"""
    log(f"✗ {message}", Colors.RED)


def log_success(message: str):
    """Print success message in green"""
    log(f"✓ {message}", Colors.GREEN)


def log_info(message: str):
    """Print info message in blue"""
    log(f"→ {message}", Colors.BLUE)


def log_warning(message: str):
    """Print warning message in yellow"""
    log(f"⚠ {message}", Colors.YELLOW)


def load_yaml_config(config_path: Path) -> Dict[str, Any]:
    """
    Load YAML config file without external dependencies.
    Simple parser for basic YAML lists.
    """
    config = {'ignore_items': []}

    if not config_path.exists():
        return config

    try:
        with open(config_path, 'r') as f:
            in_list = False
            current_key = None

            for line in f:
                line = line.rstrip()

                # Skip comments and empty lines
                if not line or line.strip().startswith('#'):
                    continue

                # Check for key (no leading spaces, ends with colon)
                if line and not line[0].isspace() and ':' in line:
                    key = line.split(':')[0].strip()
                    current_key = key
                    in_list = True
                    continue

                # Check for list item (starts with spaces and dash)
                if in_list and line.strip().startswith('-'):
                    item = line.strip()[1:].strip()
                    # Remove quotes if present
                    item = item.strip('"').strip("'")
                    if current_key == 'ignore_items':
                        config['ignore_items'].append(item)

        return config
    except Exception as e:
        log_warning(f"Could not load config file: {e}")
        return config


def prompt_yes_no(question: str, default: bool = False) -> bool:
    """
    Ask a yes/no question and return the answer.
    Default is 'No' unless specified otherwise.
    """
    prompt_text = f"{question} [y/N]: " if not default else f"{question} [Y/n]: "

    while True:
        try:
            response = input(prompt_text).strip().lower()
            if not response:
                return default
            if response in ('y', 'yes'):
                return True
            if response in ('n', 'no'):
                return False
            print("Please answer 'y' or 'n'")
        except EOFError:
            return default


class GitSync:
    """Handles git repository synchronization"""

    def __init__(self, repo_dir: Path):
        self.repo_dir = repo_dir
        self.stashed = False

    def _run_git(self, args: List[str], check: bool = True, capture: bool = False) -> Optional[str]:
        """Execute git command"""
        try:
            result = subprocess.run(
                ["git"] + args,
                cwd=self.repo_dir,
                check=check,
                capture_output=capture,
                text=True
            )
            if capture:
                return result.stdout.strip()
            return None
        except subprocess.CalledProcessError as e:
            if check:
                log_error(f"Git command failed: git {' '.join(args)}")
                if e.stderr:
                    log_error(e.stderr)
                raise
            return None

    def has_changes(self) -> bool:
        """Check if there are uncommitted changes"""
        status = self._run_git(["status", "--porcelain"], capture=True)
        return bool(status)

    def stash_changes(self) -> bool:
        """Stash local changes if any exist"""
        if not self.has_changes():
            log_info("Working directory is clean")
            return False

        log_info("Stashing local changes...")
        timestamp = time.strftime("%Y-%m-%d %H:%M:%S")
        self._run_git(["stash", "push", "-u", "-m", f"dotupdate autostash: {timestamp}"])
        self.stashed = True
        log_success("Changes stashed")
        return True

    def pop_stash(self):
        """Reapply stashed changes"""
        if not self.stashed:
            return

        log_info("Reapplying stashed changes...")
        try:
            self._run_git(["stash", "pop", "--index"])
            log_success("Stashed changes reapplied")
        except subprocess.CalledProcessError:
            log_warning("Could not auto-reapply stash (conflicts?). Use 'git stash pop' manually.")

    def sync(self) -> bool:
        """Synchronize with remote repository"""
        log(f"\n{'='*50}", Colors.HEADER)
        log("GIT SYNCHRONIZATION", Colors.HEADER + Colors.BOLD)
        log(f"{'='*50}\n", Colors.HEADER)

        # Stash changes
        self.stash_changes()

        try:
            # Fetch remote
            log_info("Fetching from remote...")
            self._run_git(["fetch"])

            # Get branch info
            current_branch = self._run_git(["symbolic-ref", "--short", "HEAD"], capture=True)

            # Check if upstream is configured
            try:
                self._run_git(["rev-parse", "--verify", "@{u}"], capture=True)
            except subprocess.CalledProcessError:
                log_warning(f"No upstream configured for branch '{current_branch}'")
                return False

            # Compare local and remote
            local_rev = self._run_git(["rev-parse", "@"], capture=True)
            remote_rev = self._run_git(["rev-parse", "@{u}"], capture=True)
            base_rev = self._run_git(["merge-base", "@", "@{u}"], capture=True)

            if local_rev == remote_rev:
                log_success("Already up to date with remote")
            elif local_rev == base_rev:
                log_info("Remote has updates. Pulling with rebase...")
                self._run_git(["pull", "--rebase"])
                log_success("Successfully pulled and rebased")
            elif remote_rev == base_rev:
                log_info("Local is ahead of remote. Pushing...")
                self._run_git(["push"])
                log_success("Successfully pushed")
            else:
                log_warning("Branches have diverged - manual intervention required")
                log_info("Run: git pull --rebase")
                return False

            return True

        finally:
            self.pop_stash()

    def commit_and_push(self, message: Optional[str] = None):
        """Commit and push changes"""
        if not self.has_changes():
            log_info("No changes to commit")
            return

        if message is None:
            timestamp = time.strftime("%H:%M - %d/%m/%y")
            message = f"Automated commit at {timestamp}"

        log_info(f"Committing: {message}")
        self._run_git(["add", "-A"])
        self._run_git(["commit", "-m", message])
        self._run_git(["push"])
        log_success("Changes committed and pushed")


class DotfileSync:
    """Handles dotfile synchronization between home and repo"""

    def __init__(self, home_dir: Path, repo_dir: Path, ignore_items: Set[str] = None):
        self.home_dir = home_dir
        self.repo_dir = repo_dir
        self.repo_modified = False
        self.ignore_items = ignore_items or set()

    @staticmethod
    def get_mtime(path: Path) -> float:
        """Get modification time of file or directory"""
        return path.stat().st_mtime

    @staticmethod
    def are_timestamps_close(path1: Path, path2: Path, tolerance: int = 100) -> bool:
        """Check if two paths have similar modification times"""
        mtime1 = DotfileSync.get_mtime(path1)
        mtime2 = DotfileSync.get_mtime(path2)
        return abs(mtime1 - mtime2) < tolerance

    @staticmethod
    def is_newer(path1: Path, path2: Path, buffer: int = 100) -> bool:
        """Check if path1 is newer than path2 (with buffer for tie-breaking)"""
        mtime1 = DotfileSync.get_mtime(path1)
        mtime2 = DotfileSync.get_mtime(path2)
        return mtime1 > (mtime2 - buffer)

    def copy_directory_contents(self, src: Path, dest: Path):
        """
        Copy contents of src directory into dest directory.
        If dest exists, merge contents; if not, create it.
        This prevents overwriting an existing .config directory.
        """
        dest.mkdir(parents=True, exist_ok=True)

        for item in src.iterdir():
            src_item = src / item.name
            dest_item = dest / item.name

            if src_item.is_dir():
                # Recursively copy subdirectories
                self.copy_directory_contents(src_item, dest_item)
            else:
                # Copy file
                shutil.copy2(src_item, dest_item)

        # Preserve directory metadata
        shutil.copystat(src, dest)

    def copy_file(self, src: Path, dest: Path):
        """Copy a single file with metadata"""
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(src, dest)

    def discover_dotfiles(self) -> List[str]:
        """
        Discover all dotfiles and config directories in the repo.
        Returns list of relative paths from repo root.
        """
        discovered = []

        # Scan repo root for dotfiles
        for item in self.repo_dir.iterdir():
            name = item.name

            # Skip ignored items
            if name in self.ignore_items:
                continue

            # Include dotfiles (starting with .)
            if name.startswith('.'):
                discovered.append(name)
            # Include common config directories like 'nvim'
            elif item.is_dir() and name in ['nvim']:
                discovered.append(name)

        # Scan .config directory if it exists
        config_dir = self.repo_dir / '.config'
        if config_dir.exists() and config_dir.is_dir():
            for subdir in config_dir.iterdir():
                if subdir.is_dir():
                    discovered.append(f'.config/{subdir.name}')

        return sorted(discovered)

    def get_sync_info(self, item_path: str) -> tuple:
        """
        Get information about sync status for an item.
        Returns (status, description, action, color, symbol)
        """
        home_path = self.home_dir / item_path
        repo_path = self.repo_dir / item_path

        home_exists = home_path.exists()
        repo_exists = repo_path.exists()

        if not home_exists and not repo_exists:
            return ('not_found', 'Not found', 'skip', Colors.RESET, '?')

        if home_exists and not repo_exists:
            item_type = 'dir' if home_path.is_dir() else 'file'
            return ('new_in_home', f'New {item_type} in home → repo', 'add_to_repo', Colors.YELLOW, '←')

        if repo_exists and not home_exists:
            item_type = 'dir' if repo_path.is_dir() else 'file'
            return ('new_in_repo', f'New {item_type} in repo → home', 'copy_to_home', Colors.BLUE, '→')

        # Both exist
        home_is_dir = home_path.is_dir()
        repo_is_dir = repo_path.is_dir()

        if home_is_dir != repo_is_dir:
            return ('type_mismatch', 'Type mismatch!', 'skip', Colors.RED, '✗')

        if self.are_timestamps_close(home_path, repo_path):
            return ('in_sync', 'In sync', 'skip', Colors.GREEN, '✓')

        if self.is_newer(repo_path, home_path):
            return ('repo_newer', 'Repo newer → home', 'update_home', Colors.CYAN, '→')
        else:
            return ('home_newer', 'Home newer → repo', 'update_repo', Colors.YELLOW, '←')

    def sync_item(self, item_path: str, verbose: bool = True) -> bool:
        """
        Synchronize a single dotfile or directory.
        Returns True if repo was modified.
        """
        if verbose:
            log(f"\n{'-'*50}", Colors.CYAN)
            log(f"Syncing: {item_path}", Colors.CYAN + Colors.BOLD)
            log(f"{'-'*50}", Colors.CYAN)

        home_path = self.home_dir / item_path
        repo_path = self.repo_dir / item_path

        home_exists = home_path.exists()
        repo_exists = repo_path.exists()

        # Determine if it's a directory
        is_directory = False
        if home_exists:
            is_directory = home_path.is_dir()
        elif repo_exists:
            is_directory = repo_path.is_dir()
        else:
            if verbose:
                log_warning(f"'{item_path}' not found - skipping")
            return False

        try:
            # Case 1: Only in home (add to repo)
            if home_exists and not repo_exists:
                if verbose:
                    log_info(f"Adding to repo from home")
                if is_directory:
                    repo_path.mkdir(parents=True, exist_ok=True)
                    self.copy_directory_contents(home_path, repo_path)
                else:
                    self.copy_file(home_path, repo_path)
                if verbose:
                    log_success(f"Added to repository")
                return True

            # Case 2: Only in repo (copy to home)
            elif repo_exists and not home_exists:
                if verbose:
                    log_info(f"Copying to home from repo")
                if is_directory:
                    home_path.mkdir(parents=True, exist_ok=True)
                    self.copy_directory_contents(repo_path, home_path)
                else:
                    self.copy_file(repo_path, home_path)
                if verbose:
                    log_success(f"Copied to home")
                return False

            # Case 3: Exists in both
            elif home_exists and repo_exists:
                home_is_dir = home_path.is_dir()
                repo_is_dir = repo_path.is_dir()

                if home_is_dir != repo_is_dir:
                    if verbose:
                        log_error(f"Type mismatch - skipping")
                    return False

                if self.are_timestamps_close(home_path, repo_path):
                    if verbose:
                        log_success("Already in sync")
                    return False

                # Sync based on which is newer
                if self.is_newer(repo_path, home_path):
                    if verbose:
                        log_info("Updating home from repo")
                    if is_directory:
                        self.copy_directory_contents(repo_path, home_path)
                    else:
                        self.copy_file(repo_path, home_path)
                    if verbose:
                        log_success("Home updated")
                    return False
                else:
                    if verbose:
                        log_info("Updating repo from home")
                    if is_directory:
                        self.copy_directory_contents(home_path, repo_path)
                    else:
                        self.copy_file(home_path, repo_path)
                    if verbose:
                        log_success("Repo updated")
                    return True

        except Exception as e:
            if verbose:
                log_error(f"Error: {e}")
            return False

        return False

    def interactive_sync(self):
        """
        Interactive synchronization - discover files and ask for each one.
        """
        log(f"\n{'='*50}", Colors.HEADER)
        log("DISCOVERING DOTFILES", Colors.HEADER + Colors.BOLD)
        log(f"{'='*50}\n", Colors.HEADER)

        items = self.discover_dotfiles()

        if not items:
            log_warning("No dotfiles found in repository")
            return

        log_info(f"Found {len(items)} dotfile(s) in repository\n")

        # Display all items with status
        item_info = []
        for i, item in enumerate(items, 1):
            status, description, action, color, symbol = self.get_sync_info(item)
            item_info.append((item, status, description, action))
            log(f"{color}{symbol} [{i:2d}] {item:30s} {description}{Colors.RESET}")

        log(f"\n{'-'*50}\n", Colors.CYAN)
        log_info("Default: No (press Enter to skip, 'y' to sync)")
        print()

        # Ask for each item
        selected_items = []
        for item, status, description, action in item_info:
            if action == 'skip':
                if status == 'in_sync':
                    log(f"⊙ {item} - already in sync, skipping", Colors.GREEN)
                else:
                    log_warning(f"Skipping {item} - {description}")
                continue

            if prompt_yes_no(f"Sync {Colors.BOLD}{item}{Colors.RESET}?", default=False):
                selected_items.append(item)
                log_success(f"  ✓ Will sync {item}")
            else:
                log(f"  ✗ Skipped {item}", Colors.RESET)

        # Perform sync
        if not selected_items:
            log_warning("\nNo items selected for sync")
            return

        log(f"\n{'='*50}", Colors.HEADER)
        log(f"SYNCING {len(selected_items)} ITEM(S)", Colors.HEADER + Colors.BOLD)
        log(f"{'='*50}\n", Colors.HEADER)

        for item in selected_items:
            if self.sync_item(item):
                self.repo_modified = True


def main():
    """Main entry point"""
    log(f"\n{'#'*50}", Colors.HEADER + Colors.BOLD)
    log("DOTFILES UPDATE UTILITY", Colors.HEADER + Colors.BOLD)
    log(f"{'#'*50}\n", Colors.HEADER + Colors.BOLD)

    # Determine directories
    home_dir = Path.home()
    repo_dir = Path(__file__).parent.resolve()

    log_info(f"Home: {home_dir}")
    log_info(f"Repo: {repo_dir}")

    # Verify repo is a git repository
    if not (repo_dir / ".git").exists():
        log_error(f"{repo_dir} is not a git repository")
        sys.exit(1)

    # Load configuration
    config_path = repo_dir / "dotupdate.config.yaml"
    config = load_yaml_config(config_path)
    ignore_items = set(config.get('ignore_items', []))

    if ignore_items:
        log_info(f"Loaded {len(ignore_items)} ignore rule(s) from config")

    try:
        # Step 1: Git sync (pull latest)
        git = GitSync(repo_dir)
        if not git.sync():
            log_warning("Git sync incomplete - continuing anyway")

        # Step 2: Interactive dotfile sync
        dotfiles = DotfileSync(home_dir, repo_dir, ignore_items)
        dotfiles.interactive_sync()

        # Step 3: Commit and push if needed
        if dotfiles.repo_modified:
            log(f"\n{'='*50}", Colors.HEADER)
            log("COMMITTING CHANGES", Colors.HEADER + Colors.BOLD)
            log(f"{'='*50}\n", Colors.HEADER)
            git.commit_and_push()
        else:
            log_info("\nNo repository changes to commit")

        # Summary
        log(f"\n{'#'*50}", Colors.GREEN + Colors.BOLD)
        log("✓ DOTFILES UPDATE COMPLETE", Colors.GREEN + Colors.BOLD)
        log(f"{'#'*50}\n", Colors.GREEN + Colors.BOLD)

    except KeyboardInterrupt:
        log_warning("\n\nInterrupted by user")
        sys.exit(130)
    except Exception as e:
        log_error(f"\nFatal error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    main()
