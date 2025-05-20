import os
import time
import shutil
import subprocess

# Define the items to be synced. Paths are relative to home and repo root.
# Can include files or directories.
dot_items = [
    ".vimrc",
    ".gitconfig",
    ".bash_profile",
    ".zshrc",
    ".config/nvim"  # Example of a directory to sync
]

user = os.environ.get("USER")
# Home directory for dotfiles
dot_dir = os.path.join("/Users", user)  # macOS specific, modify if needed
# Directory of the Git repository. Assumes script is run from repo root.
git_dir = os.getcwd()
os.chdir(git_dir)  # Ensure Git commands run in the repo context


def get_mtime(path):
    """Returns the last modification time of a file or directory."""
    return os.path.getmtime(path)


def pretty_mtime(path):
    """Returns a human-readable last modification time."""
    return time.ctime(get_mtime(path))


def print_mtime_info(item_path):
    """Prints the last modification time for an item for debugging."""
    if os.path.exists(item_path):
        print(f"  Timestamp for {item_path}: {pretty_mtime(item_path)} ({get_mtime(item_path)})")
    else:
        print(f"  {item_path} does not exist.")


def is_newer_than(path1, path2, buffer_seconds=100):
    """
    Checks if path1 is considered newer than path2.
    path1 is "dominant" if its mtime is greater than (path2's mtime - buffer_seconds).
    This gives path1 a bias if timestamps are close or equal, meaning path1 will be
    considered the source unless path2 is significantly newer.
    """
    mtime1 = get_mtime(path1)
    mtime2 = get_mtime(path2)
    return mtime1 > (mtime2 - buffer_seconds)


def are_timestamps_close(path1, path2, tolerance_seconds=100):
    """
    Checks if the modification timestamps of path1 and path2 are close (within tolerance).
    Used to avoid unnecessary copies if they are already effectively in sync.
    """
    mtime1 = get_mtime(path1)
    mtime2 = get_mtime(path2)
    return abs(mtime1 - mtime2) < tolerance_seconds


class Git:
    def _call_git_command(self, command_args, check_output=False):
        git_command_list = ["git"] + command_args
        print(f"Executing: {' '.join(git_command_list)}")
        try:
            if check_output:
                return subprocess.check_output(git_command_list)
            else:
                subprocess.check_call(git_command_list)
                return None
        except subprocess.CalledProcessError as e:
            print(f"Git command failed: {' '.join(git_command_list)}\nError: {e}")
            # Depending on the command, you might want to raise the error or handle it
            raise  # Re-raise for critical operations like pull/commit
        except FileNotFoundError:
            print("Error: Git command not found. Is Git installed and in your PATH?")
            raise

    def pull(self):
        print("Pulling latest changes from Git repository...")
        self._call_git_command(["pull"])

    def push(self):
        print("Pushing changes to Git repository...")
        self._call_git_command(["push"])

    def commit(self):
        if not self.is_nothing_to_commit():
            timestamp = time.strftime("%H:%M - %d/%m/%y")
            commit_message = f"Automated commit at {timestamp}"
            print(f"Committing changes with message: '{commit_message}'")
            self._call_git_command(["commit", "-am", commit_message])
            self.push()  # Push after successful commit
        else:
            print("Nothing to commit - Skipping push.")

    def is_nothing_to_commit(self):
        """Checks if there are any changes to commit (staged or unstaged in tracked files)."""
        try:
            # Check working tree vs HEAD (unstaged changes to tracked files)
            subprocess.check_call(["git", "diff-index", "--quiet", "HEAD", "--"])
            # Check staged changes vs HEAD
            subprocess.check_call(["git", "diff-index", "--quiet", "--cached", "HEAD", "--"])
            # If both commands succeed (exit code 0), there are no relevant changes.
            return True
        except subprocess.CalledProcessError:
            # A non-zero exit code means there are differences.
            return False
        except Exception as e:
            print(f"Error checking git status: {e}")
            return False # Default to assuming there might be something to commit


def copy_item(src_path, dest_path, is_directory):
    """Copies a file or directory from src_path to dest_path."""
    try:
        dest_parent_dir = os.path.dirname(dest_path)
        if not os.path.exists(dest_parent_dir):
            os.makedirs(dest_parent_dir, exist_ok=True)
            print(f"  Created parent directory for destination: {dest_parent_dir}")

        if is_directory:
            if os.path.exists(dest_path):
                if os.path.isdir(dest_path):
                    print(f"  Removing existing destination directory: {dest_path}")
                    shutil.rmtree(dest_path)
                else:  # Destination exists but is a file
                    print(f"  Removing existing destination file (to be replaced by directory): {dest_path}")
                    os.remove(dest_path)
            
            print(f"  Copying directory: {src_path} -> {dest_path}")
            shutil.copytree(src_path, dest_path, symlinks=False) # symlinks=False copies content
            shutil.copystat(src_path, dest_path) # Preserve metadata of the source directory itself
        else:  # It's a file
            if os.path.exists(dest_path) and os.path.isdir(dest_path):
                # This handles case where dest is a dir but should be a file.
                print(f"  Destination '{dest_path}' is a directory, but source '{src_path}' is a file. Removing directory.")
                shutil.rmtree(dest_path)
            
            print(f"  Copying file: {src_path} -> {dest_path}")
            shutil.copy2(src_path, dest_path)  # Preserves metadata

    except shutil.SameFileError:
        # This should ideally not happen if paths are distinct.
        print(f"  Source and destination are the same file/directory: {src_path}")
    except Exception as e:
        print(f"  Error copying {src_path} to {dest_path}: {e}")
        raise # Re-raise to signal failure in main loop if needed


