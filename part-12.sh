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

# Test if user is root and abort this script if not
roottest

TRUE=1
FALSE=0
TMP="/tmp"           # location for temporary files
ANS="dummy-value"    # string will store answers to prompt responses
OPTS=" --yes"        # option parameters used for apt-get command


############################ ############################

messme "\nBuilding the Jupyter Notebook Environment.\n"

# update your pip utility
pip3 install --upgrade pip

# install jupyter
pip3 install jupyter

############################ ############################

messme "\nInstalling some packages often used with Jupyter Notebook.  This could take over one hour.\n"

# install some of the python packages commonly used in jupyter
pip3 install numpy matplotlib
pip3 install scipy scikit-learn
pip3 install seaborn pandas imutils

############################ ############################

messme "\nJupyter Notebook is now installed.\n"

# clean up before exiting
echo -e -n ${NColor}

