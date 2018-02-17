<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.5
-->

# Notes
In here are instructions on the creation, maintenance, and use of this repository
via [git][01] and [GitHub][02].  For more information, check out these posts:

* [Using Git and Github to Manage Your Dotfiles](http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/)
* [Managing dot files with Git](http://blog.sanctum.geek.nz/managing-dot-files-with-git/)
* [The most useful git commands](https://orga.cat/posts/most-useful-git-commands)
* [git - the simple guide just a simple guide for getting started with git. no deep shit ;)](http://rogerdudler.github.io/git-guide/)
* [git - the simple guide](http://rogerdudler.github.io/git-guide/)
* [Useful tricks you might not know about Git stash](https://medium.freecodecamp.org/useful-tricks-you-might-not-know-about-git-stash-e8a9490f0a1a)
* [Git Tutorial](http://fab.cba.mit.edu/classes/4.140/doc/git/)
* [What is git?](http://fab.cba.mit.edu/classes/863.16/doc/tutorials/version_control/index.html)
* [The most useful git commands](https://orga.cat/posts/most-useful-git-commands)

## Managing the Git Repository and GitHub

================================================================================
### Creating the GitHub Repository
Goto GitHub and create the new repository

    goto https://github.com/jeffskinnerbox
    <create empty repository called '.bash'>

### Creating the Local Git Repository
Make the .bash directory, move into it, and initialize it as a git repository

    cd ~
    mkdir .bash
    cd .bash
    git init

Now create the README, bash_aliases, bash_logout, bash_profile, and bashrc files.

Also create the file `.gitignore` like this:

```bash
### ---------- Project Specific ---------- ###


### -------------- General --------------- ###

### Compiled Source ###
*.pyc
*.com
*.class
*.dll
*.exe
*.o
*.so

### Packages ###
*.7z
*.dmg
*.gz
*.iso
*.jar
*.rar
*.tar
*.zip

### Videos & Images ###
*.mp4
*.avi
*.webm
*.mkv
*.png
*.jpg
*.tif
*.gif

### Jupyter Files ###
Untitled.ipynb

### Logs & Databases ###
*.log
*.sql
*.sqlite

### OS Generated Files ###
*.out
*.swp
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
Icon?
ehthumbs.db
Thumbs.db
```

Now commit the files to the git repository:

    git add --all
    git commit -m 'Initial creation of Bash scripts for Linux box'

### Update the Remote GitHub Repository for the First Time
Initialize the local directory as a Git repository.
Within the `jupyter-notebooks` directory, use `git` to load the files to GitHub

### Loading the GitHub Repository for the First Time
Within the ~.bash directory, use git to load the files to GitHub

    cd ~/.bash
    git remote add origin https://github.com/jeffskinnerbox/.bash.git
    git push -u origin master

#### Store Credentials Within Git
To add a new remote,
use the `git remote add` command on the terminal,
in the directory your repository is stored at.

    cd ~/jupyter-notebooks

    # set your remote repository URL
    git remote add origin https://github.com/jeffskinnerbox/jupyter-notebooks.git

    # verifies the new remote URL
    git remote -v

    # pushes the changes in your local repository up to the remote repository
    git push -u origin master

>**NOTE**: Other operations
[rename an existing remote](https://help.github.com/articles/renaming-a-remote/),
[delete an existing remote](https://help.github.com/articles/removing-a-remote/).

================================================================================
## Updating a Git Repository

### Updating the Local Git Repository
Within the .vim directory, do a "get status" to see what will be included in the commit,
add files (or remove) that are required, and then do the commit to the local git repository.

    git status
    git add --all
    git commit --dry-run
    git commit -m <comment>

### Retrieving Update From Remote Repository (i.e. GitHub)
To retrieve these updates on another system, use

    git pull origin master

To overwrite everything in the local directory

    git fetch --all
    git reset --hard origin/master

Explanation: `git fetch` downloads the latest from remote without trying to merge or rebase anything.
Then the `git reset` resets the master branch to what you just fetched.
The `--hard` option changes all the files in your working tree to match the files in `origin/master`.
If you have any files that are _not_ tracked by Git,
these files will not be affected.

### Updating the Remote Repository (i.e. GitHub)
To which shows you the URL that Git has stored for the shortname for
the remote repository (i.e. GitHub):

    git remote -v

Now to push your files to the GitHub repository

    git push -u origin master

================================================================================
## Cloning a Git Repository

### Clone This Git Repository
Copy this Git repository into your local systems:

    cd <target-directory>
    git clone http://github.com/jeffskinnerbox/jupyter-notebooks.git

### To Clone .vim Environment on Another Machine
Login into the target machine and go to its $HOME
and clone the Vim environment by execute the following:

    cd ~
    git clone http://github.com/jeffskinnerbox/.vim.git ~/.vim
    ln -s ~/.vim/vimrc ~/.vimrc
    ln -s ~/.vim/gvimrc ~/.gvimrc
    mkdir ~/.vim/backup
    mkdir ~/.vim/tmp
    cd ~/.vim
    git submodule init
    git submodule update

### Retrieving Update From Remote Repository (i.e. GitHub)
To retrieve these updates on another system, use

    git pull origin master

To overwrite everything in the local directory

    git fetch --all
    git reset --hard origin/master

Explanation: `git fetch` downloads the latest from remote without trying to merge or rebase anything.
Then the `git reset` resets the master branch to what you just fetched.
The `--hard` option changes all the files in your working tree to match the files in `origin/master`.
If you have any files that are _not_ tracked by Git,
these files will not be affected.

================================================================================
# References



[01]:http://git-scm.com/
[02]:https://github.com/
[03]:
[04]:
[05]:
