#!/bin/bash
# which_pi.bash
# BASH Script to display Pi Hardware version based on info found in /proc/cpuinfo
# Andy Delgado - April 11, 2017
# Info gleaned from
# http://www.raspberrypi-spy.co.uk/2012/09/checking-your-raspberry-pi-board-version

REVCODE=$(sudo cat /proc/cpuinfo | grep 'Revision' | awk '{print $3}' | sed 's/^ *//g' | sed 's/ *$//g')

if [ "$REVCODE" = "0002" ]; then
    PIMODEL="Raspberry Pi Model B Rev 1, 256 MB RAM"
fi

if [ "$REVCODE" = "0003" ]; then
    PIMODEL="Raspberry Pi Model B Rev 1 ECN0001, 256 MB RAM"
fi

if [ "$REVCODE" = "0004" ]; then
    PIMODEL="Raspberry Pi Model B Rev 2, 256 MB RAM"
fi

if [ "$REVCODE" = "0005" ]; then
    PIMODEL="Raspberry Pi Model B Rev 2, 256 MB RAM"
fi

if [ "$REVCODE" = "0006" ]; then
    PIMODEL="Raspberry Pi Model B Rev 2, 256 MB RAM"
fi

if [ "$REVCODE" = "0007" ]; then
    PIMODEL="Raspberry Pi Model A, 256 MB RAM"
fi

if [ "$REVCODE" = "0008" ]; then
    PIMODEL="Raspberry Pi Model A, 256 MB RAM"
fi

if [ "$REVCODE" = "0009" ]; then
    PIMODEL="Raspberry Pi Model A, 256 MB RAM"
fi

if [ "$REVCODE" = "000d" ]; then
    PIMODEL="Raspberry Pi Model B Rev 2, 512 MB RAM"
fi

if [ "$REVCODE" = "000e" ]; then
    PIMODEL="Raspberry Pi Model B Rev 2, 512 MB RAM"
fi

if [ "$REVCODE" = "000f" ]; then
    PIMODEL="Raspberry Pi Model B Rev 2, 512 MB RAM"
fi

if [ "$REVCODE" = "0010" ]; then
    PIMODEL="Raspberry Pi Model B+, 512 MB RAM"
fi

if [ "$REVCODE" = "0013" ]; then
    PIMODEL="Raspberry Pi Model B+, 512 MB RAM"
fi

if [ "$REVCODE" = "900032" ]; then
    PIMODEL="Raspberry Pi Model B+, 512 MB RAM"
fi

if [ "$REVCODE" = "0011" ]; then
    PIMODEL="Raspberry Pi Compute Module, 512 MB RAM"
fi

if [ "$REVCODE" = "0014" ]; then
    PIMODEL="Raspberry Pi Compute Module, 512 MB RAM"
fi

if [ "$REVCODE" = "0012" ]; then
    PIMODEL="Raspberry Pi Model A+, 256 MB RAM"
fi

if [ "$REVCODE" = "0015" ]; then
    PIMODEL="Raspberry Pi Model A+, 256 MB or 512 MB RAM"
fi

if [ "$REVCODE" = "a01041" ]; then
    PIMODEL="Raspberry Pi 2 Model B v1.1, 1 GB RAM"
fi

if [ "$REVCODE" = "a21041" ]; then
    # a21041 (Embest, China)
    PIMODEL="Raspberry Pi 2 Model B v1.1, 1 GB RAM"
fi

if [ "$REVCODE" = "a22042" ]; then
    PIMODEL="Raspberry Pi 2 Model B v1.2, 1 GB RAM"
fi

if [ "$REVCODE" = "90092" ]; then
    PIMODEL="Raspberry Pi Zero v1.2, 512 MB RAM"
fi

if [ "$REVCODE" = "90093" ]; then
    PIMODEL="Raspberry Pi Zero v1.3, 512 MB RAM"
fi

if [ "$REVCODE" = "0x9000C1" ]; then
    PIMODEL="Raspberry Pi Zero W, 512 MB RAM"
fi

if [ "$REVCODE" = "a02082" ]; then
    PIMODEL="Raspberry Pi 3 Model B, 1 GB RAM"
fi

if [ "$REVCODE" = "a22082" ]; then
    PIMODEL="Raspberry Pi 3 Model B, 1 GB RAM"
fi

echo "$PIMODEL ($REVCODE)"



# better version
function check_pi_version() {
  local -r REVCODE=$(awk '/Revision/ {print $3}' /proc/cpuinfo)
  local -rA REVISIONS=(
    [0002]="Model B Rev 1, 256 MB RAM"
    [0003]="Model B Rev 1 ECN0001, 256 MB RAM"
    [0004]="Model B Rev 2, 256 MB RAM"
    [0005]="Model B Rev 2, 256 MB RAM"
    [0006]="Model B Rev 2, 256 MB RAM"
    [0007]="Model A, 256 MB RAM"
    [0008]="Model A, 256 MB RAM"
    [0009]="Model A, 256 MB RAM"
    [000d]="Model B Rev 2, 512 MB RAM"
    [000e]="Model B Rev 2, 512 MB RAM"
    [000f]="Model B Rev 2, 512 MB RAM"
    [0010]="Model B+, 512 MB RAM"
    [0013]="Model B+, 512 MB RAM"
    [900032]="Model B+, 512 MB RAM"
    [0011]="Compute Module, 512 MB RAM"
    [0014]="Compute Module, 512 MB RAM"
    [0012]="Model A+, 256 MB RAM"
    [0015]="Model A+, 256 MB or 512 MB RAM"
    [a01041]="2 Model B v1.1, 1 GB RAM"
    [a21041]="2 Model B v1.1, 1 GB RAM"
    [a22042]="2 Model B v1.2, 1 GB RAM"
    [90092]="Zero v1.2, 512 MB RAM"
    [90093]="Zero v1.3, 512 MB RAM"
    [0x9000C1]="Zero W, 512 MB RAM"
    [a02082]="3 Model B, 1 GB RAM"
    [a22082]="3 Model B, 1 GB RAM"
  )

  echo "Raspberry Pi ${REVISIONS[${REVCODE}]} (${REVCODE})"
}




# check if the raspberry pi is 2 or 3?
cat /proc/device-tree/model

# CPU architectures
uname -m

# cpu information
cat /proc/cpuinfo

# Version of Debian
cat /etc/debian_version

# OS Release Notes
cat /etc/os-release

# Kernel Version
uname -a

# cpu temperature
cpu=$(</sys/class/thermal/thermal_zone0/temp)
echo "$((cpu/1000)) c"

# gpu temperature
/opt/vc/bin/vcgencmd measure_temp

cat /proc/version

# type of usb camera
v4l2-ctl --list-formats

# pi camera hardware version

# version of picamera software
python3 -c "from pkg_resources import require ; print(require('picamera')) ; print(require('picamera')[0].version)"

# Which Raspberry Pi Camera Module Should You Buy?
# https://www.lifewire.com/which-raspberry-pi-camera-module-should-you-buy-4090303
# https://diyprojects.io/picamera-version-1-9-control-the-raspberry-pi-camera-in-python/#.Wll6QHVKvmE
