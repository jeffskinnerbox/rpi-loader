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
# source: https://www.pyimagesearch.com/2017/05/01/install-dlib-raspberry-pi/
#         https://www.pyimagesearch.com/2017/03/27/how-to-install-dlib/
# http://dlib.net/
# Install Dlib on Ubuntu - https://www.learnopencv.com/install-dlib-on-ubuntu/

messme "\nInstalling dlib with Python bindings.\n"

messme "\nFirst we will install the prerequisite Linux and Python packages.\n"

# prerequisite linux packages
apt-get $OPTS install build-essential cmake
apt-get $OPTS install libgtk-3-dev
apt-get $OPTS install libboost-all-dev

# prerequisite python packages
pip3 install numpy scipy scikit-image

messme "\nNext installing dlib. This could take several hours.\n"

# download the dlib package from PyPI, automatically configure it via CMake,
# and then compile and install it
pip3 install dlib

############################ ############################

messme "\ndlib C libraries and it's Python bindings is now installed.\n"

# clean up before exiting
echo -e -n ${NColor}

