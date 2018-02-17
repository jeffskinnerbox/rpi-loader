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

# make sure you only proceed if your on a Raspberry Pi / Raspbian system
if [ $TARGET != "Raspbian" ]; then
    mess_abort "This script is to be run on Raspberry Pi / Raspbian ONLY!"
fi

############################ ############################

# install firmware update tool
apt-get $OPTS install rpi-update

# check for and install any required Raspberry Pi firmware upgrades
BRANCH=next rpi-update

############################ ############################

messme "\nThe Raspberry Pi should be rebooted now.\n"

# clean up before exiting
echo -e -n ${NColor}

