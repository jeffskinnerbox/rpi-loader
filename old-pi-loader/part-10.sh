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

# Test if user is NOT root and abort this script if they are
notroottest

TRUE=1
FALSE=0
TMP="/tmp"           # location for temporary files
ANS="dummy-value"    # string will store answers to prompt responses
OPTS=" --yes"        # option parameters used for apt-get command


############################ ############################

messme "\nInstalling GStreamer 1.0 and all of its plugins.\n"

# install gstreamer
sudo apt-get $OPTS install libgstreamer1.0-0 gstreamer1.0-libav gstreamer1.0-doc gstreamer1.0-tools
sudo apt-get $OPTS install gstreamer1.0-plugins-*
sudo apt-get $OPTS install gstreamer0.10-plugins-*

############################ ############################

messme "\nInstalling the latest version of FFmpeg from source.\n"

messme "\nNeed to first remove any old version of FFmpeg. You need to provide password for sudo.\n"
sudo apt-get $OPTS remove ffmpeg
# see https://gist.github.com/yjxiong/d716c857258f0295b58d148fbf8c489d
echo "Removing any pre-installed ffmpeg and x264"
sudo apt-get -qq remove ffmpeg x264 libx264-dev

# install dependancies
sudo apt-get $OPTS install yasm nasm
# see https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu
sudo apt-get $OPTS install autoconf automake build-essential cmake git libass-dev libfreetype6-dev libsdl2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev mercurial pkg-config texinfo wget zlib1g-dev
# see https://github.com/opencv/opencv/issues/5088
sudo apt-get $OPTS install libsdl2-dev
# see https://stackoverflow.com/questions/41670584/opencv-linux-how-to-install-ffmpeg
sudo apt-get $OPTS install *libavformat-dev libavcodec-dev libswscale-dev libavresample-dev

# install ffmpeg source
cd $HOME/src
git clone https://github.com/FFmpeg/FFmpeg.git

messme "\nCreating configuration for FFmpeg Makefile. This takes several minutes.\n"

# create the configuration
cd FFmpeg
./configure

messme "\nBuilding FFmpeg with Makefile. This takes several minutes.\n"

# build ffmpeg
make

# install ffmpeg and all its libraries and tools
messme "\nInstalling FFmpeg and all its libraries and tools, you may need to provide password for sudo.\n"
sudo make install

############################ ############################

messme "\nGStreamer and FFmpeg are now installed.\n"

# clean up before exiting
echo -e -n ${NColor}

