#!/bin/bash

# Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
# Version:      0.1
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
# clean up before exiting
echo -e -n ${NColor}
