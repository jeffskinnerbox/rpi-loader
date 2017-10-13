#!/bin/bash

# Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
# Version:      0.3
#
# DESCRIPTION:
#
# NOTE:



############################ ############################

# directory for where rpi-loader is installed
ROOT="/home/jeff/src/rpi-loader"

source "$ROOT/ansi.sh"
source "$ROOT/functions.sh"

TMP="/tmp"
BOOT="dummy-value"
DATA="dummy-value"
LOCAL="$ROOT/rpi3"
ANS="dummy-value"

############################ ############################

#sed 's/ROOT="\/home\/jeff\/src\/rpi-loader"/ROOT=\/home\/pi\/src\/rpi-loader/' part-1.sh
#sed 's/ROOT="\/home\/jeff\/src\/rpi-loader"/ROOT=\/home\/pi\/src\/rpi-loader/' part-2.sh
sed -i 's/ROOT=\/home\/jeff/ROOT=\/home\/pi/' part-1.sh
