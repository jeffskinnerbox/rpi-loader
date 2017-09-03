<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.1
-->

Raspberry Pi Loader
===================
I have written a detailed [step-by-step guide][03]
on how to set up your Raspberry Pi as a "headless" computer.
This includes configuring the RPi for my local network, updating firmware,
loading all my favorite development tools and utilities.
This guide has been of great value to me to help repeatedly and consistently establish my devices.
But the work is all manual requiring dozens of command line entries.
This utility takes the drudgery out of setting up a new Raspberry Pi by automating this manual tasks.

Clearly, not all everything can be scripted.
You still have to download the latest version of Raspbian,
burn it to a SD Card, and things like that.
My objective is to ultimate create some utilities that will make this easier,
but that will wait until another version of this script.

## Step 1: Download Raspberry Pi Image
Before you can load a copy of the latest Raspberry Pi image onto your micro SD Card,
you must first download the official Raspberry Pi operating system, [Raspbian][12]
(in my case, the version is [Jessie][11]).
You can get that download [here][13].

The Raspbian download site also lists a check sum for the download file.
(In my case, I down loaded the Raspbian file to `/home/jeff/Downloads/`.)
Check whether the file has been changed from its original state
by checking its digital signature (SHA1 hash value).

```bash
# validate file is uncorrupted via check of digital signature
$ sha1sum /home/jeff/Downloads/2016-02-09-raspbian-jessie.zip
da329713833e0785ffd94796304b7348803381db  /home/jeff/Downloads/2016-02-09-raspbian-jessie.zip
```

>**NOTE:** Latest versons of Raspian may be using SHA-256,
so replace `sha1sum` with `sha256sum` in the above command.

Next you need to unzip the file to retrieve the Linux image file:

```bash
$ unzip 2016-02-09-raspbian-jessie.zip
Archive:  2016-02-09-raspbian-jessie.zip
  inflating: 2016-02-09-raspbian-jessie.img
```

## Step 2: Write Raspberry Pi Image to SD Card
Next using Linux, you have copied the Raspbian image onto the SD card mounted to your system.
I'll be using the [Rocketek 11-in-1 4 Slots USB 3.0 Memory Card Reader][14] to create my SD Card.
Make sure to [choose a reputable SD Card][15] from [here][13], don't go cheap.

When using your card reader,
you'll need to know the device name of the reader.
The easiest way to find this is just unplug your card reader from the USB port,
run `df -h`, then plug it back in, and run `df -h` again.

```bash
# with the SD card reader unplugged
$ df -h
Filesystem      Size  Used Avail Use% Mounted on
udev            3.9G   12K  3.9G   1% /dev
tmpfs           783M  1.7M  781M   1% /run
/dev/sda3       110G   14G   90G  14% /
none            4.0K     0  4.0K   0% /sys/fs/cgroup
none            5.0M     0  5.0M   0% /run/lock
none            3.9G   90M  3.8G   3% /run/shm
none            100M   80K  100M   1% /run/user
/dev/sda1       461M  132M  306M  31% /boot
/dev/md0        917G  224G  647G  26% /home
/dev/sdb        3.6T  2.5T  950G  73% /mnt/backup

# with the SD card reader plugged in USB
$ df -h
Filesystem      Size  Used Avail Use% Mounted on
udev            3.9G   12K  3.9G   1% /dev
tmpfs           783M  1.8M  781M   1% /run
/dev/sda3       110G   14G   90G  14% /
none            4.0K     0  4.0K   0% /sys/fs/cgroup
none            5.0M     0  5.0M   0% /run/lock
none            3.9G   90M  3.8G   3% /run/shm
none            100M   80K  100M   1% /run/user
/dev/sda1       461M  132M  306M  31% /boot
/dev/md0        917G  224G  647G  26% /home
/dev/sdb        3.6T  2.5T  950G  73% /mnt/backup
/dev/sdj1        15G   32K   15G   1% /media/jeff/3CB1-D9D9
```

Note that in my example above, the new device is `/dev/sdj1`.
The last part (the number 1) is the partition number
but we want to write to the whole SD card, not just one partition.
Therefore you need to remove that part when creating the image.
With this information, and know the location of the Raspbian image and
where we need to write the Raspbian image to the SD Card
(see more detail instructions [here][16]).

```bash
# go to directory with the RPi image
cd /home/jeff/Downloads

# unmount the sd card reader
sudo umount /dev/sdj1

# write the image to the sd card reader
sudo dd bs=4M if=2016-02-09-raspbian-jessie.img of=/dev/sdj

# ensure the write cache is flushed
sudo sync

# check the integrity of the sd card image
sudo dd bs=4M if=/dev/sdj of=copy-from-sd-card.img
sudo truncate --reference 2016-02-09-raspbian-jessie.img copy-from-sd-card.img
diff -s 2016-02-09-raspbian-jessie.img copy-from-sd-card.img

# unmount the sd card reader
sudo umount /dev/sdj
```

Don’t remove SD card from the reader on your computer.
We’re going to set up the WiFi interface next.