def main():
    git = Git()
    print("--- Starting dotfile sync ---")
    
    try:
        git.pull()
    except Exception as e:
        print(f"Failed to pull from repository. Please check your connection and Git setup. Error: {e}")
        return # Exit if pull fails

    repo_needs_commit = False

    for item_suffix in dot_items:
        print(f"\n--- Processing: {item_suffix} ---")

        local_path = os.path.join(dot_dir, item_suffix)
        repo_path = os.path.join(git_dir, item_suffix)

        # Ensure parent directory for the item exists in the repo (e.g., .config/ for nvim)
        repo_parent = os.path.dirname(repo_path)
        if repo_parent and not os.path.exists(repo_parent): # Check repo_parent is not empty (for top-level files)
            os.makedirs(repo_parent, exist_ok=True)
            print(f"  Created directory in repo structure: {repo_parent}")
        
        local_exists = os.path.exists(local_path)
        repo_exists = os.path.exists(repo_path)

        # Determine if the item is a directory based on existing paths
        is_item_directory = False
        if local_exists:
            is_item_directory = os.path.isdir(local_path)
        elif repo_exists:
            is_item_directory = os.path.isdir(repo_path)
        else:
            print(f"  Item '{item_suffix}' not found locally ('{local_path}') or in repo ('{repo_path}'). Skipping.")
            continue
        
        try:
            # Scenario 1: Item exists locally, but not in repo (new item to add to repo)
            if local_exists and not repo_exists:
                print(f"  Item '{item_suffix}' found locally but not in repo. Adding to repo.")
                copy_item(local_path, repo_path, is_item_directory)
                repo_needs_commit = True
            
            # Scenario 2: Item exists in repo, but not locally (new item to copy to local system)
            elif repo_exists and not local_exists:
                print(f"  Item '{item_suffix}' found in repo but not locally. Copying to local system.")
                copy_item(repo_path, local_path, is_item_directory)

            # Scenario 3: Item exists in both local system and repo. Compare and sync.
            elif local_exists and repo_exists:
                local_is_dir_type = os.path.isdir(local_path)
                repo_is_dir_type = os.path.isdir(repo_path)

                if local_is_dir_type != repo_is_dir_type:
                    print(f"  ERROR: Type mismatch for '{item_suffix}':")
                    print(f"    Local ('{local_path}') is a {'directory' if local_is_dir_type else 'file'}.")
                    print(f"    Repo ('{repo_path}') is a {'directory' if repo_is_dir_type else 'file'}.")
                    print("  Manual resolution required. Skipping this item.")
                    continue
                
                # Type matches, is_item_directory is correctly set (it was determined from local or repo if one existed)
                is_item_directory = local_is_dir_type 

                # print_mtime_info(local_path) # Uncomment for detailed timestamp debugging
                # print_mtime_info(repo_path)  # Uncomment for detailed timestamp debugging

                # is_newer_than(path1, path2) means path1 is preferred source over path2.
                if is_newer_than(repo_path, local_path): # Repo is "dominant" (newer, same, or slightly older but preferred by buffer)
                    if not are_timestamps_close(repo_path, local_path): 
                        print(f"  Local '{item_suffix}' is outdated by repo. Updating local from repo.")
                        copy_item(repo_path, local_path, is_item_directory)
                    else:
                        print(f"  Local '{item_suffix}' and repo version are effectively identical (or repo preferred). No copy needed.")
                else: # This implies local_path is significantly newer (local_mtime >= repo_mtime + buffer_seconds)
                    # No need to check are_timestamps_close here, as they must be different for this branch to be hit
                    # if the previous `are_timestamps_close` was false. More accurately, local has "won" the `is_newer_than` check.
                    print(f"  Repo '{item_suffix}' is outdated by local. Updating repo from local.")
                    copy_item(local_path, repo_path, is_item_directory)
                    repo_needs_commit = True
            
            # Verification step (optional, good for confirming sync)
            if os.path.exists(local_path) and os.path.exists(repo_path):
                if are_timestamps_close(repo_path, local_path):
                    print(f"  Verification: Timestamps for '{item_suffix}' are close after sync/check.")
                else:
                    print(f"  Verification WARNING: Timestamps for '{item_suffix}' differ after sync/check.")
                    print_mtime_info(local_path)
                    print_mtime_info(repo_path)
            elif local_exists != repo_exists : # One exists, other does not (should have been copied)
                 print(f"  Verification WARNING: Post-copy, one path still missing for '{item_suffix}'.")
                 print(f"    Local exists: {os.path.exists(local_path)}, Repo exists: {os.path.exists(repo_path)}")


        except Exception as e:
            print(f"  An error occurred while processing {item_suffix}: {e}")
            print(f"  Skipping this item due to error.")
            # Decide if you want to continue with other items or stop
            # repo_needs_commit might be true from previous items, consider this.


    if repo_needs_commit:
        print("\n--- Committing changes to repository ---")
        try:
            git.commit() # This also calls push
            print("--- Changes committed and pushed successfully. ---")
        except Exception as e:
            print(f"--- Failed to commit/push changes. Please check Git status manually. Error: {e} ---")
    else:
        print("\n--- No changes made to the repository files. Nothing to commit. ---")

    print("\n--- Dotfile sync finished ---")

if __name__ == "__main__":
    main()
