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

# Ubunutu / Intel Install
#TARGET="Ubunutu"
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

# free up some disk space by remove some packages
if [ $TARGET -eq "Raspbian" ]; then
    messme "\nCreating extra disk space by removing unneeded packages.\n"

    apt-get $OPTS purge wolfram-engine
    apt-get $OPTS purge libreoffice*

    # clean up package environment
    apt-get $OPTS clean
    apt-get $OPTS autoremove
fi

############################ ############################

messme "\nInstall OpenCV Dependencies.\n"

# install dev tool packages you'll need for opencv
apt-get $OPTS install build-essential git cmake pkg-config

# install image processing packages
apt-get $OPTS install libjpeg-dev libtiff5-dev libjasper-dev libpng12-dev

# install video processing packages
apt-get $OPTS install libavutil-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
apt-get $OPTS install libxvidcore-dev libx264-dev

# highgui used to display images to screen and build basic GUIs
apt-get $OPTS install libgtk2.0-dev libgtk-3-dev

# packages for opencv matrix operations
apt-get $OPTS install libatlas-base-dev gfortran

# get python 2.7 and python 3 header files so we can compile opencv with python bindings
apt-get $OPTS install python2.7-dev python3-dev

# to manage software packages for python 3, let’s install pip and virtual env tool
apt-get $OPTS install python3-pip
apt-get $OPTS install python3-venv

# to ensure a robust python programming environment
apt-get $OPTS install build-essential libssl-dev libffi-dev python-dev

# use the ARM specific GTK to prevent GTK warnings
apt-get $OPTS install libcanberra-gtk*

############################ ############################

messme "\nInstall Python package frequently used by OpenCV.\n"

pip3 install imutils

############################ ############################
messme "\nThe In the next script, you will install and compile the OpenCV source code.\n"

# clean up before exiting
echo -e -n ${NColor}

