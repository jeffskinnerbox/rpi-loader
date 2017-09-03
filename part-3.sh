#!/bin/bash

# Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
# Version:      0.1
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
ROOT="/home/jeff/src/rpi-loader"

source "$ROOT/ansi.sh"
source "$ROOT/functions.sh"

TMP="/tmp"
ANS="dummy-value"


############################ ############################

# commandline utility for applications upgrade
apt-get update && apt-get dist-upgrade

# clean up any packages no longer needed
apt-get autoremove

# clean up before exiting
echo -e -n ${NColor}

