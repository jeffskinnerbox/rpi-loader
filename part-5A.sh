#!/bin/bash

# Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
# Version:      0.3
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

# directory for where rpi-loader is installed
HOME="/home/pi"
ROOT="$HOME/src/rpi-loader"

source "$ROOT/ansi.sh"
source "$ROOT/functions.sh"

# Test if user is root and abort this script if not
roottest

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
cp $HOME/.bash/virtualenvwrapper.sh $HOME/.bash/virtualenvwrapper_lazy.sh /usr/local/bin
pip install virtualenvwrapper

# install X configuration files
cd $HOME
git clone https://github.com/jeffskinnerbox/.X.git
ln -s $HOME/.X/xbindkeysrc $HOME/.xbindkeysrc
ln -s $HOME/.X/Xresources $HOME/.Xresources
ln -s $HOME/.X/xsessionrc $HOME/.xsessionrc

############################ ############################

messme "\nYour Raspberry Pi is now fully configured. More advanced tools can now be added.\n"

# clean up before exiting
echo -e -n ${NColor}

