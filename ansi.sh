#!/bin/bash

# Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
# Version:      0.2
#
# DESCRIPTION:
# Thees ANSI escape sequences set screen attributes, such as bold text,
# and color of foreground and background.
#
# NOTE:



############################ Define Terminal Colors ############################

# Standard Colors
Black='\e[0;30m'              # Black
Red='\e[0;31m'                # Red
Green='\e[0;32m'              # Green
Yellow='\e[0;33m'             # Yellow
Blue='\e[0;34m'               # Blue
Purple='\e[0;35m'             # Purple
Cyan='\e[0;36m'               # Cyan
White='\e[0;37m'              # White

# Bold Colors
BBlack='\e[1;30m'             # Black
BRed='\e[1;31m'               # Red
BGreen='\e[1;32m'             # Green
BYellow='\e[1;33m'            # Yellow
BBlue='\e[1;34m'              # Blue
BPurple='\e[1;35m'            # Purple
BCyan='\e[1;36m'              # Cyan
BWhite='\e[1;37m'             # White

# Underline
UBlack='\e[4;30m'             # Black
URed='\e[4;31m'               # Red
UGreen='\e[4;32m'             # Green
UYellow='\e[4;33m'            # Yellow
UBlue='\e[4;34m'              # Blue
UPurple='\e[4;35m'            # Purple
UCyan='\e[4;36m'              # Cyan
UWhite='\e[4;37m'             # White

# Background Colors
On_Black='\e[40m'             # Black
On_Red='\e[41m'               # Red
On_Green='\e[42m'             # Green
On_Yellow='\e[43m'            # Yellow
On_Blue='\e[44m'              # Blue
On_Purple='\e[45m'            # Purple
On_Cyan='\e[46m'              # Cyan
On_White='\e[47m'             # White

NColor='\e[m'                 # Color Reset

ALERT=${BWhite}${On_Red}      # Major error or abort
CHECK=${BYellow}              # Print information for user validation
PROM=${BGreen}                # Prompt for input
MESS=${BGreen}                # Text message

