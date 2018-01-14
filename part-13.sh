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

# github branch you wish to compile
BRANCH="master"

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

# source Cross-compiling TensorFlow for the Raspberry Pi - https://petewarden.com/2017/08/20/cross-compiling-tensorflow-for-the-raspberry-pi/

messme "\nBuilding the TensorFlow Environment.\n"

# make sure you have the required development tools
apt-get $OPTS install libblas-dev liblapack-dev python-dev libatlas-base-dev gfortran python-setuptools

# go to a tmp directory, create it if you must
if [ -d "/home/pi/tmp" ]; then
    cd /home/pi/tmp
else
    mkdir /home/pi/tmp
    cd /home/pi/tmp
fi

# for python 3.5.x
# download the python wheel form TensorFlow’s Jenkins continuous integration system
curl -O http://ci.tensorflow.org/view/Nightly/job/nightly-pi-python3/lastSuccessfulBuild/artifact/output-artifacts/tensorflow-1.4.0-cp34-none-any.whl

mv tensorflow-1.4.0-cp34-none-any.whl tensorflow-1.4.0-cp35-none-any.whl

pip install tensorflow-1.4.0-cp35-none-any.whl

# make sure you have the development tools
#apt-get $OPTS install python3-pip python3-dev

# update your pip utility and install python dependencies
#pip3 install --upgrade pip
#pip3 install --upgrade six numpy wheel

## install tensorflow 1.4.1 for python 3.5.x
##pip3 install --upgrade tensorflow
##sudo -H pip3 install --upgrade https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.4.1-cp35-cp35m-linux_x86_64.whl

## install the absolute latest version of tensorflow from github
##pip3 install --upgrade tf-nightly

############################ ############################

messme "\nTensorFlow is now installed.\n"

# clean up before exiting
echo -e -n ${NColor}

