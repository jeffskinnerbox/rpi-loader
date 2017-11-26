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
pitest

TRUE=1
FALSE=0
TMP="/tmp"           # location for temporary files
ANS="dummy-value"    # string will store answers to prompt responses
OPTS=" --yes"        # option parameters used for apt-get command


############################ ############################

messme "\nInstalling the latest version of FFmpeg from source.\n"

messme "\nNeed to first remove any old version of FFmpeg. You need to provide password for sudo.\n"
sudo apt-get $OPTS remove ffmpeg

# install dependancies
sudo apt-get $OPTS install yasm nasm

# install ffmpeg source
cd $HOME/src
git clone https://github.com/FFmpeg/FFmpeg.git

messme "\nCreating configuration for FFmpeg Makefile. This takes several minutes.\n"

# create the configuration
cd FFmpeg
./configure

# build ffmpeg
make

# install ffmpeg and all its libraries and tools
messme "\nTo install FFmpeg and all its libraries and tools, you may need to provide password for sudo.\n"
sudo make install

############################ ############################

messme "\nFFmpeg is now installed.\n"

# clean up before exiting
echo -e -n ${NColor}

