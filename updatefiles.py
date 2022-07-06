# Sources:
# https://stackoverflow.com/a/39501288/4727450 (file modification time)
#
# Info:
# Ensures that local and repo dotfiles are updated
#
# THIS FILE IS DESIGNED FOR MAC OS
# To change to any other OS, modify the paths and user script.


import os
import time
import shutil
import subprocess


dot_files = [".vimrc", ".gitconfig", ".bash_profile", ".zshrc"]
user = os.environ.get("USER")
dot_dir = os.path.join("/Users", user)
# modify git_dir if you want to run this outside the git directory
git_dir = os.path.join(os.getcwd())
os.chdir(git_dir)


def creation_date(f, pretty=False):
    def mod_date(f):
        return time.ctime(os.path.getmtime(f))

    def raw_mod_date(f):
        return os.path.getmtime(f)
    if pretty:
        print("{} was last modified {}".format(f, mod_date(f)))
    return raw_mod_date(f)


def is_newer(f1, f2):
    return creation_date(f1) > creation_date(f2) - 100


def verify_copy(f1, f2):
    c1=creation_date(f1)
    c2=creation_date(f2)
    # creation date returns a timestamp in ms
    # a buffer of +/- 100 is needed to ever return True.
    return c1 - 100 < c2 < c1 + 100


class Git:
    def call(self, fn):
        gitfn="git {fn}".format(fn=fn)
        print("Calling {}".format(gitfn))
        subprocess.call(gitfn, shell=True)

    def pull(self):
        self.call("pull")

    def push(self):
        self.call("push")

    def commit(self):
        if not self.nothing_to_commit():
            timestamp=time.strftime("%H:%M - %d/%m/%y")
            fn=f'commit -am "Automated commit at ${timestamp}"'
            self.call(fn)
            self.push()
        else:
            print("Nothing to commit - Do not push")

    def nothing_to_commit(self):
        st=subprocess.check_output(["git", "status"])
        return "nothing to commit" in str(st)


def cp(_from, _to):
    try:
        print("Copying from {} to {}".format(_from, _to))
        shutil.copy2(_from, _to)
    except shutil.SameFileError as e:
        print("Same file! ({})".format(e))
        print(e)


def main():
    git=Git()
    git.pull()
    files_to_update=False
    for f in dot_files:
        print("Checking {}".format(f))
        repo_file=os.path.join(git_dir, f)
        if not os.path.isfile(repo_file):
            print("Added new file: {}".format(repo_file))
            cp(local_file, repo_file)
        local_file=os.path.join(dot_dir, f)
        local_outdated=is_newer(repo_file, local_file)
        if local_outdated:
            print("Local outdated! Copying from repo to ~/")
            cp(repo_file, local_file)
        else:
            print("Repo outdated! Copying from ~/ to repo")
            files_to_update=True
            cp(local_file, repo_file)
        if verify_copy(repo_file, local_file):
            print("Successfully copied {}".format(f))
    if files_to_update:
        git.commit()


if __name__ == "__main__":
    main()