>**NOTE:** You could immediately put the SD Card in the RPi and boot it up,
but you will have no WiFi access and you'll need to use the Ethernet interface,
or if there is no Ethernet interface,
you'll need to use a console cable to make the file modification
outline in the next step.
[Adafruit has good description on how to use a console cable]17]
and the how to [enable the UART for the console][18].

## Step 3: Run the part-1.sh Script
```bash
sudo ~/src/rpi-loader/part-1.sh
```

This completes the operations that will be performed on the SD-Card
while on `desktop`.
Next will place the SD-Car in the Raspberry Pi and complete the loading from there.

## Step 4: Clone the rpi-loader Tool
Place the SD-Card into the Raspberry Pi, power it up, and login via ssh.

From Github, you now need to install the `rpi-loader` scripts.

```bash
cd ~
mkdir src
cd src
git clone https://github.com/jeffskinnerbox/rpi-loader.git
```
## Step 5: Run the part-2.sh Script
Now your going to run `raspi-config` as a non-interactive command line tool
and set the time zone of the Raspberry Pi.

```bash
# run raspi-config tool and ste the time zone
sudo ~/src/rpi-loader/part-2.sh

# reboot the raspberry pi
sudo shutdown -r now
```

>**NOTE:** You can run `raspi-config` as a non-interactive command line tool.
See "[Instructions of command-line in Raspi-config][01]"
and you notice that the command takes the form
`sudo raspi-config nonint <option> [<parameter>]`.
Key to understanding how to use this command are the `#define`
statments found within "[How could one automate the raspbian raspi-config setup?][02]".
This capabilitiy is not documented, and as such,
could change without notice.

## Step 6: Run the part-3.sh Script


################################################################################
/boot/comline.txt

dwc_otg.lpm_enable=0 console=serial0,115200 console=tty1 root=PARTUUID=242ad76d-02 rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait quiet init=/usr/lib/raspi-config/init_resize.sh splash plymouth.ignore-serial-consoles

/boot/config.txt

# For more options and information see
# http://rpf.io/configtxt
# Some settings may impact device functionality. See link above for details

# uncomment if you get no picture on HDMI for a default "safe" mode
#hdmi_safe=1

# uncomment this if your display has a black border of unused pixels visible
# and your display can output without overscan
#disable_overscan=1

# uncomment the following to adjust overscan. Use positive numbers if console
# goes off screen, and negative if there is too much border
#overscan_left=16
#overscan_right=16
#overscan_top=16
#overscan_bottom=16

# uncomment to force a console size. By default it will be display's size minus
# overscan.
#framebuffer_width=1280
#framebuffer_height=720

# uncomment if hdmi display is not detected and composite is being output
#hdmi_force_hotplug=1

# uncomment to force a specific HDMI mode (this will force VGA)
#hdmi_group=1
#hdmi_mode=1

# uncomment to force a HDMI mode rather than DVI. This can make audio work in
# DMT (computer monitor) modes
#hdmi_drive=2

# uncomment to increase signal to HDMI, if you have interference, blanking, or
# no display
#config_hdmi_boost=4

# uncomment for composite PAL
#sdtv_mode=2

#uncomment to overclock the arm. 700 MHz is the default.
#arm_freq=800

# Uncomment some or all of these to enable the optional hardware interfaces
#dtparam=i2c_arm=on
#dtparam=i2s=on
#dtparam=spi=on

# Uncomment this to enable the lirc-rpi module
#dtoverlay=lirc-rpi

# Additional overlays and parameters are documented /boot/overlays/README

# Enable audio (loads snd_bcm2835)
dtparam=audio=on
################################################################################




## Sources of Inspiration
* [Scripts to update the Raspberry Pi and Debian-based Linux Distros](https://blog.robseder.com/2015/09/29/scripts-to-update-the-raspberry-pi-and-debian-based-linux-distros/)



[01]:https://www.52pi.com/blog/19-instructions-of-command-line-in-raspi-config
[02]:https://raspberrypi.stackexchange.com/questions/28907/how-could-one-automate-the-raspbian-raspi-config-setup
[03]:http://jeffskinnerbox.me/posts/2016/Apr/27/howto-set-up-the-raspberry-pi-as-a-headless-device/
[04]:
[05]:
[06]:
[07]:
[08]:
[09]:
[10]:
[11]:https://www.raspberrypi.org/blog/raspbian-jessie-is-here/
[12]:https://www.raspberrypi.org/downloads/raspbian/
[13]:https://www.raspbian.org/
[14]:http://www.amazon.com/gp/product/B00GVRHON2?psc=1&redirect=true&ref_=oh_aui_detailpage_o00_s01
[13]:http://www.jeffgeerling.com/blogs/jeff-geerling/raspberry-pi-microsd-card
[15]:http://www.wirelesshack.org/best-micro-sd-card-for-the-raspberry-pi-model-2.html
[16]:https://www.raspberrypi.org/documentation/installation/installing-images/linux.md
[17]:https://learn.adafruit.com/adafruits-raspberry-pi-lesson-5-using-a-console-cable/overview
[18]:https://cdn-learn.adafruit.com/downloads/pdf/adafruits-raspberry-pi-lesson-5-using-a-console-cable.pdf
[19]:
[20]:

