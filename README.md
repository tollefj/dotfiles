# dotfiles

stow symlinks for dotfiles.

- top-level folders are stow packages
- each file inside it lives at the same relative path under `$HOME` and is symlinked


## Editing 

edit it in `$HOME` or in the repo. same file.

## Adding a new file to an existing package

write it directly into the repo at its `$HOME`-relative path, e.g.
`nvim/.config/nvim/newfile.lua`, then run:

    make update

## A file already exists in `$HOME` and isn't in the repo yet

Common when an app writes its own config on first run.
Adopt the real file into the repo:

    make new NAME=<package> FILE=<path-relative-to-$HOME>

e.g. `make new NAME=nvim FILE=.config/nvim/README.md`. This moves the real
content into the repo and leaves a symlink behind in `$HOME`.

## New application, no package folder yet

    make new NAME=alacritty FILE=.config/alacritty/alacritty.toml

If there's nothing in `$HOME` yet, and you'd rather author the config
from scratch, create it directly under a new top-level folder, e.g.
`alacritty/.config/alacritty/alacritty.toml`, and run `make update`

## Finding files you forgot to stow

    make candidates

Lists `$HOME` files/dirs not managed by any package.
Manual override incandidates-ignore`.

## First time on a new machine

    make claim

Repo is the master here.
Walks every package, and for any real file already sitting in `$HOME` (e.g. a default `~/.zshrc` your shell created before you cloned this repo), shows a diff and asks before overwriting it with the repo's version. Declined files are left alone and reported; everything else gets linked.

If you'd rather go the other way (keep what's already in `$HOME` and pull
it into the repo instead):

    make adopt

## Removing all symlinks

    make unlink
