#!/bin/bash

# Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
# Version:      0.5
#
# DESCRIPTION:
#
# NOTE:



############################ ############################

# Note:
# The shell does not exit if the command that fails is part of the command list immediately following a while or until keyword, part of the test following the if or elif reserved words, part of any command executed in a && or || list except the command following the final && or ||, any command in a pipeline but the last, or if the command's return value is being inverted with !
#
# Set +e' will revert the setting again, so you can have only certain blocks that exit automatically on errors. 

# Any subsequent commands which fail will cause the shell script to exit immediately
#trap 'sys_abort' 0
#set -e

# Ubuntu / Intel Install
#TARGET="Ubuntu"
#HOME="/home/pi"
#ROOT="$HOME/src/rpi-loader"           # directory for where rpi-loader is installed

# Raspbian / Raspberry Pi Install
TARGET="Raspbian"
HOME="/home/pi"
ROOT="$HOME/src/rpi-loader"           # directory for where rpi-loader is installed

source "$ROOT/ansi.sh"
source "$ROOT/functions.sh"

# Test if user is root and abort this script if not
notroottest

TRUE=1
FALSE=0
TMP="/tmp"           # location for temporary files
ANS="dummy-value"    # string will store answers to prompt responses
OPTS=" --yes"        # option parameters used for apt-get command


############################ ############################

messme "\nInstalling tools and configuration parameter for your environment.\n"

# install tools for vim text editor
cd $HOME
git clone https://github.com/jeffskinnerbox/.vim.git
ln -s $HOME/.vim/vimrc $HOME/.vimrc
mkdir $HOME/.vim/backup
mkdir $HOME/.vim/tmp

# install tools for bash shell
cd $HOME
git clone https://github.com/jeffskinnerbox/.bash.git
rm .bashrc .bash_logout
ln -s $HOME/.bash/bashrc $HOME/.bashrc
ln -s $HOME/.bash/bash_login $HOME/.bash_login
ln -s $HOME/.bash/bash_logout $HOME/.bash_logout
ln -s $HOME/.bash/bash_profile $HOME/.bash_profile
ln -s $HOME/.bash/dircolors.old $HOME/.dircolors

# source the resource file so its currently active
source ~/.bashrc

# install X configuration files
cd $HOME
git clone https://github.com/jeffskinnerbox/.X.git
ln -s $HOME/.X/xbindkeysrc $HOME/.xbindkeysrc
ln -s $HOME/.X/Xresources $HOME/.Xresources
ln -s $HOME/.X/xsessionrc $HOME/.xsessionrc

############################ ############################

messme "\nInstalling tools for python virtual environment (i.e. pyenv)"
#messme "You'll need to provide root password when prompted.\n"

# install python virtual env scripts
#pip install virtualenvwrapper

# copy scripts for python virual env
#sudo cp ~/.bash/virtualenvwrapper.sh ~/.bash/virtualenvwrapper_lazy.sh /usr/local/bin

# execute the pyenv installer
curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash

# update your profile / bashrc with this
#export PATH="/home/jeff/.pyenv/bin:$PATH" >> $HOME/.bashrc
#eval "$(pyenv init -)" >> $HOME/.bashrc
#eval "$(pyenv virtualenv-init -)" >> $HOME/.bashrc

# install python 3.6.4 via pyenv
pyenv install 3.6.4

# assure the pyenv shims are updated
pyenv rehash

############################ ############################

messme "\nYour Raspberry Pi is now fully configured. More advanced tools can now be added.\n"

# clean up before exiting
echo -e -n ${NColor}

