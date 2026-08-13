# dotfiles

GNU stow symlink farm. Every top-level folder is a stow package; each file
inside it lives at the same relative path under `$HOME` and is symlinked in
by stow. Editing a stowed file in `$HOME` edits the repo file directly.

## Editing an existing file

Just edit it, in `$HOME` or in the repo - it's the same file. No `make`
target needed.

## Adding a new file to an existing package

If you're creating the file yourself (not something an app generated),
write it directly into the repo at its `$HOME`-relative path, e.g.
`nvim/.config/nvim/newfile.lua`, then run:

    make update

This checks every package for drift against `$HOME` and restows only the
packages that changed.

## A file already exists in `$HOME` and isn't in the repo yet

Common when an app writes its own config on first run, or you edited
something before thinking about dotfiles. `make update` can't help here -
it only looks at files the repo already has. Adopt the real file into the
repo instead:

    make new NAME=<package> FILE=<path-relative-to-$HOME>

e.g. `make new NAME=nvim FILE=.config/nvim/README.md`. This moves the real
content into the repo and leaves a symlink behind in `$HOME`.

## Brand new application, no package folder yet

Same command - `NAME` doesn't need to already exist, it scaffolds the
package directory before adopting:

    make new NAME=alacritty FILE=.config/alacritty/alacritty.toml

Or, if there's nothing in `$HOME` yet and you'd rather author the config
from scratch, create it directly under a new top-level folder, e.g.
`alacritty/.config/alacritty/alacritty.toml`, and run `make update` - new
top-level folders are picked up as packages automatically.

## Finding files you forgot to stow

    make candidates

Lists `$HOME` files/dirs not managed by any package. Tune noise in
`.candidates-ignore`.

## First time on a new machine

    make claim

Repo wins. Walks every package, and for any real file already sitting in
`$HOME` (e.g. a default `~/.zshrc` your shell created before you cloned
this repo), shows a diff and asks before overwriting it with the repo's
version. Declined files are left alone and reported; everything else gets
linked.

If you'd rather go the other way - keep what's already in `$HOME` and pull
it into the repo instead - use:

    make adopt

No prompts: it absorbs whatever's in `$HOME` into the repo in bulk (device
wins), then links everything. Riskier, since it can silently overwrite
tracked repo content with whatever happens to be on disk.

## Removing all symlinks

    make unlink
