# Dotfiles on Ubuntu

Your config files live in one git repo. `stow` symlinks them into `$HOME`, so editing `~/.zshrc` edits the file in the repo.

## Layout

Each top-level folder is a package. Files inside mirror their path under `$HOME`:

```
dotfiles/
  Makefile
  setup.sh
  zsh/.zshrc                       -> ~/.zshrc
  git/.gitconfig                   -> ~/.gitconfig
  git/.config/git/ignore           -> ~/.config/git/ignore
  starship/.config/starship.toml   -> ~/.config/starship.toml
```

## First setup

1. Copy the example folder to `~/dotfiles` and make it your own repo:

```bash
cd ~/dotfiles
git init
git add -A && git commit -m "Initial dotfiles"
```

2. Put your name and email in `git/.gitconfig`.
3. Run `make install`, then log out and back in.
4. Set your terminal font to `JetBrainsMono Nerd Font`.
5. Push the repo to your own GitHub.

If you already have a `~/.zshrc` or `~/.gitconfig`, stow will refuse to overwrite it. Move it away first, or run `make adopt` to pull it into the repo and check with `git diff`.

## What you get

- zsh with oh-my-zsh and the starship prompt
- grey suggestions from history while typing, press `→` to accept
- type the start of a command and press `↑` to cycle through matching history
- `Ctrl+R` fuzzy history search (fzf)
- syntax highlighting: commands turn red if they don't exist
- press `Esc` twice to put `sudo` in front of the current command
- unknown commands suggest which apt package provides them
- `cd`, `ls`, `cat` etc work as normal
- `uv` for Python, `mise` for node and other runtimes, `direnv` for per-project env vars
- `gh`, `jq`, `btop`

Machine-specific settings go in `~/.zshrc.local`, which is not in the repo.

## Daily use

Edit configs in place. Commit and push when you're happy.

New app: make a package folder with the file at its `$HOME` path, e.g. `ghostty/.config/ghostty/config`, then run `make`.

## Another machine

```bash
git clone <your-repo-url> ~/dotfiles && cd ~/dotfiles
make install
```

## Make targets

- `make install` installs tools and links everything
- `make` links again after adding a new file
- `make adopt` pulls existing files in `$HOME` into the repo
- `make unlink` removes all symlinks
