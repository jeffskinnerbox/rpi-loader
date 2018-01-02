#!/bin/bash

# Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
# Version:      0.4
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
#HOME="/home/jeff"
#ROOT="$HOME/src/rpi-loader"           # directory for where rpi-loader is installed

# Raspbian / Raspberry Pi Install
TARGET="Raspbian"
HOME="/home/pi"
ROOT="$HOME/src/rpi-loader"           # directory for where rpi-loader is installed

source "$ROOT/ansi.sh"
source "$ROOT/functions.sh"

# Test if user is pi and abort this script if not
notroottest

TRUE=1
FALSE=0
TMP="/tmp"           # location for temporary files
ANS="dummy-value"    # string will store answers to prompt responses
OPTS=" --yes"        # option parameters used for apt-get command


############################ ############################

messme "\nInstall Dweepy Python Library.\n"


# go to the directory you wish to install ts_dweepy code
cd ~/src

# clone the ts_dweepy github repository
git clone https://github.com/jeffskinnerbox/ts_dweepy.git

# enter the ts_dweepy directory
cd ~/src/ts_dweepy

# build the ts_dweepy python package
sudo python3 setup.py build

# install the package in your local python library
sudo python3 setup.py install

# run the test script to assure the install is correct
# a successful test run give you **no output**
cd tests
python3 test_ts_dweepy.py

# clean up unneeded file and directories
cd ~/src/ts_dweepy
sudo rm -f -r ts_dweepy.egg-info build dist

############################ ############################

messme "\nDweepy is now installed.\n"

# clean up before exiting
echo -e -n ${NColor}

