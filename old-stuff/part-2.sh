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
TARGET="Ubuntu"
HOME="/home/jeff"
ROOT="$HOME/src/rpi-loader"           # directory for where rpi-loader is installed

source "$ROOT/ansi.sh"
source "$ROOT/functions.sh"

# Test if user is root and abort this script if not
roottest

TRUE=1
FALSE=0
TMP="/tmp"           # location for temporary files
ANS="dummy-value"    # string will store answers to prompt responses
BOOT="dummy-value"   # string will store path to device file and filesystem for boot partition
DATA="dummy-value"   # string will store path to device file and filesystem for data partition


############################ ############################

# make sure you only proceed if your on a Raspberry Pi / Raspbian system
if [ $TARGET == "Raspbian" ]; then
    mess_abort "This script is not to be run on the Raspberry Pi / Raspbian!"
fi

############################ ############################

# Ask if the SD-Card is mounted and abort if it is
askme "Have you already installed the SD-Card reader into the USB port?"
if [ $? -eq $FALSE ]; then
    user_abort "Unmount & remove the SD-Card and then start this script again."
else
    df -h > $TMP/filesystem-before
fi

# Ask to mount SD-Card and then parse information you need
askme "\nPlug in the SD-Card reader. Make sure to wait for windows to pop-up.\nAfter windows appear then enter yes, or no to abort."
if [ $? -eq $FALSE ]; then
    df -h > $TMP/filesystem-after
    diff $TMP/filesystem-before $TMP/filesystem-after | grep -e ">" | grep media | awk '{ print $2, $7 }' > $TMP/filesystem-diff
    BOOT=$( awk '{ print $2 }' $TMP/filesystem-diff | grep boot )
    DATA=$( awk '{ print $2 }' $TMP/filesystem-diff | grep -v boot )
else
    user_abort
fi

# data check
check_info "BOOT = $BOOT\nDATA = $DATA"
askme "Does this look correct?"
if [ $? -eq $TRUE ]; then
    user_abort
fi

############################ ############################

# Create the network interfaces and WPA Supplicant file
cat $ROOT/rpi3/interfaces > $DATA/etc/network/interfaces
cat $ROOT/rpi3/wpa_supplicant.conf > $DATA/etc/wpa_supplicant/wpa_supplicant.conf

# Update the WPA Supplicant file with information about your home WiFi
promptme "What is your home WiFi SSID?"
sed -i 's/<home-ssid>/'$ANS'/' $DATA/etc/wpa_supplicant/wpa_supplicant.conf
promptme "What is your home WiFi Password?"
sed -i 's/<home-password>/'$ANS'/' $DATA/etc/wpa_supplicant/wpa_supplicant.conf

# Update the WPA Supplicant file with information about your jetpack WiFi
promptme "What is your jetpack WiFi SSID?"
sed -i 's/<jetpack-ssid>/'$ANS'/' $DATA/etc/wpa_supplicant/wpa_supplicant.conf
promptme "What is your jetpack WiFi Password?"
sed -i 's/<jetpack-password>/'$ANS'/' $DATA/etc/wpa_supplicant/wpa_supplicant.conf

############################ ############################

# Setting the hostname for the Raspberry Pi
promptme "What is your host name?"
sed -i 's/raspberrypi/'$ANS'/' $DATA/etc/hosts
sed -i 's/raspberrypi/'$ANS'/' $DATA/etc/hostname

# SSH can be enabled by placing a file named "ssh", without any extension,
# onto the boot partition of the SD card.
touch $BOOT/ssh
messme "SSH enabled for first boot only."

############################ ############################

umount $( awk '{ print $1 }' $TMP/filesystem-diff | awk 'NR%2{printf "%s ",$0;next;}1' )
messme "The SD-Card is now unmounted and you can remove it."

# clean up before exiting
echo -e -n ${NColor}

