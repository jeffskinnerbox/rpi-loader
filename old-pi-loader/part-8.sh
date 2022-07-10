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

# Test if user is not root and abort this script if it is
notroottest

TRUE=1
FALSE=0
TMP="/tmp"           # location for temporary files
ANS="dummy-value"    # string will store answers to prompt responses
OPTS=" --yes"        # option parameters used for apt-get command
OPENCV="3.4.0"       # opencv version to be installed


############################ ############################

messme "\nInstall OpenCV Source Code.\n"

# move to the direct where opencv will be installed
cd ~/src

# download and install opencv
wget -O opencv.zip https://github.com/opencv/opencv/archive/$OPENCV.zip
unzip opencv.zip

# download and install opencv_contrib
wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/$OPENCV.zip
unzip opencv_contrib.zip

# remove zip files
rm opencv.zip opencv_contrib.zip

############################ ############################

messme "\nCreate the Makefile for building OpenCV.\n"

# enter the directoy where opencv will be built
cd ~/src/opencv-$OPENCV
mkdir build
cd build

# create the makefile for the build
#cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D INSTALL_PYTHON_EXAMPLES=ON -D OPENCV_EXTRA_MODULES_PATH=~/src/opencv_contrib-$OPENCV/modules -D BUILD_EXAMPLES=ON ..
cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D OPENCV_EXTRA_MODULES_PATH=~/src/opencv_contrib-$OPENCV/modules \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D ENABLE_NEON=ON \
    -D ENABLE_VFPV3=ON \
    -D BUILD_TESTS=ON \
    -D BUILD_EXAMPLES=ON ..

############################ ############################

messme "\nExecute the Makefile.  Warning ... this will take a long time.\n"

# execute the make file
# note: if you have a compiler error, do "make clean" and then just "make"
if [ $TARGET -eq "Ubuntu" ]; then
    make -j4        # if you hang, your out of memory; run again without the "-j4"
else
    make
fi

############################ ############################

messme "\nBuild had has compled.  Now doing the install.\n"

# install opencv executables and libraries
sudo make install

# creates the necessary links and cache to the most recent shared libraries
sudo ldconfig

############################ ############################

messme "\nYour next step is to manually install OpenCV in its target locations.\n"

# clean up before exiting
echo -e -n ${NColor}

