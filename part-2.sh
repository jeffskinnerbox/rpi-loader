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
TMP="/tmp"                   # location for temporary files
ANS="dummy-value"            # string will store answers to prompt responses
TIMEZONE="America/New_York"  # time zone for the raspberry pi

############################ ############################

messme "\nNow running raspi-config tool in non-interactive mode.\n"

# perfrom the raspi-config operations on the command-line normally done via UI tool
# raspi-config nonint do_hostname <hostname>   # modify the host name
raspi-config nonint do_camera 0                # enable camera
raspi-config nonint do_ssh 0                   # enable ssh
raspi-config nonint do_spi 0                   # SPI controller (/dev/spidev0.0 and /dev/spidev0.1) can be enabled
raspi-config nonint do_i2c 0                   # enabling I2C bus /dev/i2c-1
raspi-config nonint do_serial 0                # enable serial console and allows console cables to work
raspi-config nonint do_onewire 0               # enable 1-wire
raspi-config nonint do_expand_rootfs           # expand partition to use 100% of remaining space
raspi-config nonint do_boot_behaviour B1       # require password to get console access

# set the time zone for your raspberry pi device
timedatectl set-timezone $TIMEZONE

############################ ############################

messme "\nThe The Raspberry Pi should be rebooted now.\n"

# clean up before exiting
echo -e -n ${NColor}

