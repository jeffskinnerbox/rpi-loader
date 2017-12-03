#!/bin/bash

# Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
# Version:      0.4
#
# DESCRIPTION:
#
# NOTE:



############################ ############################

# directory for where rpi-loader is installed
LHOME="\/home\/jeff"      # local system home directory
RHOME="\/home\/pi"        # raspberry pi home directory

TRUE=1
FALSE=0
ANS="dummy-value"          # string will store answers to prompt responses
BGreen='\e[1;32m'          # Bold Green
NColor='\e[m'              # Color Reset
PROM=${BGreen}             # Prompt for input
MESS=${BGreen}             # Text message

############################ ############################

# Print a line of text (i.e. a question) and then ask for yes or no responses
function askme {
    while true; do
        echo -n -e "${PROM}$@ [ yes/no ] ${NColor}" ; read ANS
        case "$ANS" in
            yes|Yes|YES) return $TRUE ;;
            no|No|NO) return $FALSE ;;
        esac
    done
}

# Print a line of text as a message
function messme {
    echo -e "${MESS}$@${NColor}"
}

############################ ############################

messme "\nThis script will make some minor edits to prepare rpi-loader for use."
messme "It assumes your \$HOME directories are \"/home/jeff\" and \"/home/pi\"."
messme "Also it assumes the rpi-loader scripts are located at \"\$HOME/src/rpi-loader\".\n"

askme "Is the above true for you?"
if [ $? -eq $FALSE ]; then
    messme "\nYou should edit the LHOME, RHOME, and RROOT variables within this installion script and start again.\n"
    exit
fi

# Ask what system are you on, desktop or raspberry pi
messme "\nThis script should be run on the local system (aka desktop) and the Raspberry Pi."
askme "Are you on the Raspberry Pi?"
if [ $? -eq $FALSE ]; then
    sed -i 's/HOME=\"\/home\/pi\"/HOME=\"'$LHOME'\"/' part-1.sh
    messme "\nrpi-loader now fully installed on your local Linux system (aka desktop)."
else
    sed -i 's/HOME=\"\/home\/jeff\"/HOME=\"'$RHOME'\"/' part-2.sh
    sed -i 's/HOME=\"\/home\/jeff\"/HOME=\"'$RHOME'\"/' part-3.sh
    sed -i 's/HOME=\"\/home\/jeff\"/HOME=\"'$RHOME'\"/' part-4.sh
    sed -i 's/HOME=\"\/home\/jeff\"/HOME=\"'$RHOME'\"/' part-5.sh
    sed -i 's/HOME=\"\/home\/jeff\"/HOME=\"'$RHOME'\"/' part-6.sh
    sed -i 's/HOME=\"\/home\/jeff\"/HOME=\"'$RHOME'\"/' part-7.sh
    sed -i 's/HOME=\"\/home\/jeff\"/HOME=\"'$RHOME'\"/' part-8.sh
    sed -i 's/HOME=\"\/home\/jeff\"/HOME=\"'$RHOME'\"/' part-9.sh
    sed -i 's/HOME=\"\/home\/jeff\"/HOME=\"'$RHOME'\"/' part-10.sh
    messme "\nrpi-loader now fully installed on the Raspberry Pi."
fi

############################ ############################

messme "\nInstallation of rpi-loader completed.\n"

# clean up before exiting
echo -e -n ${NColor}
