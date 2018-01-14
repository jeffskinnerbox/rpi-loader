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
#HOME="/home/pi"
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

messme "\nInstall LiFePO4wered/Pi3 UPS/Power Monitor Software.\n"

# clone software package
cd ~/src
git clone https://github.com/xorbit/LiFePO4wered-Pi.git

# build the software
cd LiFePO4wered-Pi
python build.py

# install the software
# this also performs enablement of I2C bus and GPIO UART
sudo ./INSTALL.sh

messme "\nAt this time, the blinking LiFePO4wered/Pi3 PWR LED should now go on solid."
messme "If not, a reboot is required.\n"

############################ ############################

messme "\nLiFePO4wered/Pi3 software installation completed.\n"

# clean up before exiting
echo -e -n ${NColor}

