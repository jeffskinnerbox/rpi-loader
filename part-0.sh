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
pitest

TRUE=1
FALSE=0
TMP="/tmp"           # location for temporary files
ANS="dummy-value"    # string will store answers to prompt responses
BOOT="dummy-value"   # string will store path to device file and filesystem for boot partition
DATA="dummy-value"   # string will store path to device file and filesystem for data partition
IMAGE="dummy-value"  # string will store path to raspbian image

############################ ############################

# Ask if the SD-Card is mounted and abort if it is
askme "Have you already installed the SD-Card reader into the USB port?"
if [ $? -eq $FALSE ]; then
    user_abort "Unmount & remove the SD-Card and then start this script again."
else
    df -h > $TMP/filesystem-before
fi

# Ask to mount SD-Card and then parse information you need
askme "Plug in the SD-Card reader. Make sure to wait for windows to pop-up.\nAfter windows appear then enter yes, or no to abort."
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

# Get the name path to the image and validate it
promptme "What is the full path to the Raspbian image you wish to install?"
IMAGE=$ANS
if [ -e $IMAGE ]; then
    messme "$IMAGE does exit."
else
    mess_abort "The file \"$IMAGE\" ... DOES NOT EXIT."
    sys_abort
fi

# go to directory with the RPi image
#cd /home/jeff/Downloads/Raspbian

# unmount the sd card reader
messme "Unmounting the SD Card."
#sudo umount $BOOT
sudo umount $DATA

# write the image to the sd card reader
messme "Now writing Raspbian image to SD Card."
sudo dd bs=4M if=$IMAGE of=/dev/sdj

# ensure the write cache is flushed
sudo sync

# check the integrity of the sd card image
messme "Now check to make sure Raspbian and SD Card images are the same."
sudo dd bs=4M if=/dev/sdj of=$TMP/copy-from-sd-card.img
sudo truncate --reference $IMAGE $TMP/copy-from-sd-card.img
diff -s $IMAGE $TMP/copy-from-sd-card.img

# unmount the sd card reader
sudo umount /dev/sdj

############################ ############################

umount $( awk '{ print $1 }' $TMP/filesystem-diff | awk 'NR%2{printf "%s ",$0;next;}1' )
messme "The SD-Card is now unmounted and you can remove it."

# clean up before exiting
rm $TMP/filesystem-before $TMP/filesystem-after $TMP/filesystem-diff $TMP/copy-from-sd-card.img
echo -e -n ${NColor}

