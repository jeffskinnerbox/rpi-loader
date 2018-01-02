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
roottest

TRUE=1
FALSE=0
TMP="/tmp"           # location for temporary files
ANS="dummy-value"    # string will store answers to prompt responses
OPTS=" --yes"        # option parameters used for apt-get command


############################ ############################

messme "\nInstalling Python development tools.\n"

# package management tools
apt-get $OPTS install software-properties-common

# first install Python packages
apt-get $OPTS install python python-dev libjpeg-dev libfreetype6-dev python-setuptools python-pip
pip install virtualenv virtualenvwrapper

# update the Python distribution
easy_install -U distribute

# install the RPi GPIO and other packages via pip
pip install RPi.GPIO pySerial nose cmd2

############################ ############################

messme "\nInstalling Java development tools.\n"

# Java
apt-get $OPTS install ant default-jdk

############################ ############################

messme "\nInstalling development tools and other utilities.\n"

# some X Window utilities
apt-get $OPTS install x11-apps x11-xserver-utils xterm wmctrl

# other handy tools
apt-get $OPTS install sendmail gnome-terminal jq

# secure hash algorithms (SHA) tools, specifically SHA256
apt-get $OPTS install hashalot

# general development tools
apt-get $OPTS install markdown git vim vim-gtk libcanberra-gtk-module libcanberra-gtk3-module
apt-get $OPTS install microcom screen
apt-get $OPTS install build-essential i2c-tools libssl-dev

############################ ############################

messme "\nInstalling tools to view and manipulate images and video.\n"

# tools for viewing and manipulating image & video files
apt-get $OPTS install imagemagick feh mplayer2

# scikit-image is a collection of algorithms for image processing
pip install scikit-image

# tools to displays technical information about media files
apt-get $OPTS install mediainfo

############################ ############################

messme "\nInstalling system monitoring, networking tools, and other utilities.\n"

# display statistics about your cpu, i/o, network file system, etc.
apt-get $OPTS install sysstat

# so you can discover hosts via Multicast Domain Name System (mDNS)
apt-get $OPTS install avahi-daemon

# basic networking / firewall tools
apt-get $OPTS install dnsutils tcpdump wavemon nicstat nmap ufw rfkill netcat

# network performance testing & monitoring
apt-get $OPTS install iperf nethogs
pip3 install speedtest-cli

# set to multi-user mode and don't use graphic user interface
systemctl set-default multi-user.target

############################ ############################

messme "\nInstalling web browser utilities.\n"

# install the midori and links2 browser
apt-get $OPTS install midori links2

############################ ############################

messme "\nEstablish your Node.js tools and environment.\n"

# first you need to modify your .bashrc file since you copied it from github
sed --in-place 's/\/home\/jeff\/.nvm/\/home\/pi\/.nvm/' $HOME/.bashrc
source $HOME/.bashrc

#install or update the node version manager (nvm), do the following
# https://github.com/creationix/nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# install the latest stable version of node and make it the default version
nvm install 6.11.1

# install the latest version of npm
npm install npm@latest --global

# node development tools
npm install jshint --global

############################ ############################

messme "\nYou can continue the install by using the next script.\n"

# clean up before exiting
echo -e -n ${NColor}

