#!/bin/bash

# Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
# Version:      0.5
#
# DESCRIPTION:
#
# NOTE:



############################ ############################

# Print a line of text (i.e. a question) and then ask for yes or no responses
function askme {
    while true; do
        echo -n -e "${PROM}$@ [ yes/no ] ${NColor}" ; read ANS
        case "$ANS" in
            yes|Yes|YES) return 0 ;;
            no|No|NO) return 1 ;;
        esac
    done
}

# Print a line of text (i.e. a question) and then ask for a text responses
function promptme {
    echo -n -e "${PROM}$@: ${NColor}" ; read ANS
}

# Print a line of text as a message
function messme {
    echo -e "${MESS}$@${NColor}"
}

# Print message for fatal event
function mess_abort() {
    echo -e "${ALERT}$@${NColor}"
}

# Print a message if an error is tripped during processing
function sys_abort() {
    echo -e -n ${ALERT}
    echo >&2 '
***************
*** ABORTED ***
***************
'
    echo "An error occurred. Exiting..." >&2
    echo -e -n ${NColor}
    exit 1
}

# Print a message if user request an abort
function user_abort() {
    echo -e ${ALERT}$@
    echo "Script Aborted By User."
    echo -e -n ${NColor}
    exit 1
}

# print check information
function check_info() {
    echo -e ${CHECK}$@${NColor}
}

# Test to see if user is pi and abort if not
function pitest {
    if [[ $(whoami) != "pi" ]];
    then
        echo -e "${ALERT}ERROR: This utility must be run as user pi."
        echo "Script Aborted."
        echo -e -n ${NColor}
        exit 1
    fi
}

# Test to see if user is root and abort if not
function roottest {
    if [[ $(whoami) != "root" ]];
    then
        echo -e "${ALERT}ERROR: This utility must be run as root (or sudo)."
        echo "Script Aborted."
        echo -e -n ${NColor}
        exit 1
    fi
}

# Test to see if user is NOT root and abort if they are
function notroottest {
    if [[ $(whoami) == "root" ]];
    then
        echo -e "${ALERT}ERROR: This utility should NOT run as root (or sudo)."
        echo "Script Aborted."
        echo -e -n ${NColor}
        exit 1
    fi
}
