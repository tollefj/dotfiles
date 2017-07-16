# Sources:
# https://stackoverflow.com/a/39501288/4727450
#
# Info:
# Makes sure that local and repo dotfiles are updated
#
# THIS FILE IS DESIGNED FOR MAC OS
# To change to any other OS, modify the paths and user script.


import os
import time
import shutil
import subprocess


dot_files = ['.vimrc', '.gitconfig', '.bash_profile']
user = os.environ.get('USER')
dot_dir = os.path.join('/Users', user)
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
    return creation_date(f1) > creation_date(f2)-100


def verify_copy(f1, f2):
    c1 = creation_date(f1)
    c2 = creation_date(f2)
    return c1 - 100 < c2 < c1 + 100


class Git:
    def call(self, fn):
        print('Calling git '+fn)
        subprocess.call('git '+fn, shell=True)

    def pull(self):
        self.call('pull')

    def push(self):
        self.call('push')

    def commit(self):
        if not self.nothing_to_commit():
            timestamp = time.strftime('%H:%M - %d/%m/%y')
            fn = 'commit -am "Automated commit at '+timestamp+'"'
            self.call(fn)
            self.push()
        else:
            print('Nothing to commit - Do not push')

    def nothing_to_commit(self):
        st = subprocess.check_output(['git', 'status'])
        return 'nothing to commit' in str(st)


def main():
    git = Git()
    git.pull()
    files_updated_in_repo = False
    for f in dot_files:
        print('Checking ' + f)
        repo_file = os.path.join(git_dir, f)
        local_file = os.path.join(dot_dir, f)
        local_outdated = is_newer(repo_file, local_file)
        if local_outdated:
            print('Local outdated! Copying from repo to ~/')
            shutil.copy2(repo_file, local_file)
        else:
            print('Repo outdated! Copying from ~/ to repo')
            files_updated_in_repo = True
            shutil.copy2(local_file, repo_file)
        if verify_copy(repo_file, local_file):
            print('Successfully copied ' + f)
    if files_updated_in_repo:
        git.commit()


if __name__ == '__main__':
    main()
