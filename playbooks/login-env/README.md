<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.0.1
-->


<div align="center">
<img src="http://www.foxbyrd.com/wp-content/uploads/2018/02/file-4.jpg" title="These materials require additional work and are not ready for general use." align="center">
</div>


----


# Login Environment Playbook

As the `pi` user do the following

```bash
# setup your bash environment
cd ~
rm ~/.bashrc ~/.bash_logout
git clone https://github.com/jeffskinnerbox/.bash.git ~/.bash
ln -s ~/.bash/inputrc ~/.inputrc
ln -s ~/.bash/bashrc ~/.bashrc
ln -s ~/.bash/bash_login ~/.bash_login
ln -s ~/.bash/bash_logout ~/.bash_logout
ln -s ~/.bash/bash_profile ~/.bash_profile
ln -s ~/.bash/dircolors.old ~/.dircolors

# source/load the changes into your profile
source ~/.bashrc

# setup your vim environment
cd ~
git clone http://github.com/jeffskinnerbox/.vim.git ~/.vim
ln -s ~/.vim/vimrc ~/.vimrc
mkdir ~/.vim/backup
mkdir ~/.vim/tmp
cd ~/.vim
git submodule init
git submodule update

# setup your x windows environment
cd ~
git clone http://github.com/jeffskinnerbox/.X.git ~/.X
ln -s ~/.X/xbindkeysrc ~/.xbindkeysrc
ln -s ~/.X/Xresources ~/.Xresources
ln -s ~/.X/xsessionrc ~/.xsessionrc

# rebuilding $HOME/.Xauthority to avoid MIT magic cookie error
cd ~
touch ~/.Xauthority
xauth generate :0 . trusted
xauth add ${HOST}:0 . `xxd -l 16 -p /dev/urandom`
```
