# New machine setup

```bash
brew install stow
git clone <dotfiles-url> ~/git/dotfiles
cd ~/git/dotfiles
make adopt          # absorbs existing ~ configs into the repo, then symlinks
git diff            # review where this machine differed
                    #   keep = commit it · prefer repo = git checkout -- <file>
git add -A && git commit -m "Reconcile machine config" && git push
```

Self-managed repos clone separately to their real path, e.g.:

```bash
git clone git@github.com:tollefj/.claude.git ~/.claude
```

## After setup

- Edit configs directly — they're symlinks into the repo, changes are live.
- Mirror: `git add -A && git commit && git push`, then `git pull` elsewhere.
- `make` only after adding a **new** file. `make unlink` removes all symlinks.
