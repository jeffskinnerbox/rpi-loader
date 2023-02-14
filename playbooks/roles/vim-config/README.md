<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      1.2.0
-->

----

Is it time to move off of Pathogen to use vim's native plugin manager or some other plug manager?
Tim Pope says you should - https://github.com/tpope/vim-pathogen

* [How to use Tim Pope’s Pathogen](https://gist.github.com/romainl/9970697)
* [Vim: So long Pathogen, hello native package loading](https://shapeshed.com/vim-packages/)
* [Installing plugins using packages](http://vimcasts.org/episodes/packages/)

* [Learning Vim in 2014: Getting More from Vim with Plugins](https://benmccormick.org/2014/07/21/learning-vim-in-2014-getting-more-from-vim-with-plugins)
* [Vim-plug: A Minimalist Vim Plugin Manager](https://www.ostechnix.com/vim-plug-a-minimalist-vim-plugin-manager/)

Is it time to add some more features to your vim resource file?
Consider the following:

* [Top five Vim plugins for sysadmins](https://www.redhat.com/sysadmin/five-vim-plugins)
* [Use Vim macros to automate frequent tasks](https://www.redhat.com/sysadmin/use-vim-macros)

----

# Notes
In here are instructions on the creation, maintenance, and use of this repository
via [git][01] and [GitHub][02].  For more information, check out these posts:

* [Using Git and Github to Manage Your Dotfiles][03]
* [Managing dot files with Git][04]

----

Using Vim's scripting language (and a great deal of insight and tools from others),
I have setup Vim on my local machine to be an effective development environment
for my needs.  Using GitHub, I can replicate this Vim environment across the
multiple systems I'm presently use.

I will explain here how I established the git environment on my local machine,
how I established a GitHub for that environment, how to replicate the Vim environment
to another machine, and how to update both the local git repository and GitHub.

### Creating Your Local Git Repository
Copy existing Pathogen Git repository into your local systems `$Home/.vim` directory.

    mkdir -p ~/.vim/autoload ~/.vim/bundle
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

If you have existing `.vimrc` and `.gvimrc` files, move them into the `.vim` directory
and establish symbolic links to them like this:

    mv .vimrc ~/.vim/vimrc
    mv .gvimrc ~/.vim/gvimrc
    ln -s ~/.vim/vimrc ~/.vimrc
    ln -s ~/.vim/gvimrc ~/.vimrc
    mkdir ~/.vim/backup
    mkdir ~/.vim/tmp

Change to the .vim directory, and initialize it as a git repository

    cd ~/.vim
    git init

Create a README.md file, add all the files, and make initial comment

    <make a README file>
    git add .
    git commit -m 'Initial commit'

### Adding a Submodule to Git Repository
Git allows you to include other Git repositories called submodules into a repository.
Submodules are Git repositories nested inside a parent Git repository
at a specific path in the parent repository’s working directory.
A submodule can be located anywhere in a parent Git repository’s working directory
and is configured via a `.gitmodules` file located at the root of the parent repository.
This file contains which paths are submodules and what URL
should be used when cloning and fetching for that submodule.
Submodule support includes support for adding, updating, synchronizing, and cloning submodules.

* https://www.vogella.com/tutorials/GitSubmodules/article.html
* https://chrisjean.com/git-submodules-adding-using-removing-and-updating/


### Adding a Submodule to Git Repository
Your going to want to keep your `.vimrc` and Pathogen plugins synchronized
accross machines using git submodules.
I choose (or should I say I was directed by [Tim Pope's README file][05])
to copy directly the `pathogen.vim` file into my repository; not to `git clone`, like this:

    mkdir -p ~/.vim/autoload ~/.vim/bundle
    curl -LSso ~/.vim/autoload/pathogen.vim https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim

But you want to do this differently for the plugin into your repository.
You don't do a copy, as above, or standard `git clone` but instead a `git submodule add`.

```bash
cd ~/.vim
git submodule add https://github.com/pearofducks/ansible-vim.git bundle/ansible-vim
git submodule add https://github.com/smancill/conky-syntax.vim.git bundle/conky-syntax.vim
git submodule add https://github.com/redguardtoo/evil-matchit.git bundle/matchit
git submodule add https://github.com/preservim/nerdcommenter.git bundle/nerdcommenter
git submodule add https://github.com/preservim/nerdtree.git bundle/nerdtree
git submodule add https://github.com/python-mode/python-mode.git bundle/python-mode
git submodule add https://github.com/vim-scripts/ScrollColors.git bundle/ScrollColors
git submodule add https://github.com/ervandew/supertab.git bundle/supertab
git submodule add https://github.com/sudar/vim-arduino-syntax.git bundle/vim-arduino-syntax
git submodule add https://github.com/preservim/vim-markdown.git bundle/vim-markdown
git submodule add https://github.com/sirtaj/vim-openscad.git bundle/vim-openscad
```

### Creating the GitHub Repository
Goto GitHub and create the new repository

    goto https://github.com/jeffskinnerbox
    <create empty repository called '.vim'>

### Loading the GitHub Repository for the First Time
Within the ~.vim directory, use git to load the files to GitHub

    git remote add origin https://github.com/jeffskinnerbox/.vim.git
    git push -u origin master

### To Update the Local Git Repository
Within the .vim directory, do a "get status" to see what will be included in the commit,
add files (or remove) that are required, and then do the commit to the local git repository.

    git status
    git add --all
    git commit --dry-run
    git commit -m <comment>

### To Update the Remote (i.e. GitHub) Repository
To which shows you the URL that Git has stored for the shortname to for
the remote (GitHub) repository:

    git remote -v

Now to push your files to the GitHub repository

    git push -u origin master

### To Clone .vim Environment on Another Machine
Login into the target machine and go to its $HOME
and clone the Vim environment by execute the following:

    cd ~
    git clone http://github.com/jeffskinnerbox/.vim.git
    ln -s ~/.vim/vimrc ~/.vimrc
    ln -s ~/.vim/gvimrc ~/.gvimrc
    mkdir ~/.vim/backup
    mkdir ~/.vim/tmp
    cd ~/.vim
    git submodule init
    git submodule update

### Upgrading Your .vim Directory From Remote GitHub Repository

    cd ~/.vim
    ?????????? git pull origin master ???????????

### To Upgrading a Plugin in bundle Directory
At some point in the future, a plugin might be updated. If this plugin
also uses Git, you can fetch the latest changes via

    cd ~/.vim/bundle/<plugin>
    git pull origin master

To upgrading all bundled plugins

    git submodule foreach git pull origin master

----

### Testing Terminal Colors
Both of those scripts
`256colors.pl`, `colortest.pl`
will test for the terminal’s 256 color capabilities.
In other words, they both tell your terminal to turn on 256 colors for the test.
Essentially that means that xterm was compiled or installed properly
on your operating system with the 256 color configuration options.
However, that does not mean that your terminal is running at 256 colors all the time.
Xterm 256 color capabilities might be installed,
but they are not always enabled by default.
This is why if you try to run a 256 color scheme in vim via the `set t_Co=256` setting
in your .vimrc file.
If you want your terminal to always have 256 color support enabled by default,
then put `export TERM="xterm-256color"` in your `.bashrc` file.

Also, the `.vimrc` file also has tester function to validate if Vim
can infact support 256 colors.
See the function called `VimColorTest`.



[01]:http://git-scm.com/
[02]:https://github.com/
[03]:http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/
[04]:http://blog.sanctum.geek.nz/managing-dot-files-with-git/
[05]:https://github.com/tpope/vim-pathogen
