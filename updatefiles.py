# Copy .vimrc, .gitconfig and .bash_profile
# Paste them in their proper ~/ dir
# Also load from ~/ when needed
# Use os.path.getmtime(path) to compare
# https://stackoverflow.com/a/39501288/4727450

import os
import time
import shutil

dot_files = ['.vimrc', '.gitconfig', '.bash_profile']
dot_dir = os.path.join('/Users', 'tollef')
git_dir = os.getcwd()


def creation_date(f, pretty=False):
    def mod_date(f):
        return time.ctime(os.path.getmtime(f))

    def raw_mod_date(f):
        return os.path.getmtime(f)
    if pretty:
        print(f + ' was last modified: ' + mod_date(f))
    return raw_mod_date(f)


def is_newer(f1, f2):
    return creation_date(f1) > creation_date(f2)


def verify_copy(f1, f2):
    c1 = creation_date(f1)
    c2 = creation_date(f2)
    return c1 - 100 < c2 < c1 + 100


def main():
    for f in dot_files:
        print('Checking ' + f)
        repo_file = os.path.join(git_dir, f)
        local_file = os.path.join(dot_dir, f)
        local_outdated = is_newer(repo_file, local_file)
        print()
        if local_outdated:
            print('Local file outdated! Copy from git repo to ~/')
            shutil.copy2(repo_file, local_file)
        else:
            print('Repo file outdated! Copy files from ~/ to repo')
            shutil.copy2(local_file, repo_file)
        if verify_copy(repo_file, local_file):
            print('Successfully copied ' + f)


if __name__ == '__main__':
    main()
