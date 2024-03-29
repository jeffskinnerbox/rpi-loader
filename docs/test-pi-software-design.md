<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.0.1
-->


<div align="center">
<img src="https://raw.githubusercontent.com/jeffskinnerbox/blog/main/content/images/banners-bkgrds/work-in-progress.jpg" title="These materials require additional work and are not ready for general use." align="center" width=420px height=219px>
</div>


----


* [Kacper Leśniara's Ansible Playbook Sets Up Your Raspberry Pi in a Single Command](https://www.hackster.io/news/kacper-lesniara-s-ansible-playbook-sets-up-your-raspberry-pi-in-a-single-command-b06dc8f28a23)
* [Ansible by Example](https://dzone.com/articles/ansible-boots-kubernetes)


# Raspberry Pi Loader

* rpi-loader - https://github.com/jeffskinnerbox/rpi-loader
    * fix the scripts concern the use of sudo
    * write scripts for the loading of OpenCV, Jupyter, etc.
* OpenCV
    * include procedures from [Optimizing OpenCV on the Raspberry Pi](https://www.pyimagesearch.com/2017/10/09/optimizing-opencv-on-the-raspberry-pi/)
    * [Installing Keras with TensorFlow backend](https://www.pyimagesearch.com/2016/11/14/installing-keras-with-tensorflow-backend/)
    * [Install dlib on the Raspberry Pi](https://www.pyimagesearch.com/2017/05/01/install-dlib-raspberry-pi/)
    * [Install dlib (the easy, complete guide)](https://www.pyimagesearch.com/2018/01/22/install-dlib-easy-complete-guide/)
    * [How to install OpenCV 4 on Ubuntu](https://www.pyimagesearch.com/2018/08/15/how-to-install-opencv-4-on-ubuntu/)
    * [pip install opencv](https://www.pyimagesearch.com/2018/09/19/pip-install-opencv/)
    * [Building a Digits Dev Machine on Ubuntu 16.04](https://blog.kickview.com/building-a-digits-dev-machine-on-ubuntu-16-04/)

* [How to Update Your Raspberry Pi to the Latest Raspbian OS](https://www.makeuseof.com/tag/raspberry-pi-update-raspbian-os/)
* [Turn Raspberry Pi into Server and Implement CI/CD pipeline in AWS](https://levelup.gitconnected.com/turn-raspberry-pi-into-server-and-implement-ci-cd-pipeline-in-aws-752c5321dfe4)

# Reducing SD Card Wear
*[Give Your Raspberry Pi SD Card a Break: Log to RAM](https://hackaday.com/2019/04/08/give-your-raspberry-pi-sd-card-a-break-log-to-ram/)

# Alternative Methods
* [How to manage your workstation configuration with Ansible](https://opensource.com/article/18/3/manage-workstation-ansible)
* [Manage your workstation with Ansible: Automating configuration](https://opensource.com/article/18/3/manage-your-workstation-configuration-ansible-part-2)

# Create Alternative Base Images
* [How to install Fedora IoT on Raspberry Pi 4](https://www.redhat.com/sysadmin/fedora-iot-raspberry-pi)
* Ubuntu
* EdgeX



-----



The Raspberry Pi board named `test-pi` is intended to be my physical environment for building
and then testing new hardware, software, and operating systems for the Raspberry Pi hardware environment.
It will be a safe space to make the inevitable mistakes before I commit myself to some new system,
or just a place for experimentation.

I want to create, in advance, multiple base images (e.g. Raspberry Pi OS, Proxmox, Ubuntu, etc.)
so I could move quickly from one to another.
These base images will reside some where other than the `test-pi` and should be easy loaded onto the `test-pi`.
On top of these base images, I will load things like
[Home Assistant][91], [EdgeX Foundry][92], [OpenCV][913, [Tensorflow][94], etc.
I want Ansible scripts to be used, when ever possible, to facilitate the creating
and destruction of the environments loaded on the `test-pi`.

# Base Image
Raspberry Pi
Ubuntu
Proxmox

## Create the Raspberry Pi Base Image
Raspberry Pi OS boots off an SD card,
and your going want to maintain SD card base image to imitate any new solution.
This base image is an up-to-date version of the software on the SD card
that can just plug in and it works in a minimal, predictable way.
The creation of this base image will require some
special tools (e.g. [Raspberry Pi SD-Card imager - `rpi-imager`][74]),
but you will almost certainly require further changes to this base image
and you're going to want to implement these additional changes via standard tools like Ansible playbooks.

## Create the Raspberry Pi OS SD-Card
I have written a detailed [step-by-step guide][03]
on how to set up your Raspberry Pi as a "headless" computer.
(Some of the ideas for this script were taken from the following:
"[Scripts to update the Raspberry Pi and Debian-based Linux Distros][05]".)
This includes configuring the RPi for my local network, updating firmware,
loading all my favorite development tools and utilities.
This guide has been of great value to me to help repeatedly and consistently establish my devices.
But this work is no long valid starting in April 2022
with the release of the Bullseye version of Raspberry Pi OS.

#### Step 0: Check Your Current Environment - DONE
Before do anything, you might want to check the version of OS
and hardware your Raspberry Pi currently has.
By doing this you could save considerable time & effort.

```bash
# what version of debian you are running
$ cat /etc/debian_version
11.7

# os release notes
$ cat /etc/os-release
PRETTY_NAME="Debian GNU/Linux 11 (bullseye)"
NAME="Debian GNU/Linux"
VERSION_ID="11"
VERSION="11 (bullseye)"
VERSION_CODENAME=bullseye
ID=debian
HOME_URL="https://www.debian.org/"
SUPPORT_URL="https://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"

# what kernel version is running
$ uname -a
Linux test-pi 6.1.21-v8+ #1642 SMP PREEMPT Mon Apr  3 17:24:16 BST 2023 aarch64 GNU/Linux

# 32 or 64 bit architecture
$ uname -m
aarch64

# see what hardware you are using
$ cat /proc/cpuinfo | grep Model
Model		: Raspberry Pi 3 Model B Rev 1.2
```

I'll assume that this Raspberry Pi configuration isn't what you need,
and we'll move onto the next step.

Source:
* [How to Check the Software and Hardware Version of a Raspberry Pi][16]

#### Step 1: Select SD-Card - DONE
The tools you are about to install could take up a great deal of space.
For example, a video applications using OpenCV,
alone alone are very large (430M + 120M).
A standard Raspberry Pi install will likely use about 4GB of the available space,
and then you add your personal tools and more space is used up.
I have found that attempting to load OpenCV and the OpenCV Contribution package
will require 10GB of disk space.

If your considering using Jupyter and some of the popular Python libraries,
your looking at 11 to 12GB of SD-Card storage being consumed.
**My advice is to consider using a 16G or larger SD-Card.**

#### Step 2: Download Raspberry Pi Image - DONE
Before you can load a copy of the latest Raspberry Pi image onto your micro SD Card,
you must first download the official Raspberry Pi operating system, [Raspberry Pi OS][13]
(in my case, the version is [Raspberry Pi OS Lite from Oct 10, 2023][11]).
You can get that download [here][13].

The Raspberry Pi OS download site also lists a check sum for the download file.
(In my case, I down loaded the Raspberry Pi OS file to `/home/jeff/Downloads/ISO-Images/RPi-OS/`.)
Check whether the file has been changed from its original state
by checking its digital signature (SHA256 hash value).

```bash
# move to the working directory
cd ~/Downloads/ISO-Images/RPi-OS/

# download the rpi image
download page - https://www.raspberrypi.com/software/operating-systems/#raspberry-pi-os-64-bit

# validate file is uncorrupted via check of digital signature
$ sha256sum 2023-10-10-raspios-bookworm-arm64-lite.img.xz
26ef887212da53d31422b7e7ae3dbc3e21d09f996e69cbb44cc2edf9e8c3a5c9  2023-10-10-raspios-bookworm-arm64-lite.img.xz

# uncompress the raspberry pi os download
unxz 2023-10-10-raspios-bookworm-arm64-lite.img.xz
```

#### Step 3: Write Raspberry Pi Image to SD Card - DONE
Next using Linux, you have copied the Raspberry Pi OS image onto the SD card mounted to your system.
I'll be using the [Rocketek 11-in-1 4 Slots USB 3.0 Memory Card Reader][14] to create my SD Card.
Make sure to [choose a reputable SD Card][15] from [here][36], don't go cheap.

To create you SD-Card image of Raspberry Pi OS,
install and use the [Raspberry Pi Imager (`rpi-imager`)](https://www.raspberrypi.com/software/),
as shown below:

```bash
# install the raspberry pi imager on your desktop linux
sudo apt install rpi-imager

# execute the imager
rpi-imager
```

Next, you do the following:

* For **Operating System** select your image you downloaded (i.e. **Use custom** at the bottom of the page)
* For **Storage** you select the device containing the SD card you wish to write the image
* Now select the "gear" icon and do the following:
    * Set host name (`test-pi`)
    * enable SSH using password authentication
    * set your username and password (`pi` and `raspberry`)
    * set your time zone (`New York`)

>**NOTE:** As of April 2022 (Bullseye version),
>[Raspberry Pi OS has removed the default 'pi' user][73] to make it
>harder for attackers to find and compromise Internet-exposed Raspberry Pi
>devices using default credentials.
>This may (not sure about this) requires you to make use of the
>[Raspberry Pi SD-Card imager][74] to get SSH access on fist boot instead of
>using the trick of placing a file name `ssh` in the `/boot` directory of the Raspberry Pi.

#### Step 4: Booting From the SD-Card - DONE
Install into your Raspberry Pi the SD Card created earlier,
connect an Ethernet cable from you LAN,
and then press the power switch if you have one.

**IMPORTANT**
If you are using the [LiFePO4wered/Pi][04],
you should disconnect the board completely from the Raspberry board for this first boot
and subsequent installation of the LiFePO4wered/Pi software.

>**WARNING:** Applying power to the Raspberry Pi with the
>LiFePO4wered/Pi3™ connected but the battery removed will expose the
>LiFePO4wered/Pi3™ to voltages that can cause permanent damage.
>This is particuarlly true if the battery is removed.
>In general, the safest thing is to avoid powering the Raspberry Pi
>from any other source when the LiFePO4wered/Pi3™ is connected.

Once the RPi boots up,
you can [find your Raspberry P on your network][69] using [`arp-scan`][70]
or [`netdiscover`][71].
It may take 2 to 3 minutes before you get a response from the Raspberry Pi.

```bash
# actively scan the network for all live hosts and then passively scan indefinitely
# to abtain the ip address of your raspberry pi
sudo netdiscover -c 3 -s 10 -L -N -r 192.168.1.0/24 | grep Raspberry
```

Now using the IP address you found for the RPi via `netdiscover`,
`192.168.1.79` in my case,
in the next steps we can provides the Raspberry Pi with additional SSH access keys,
enabling us to automate the update of the OS via Ansible.

#### Step 5: Query Hardware/Software Versions - DONE
To find out what version of Raspberry Pi hardware and software your are now running,
execute the following command:

```bash
# login to the raspberry pi
ssh pi@192.168.1.79

# query for version of hardware your on
$ cat /proc/device-tree/model
Raspberry Pi 3 Model B Rev 1.2

# what version of debian you are running
$ cat /etc/debian_version
12.2

# os release notes
$ cat /etc/os-release
PRETTY_NAME="Debian GNU/Linux 12 (bookworm)"
NAME="Debian GNU/Linux"
VERSION_ID="12"
VERSION="12 (bookworm)"
VERSION_CODENAME=bookworm
ID=debian
HOME_URL="https://www.debian.org/"
SUPPORT_URL="https://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"

# what kernel version is running
$ uname -a
Linux test-pi 6.1.0-rpi4-rpi-v8 #1 SMP PREEMPT Debian 1:6.1.54-1+rpt2 (2023-10-05) aarch64 GNU/Linux
```

### Step 6: Set a Static IP Address - DONE
If you’re using your Raspberry Pi as a server
often need to access it remotely from another device,
or provission it with with tools like Ansible,
setting a [static IP address][78] for it is a very good idea.
This way you find the Raspberry Pi at the same address every time,
rather than a new address being set dynamically by [DHCP][79].

With the release of Raspberry Pi OS Bookworm,
networking on the Raspberry Pi was changed to use [NetworkManager][75] as the standard controller for networking,
replacing the previous [dhcpcd][83] system.
NetworkManager includes a command line tool called `nmcli`,
which can control NetworkManager and report on the network status.
I'll use `nmcli` to configure the network to use a static IP address,
instead of editing files directly.

My home router is my DHCP server (`192.168.1.1`) and I have reserved the IP range 2 to 199
for dynamically allocated IP addresses.
This leaves IP range 200 to 255 for static IP addresses.
I'll use `192.168.1.205`.

```bash
# find the name of the network interface you want to set as static
$ sudo nmcli connection show
NAME                UUID                                  TYPE      DEVICE
Wired connection 1  8ce12ab9-ef90-3c9a-af86-27477c777b17  ethernet  eth0
lo                  87e79030-02cb-4eed-a27e-1013ad643337  loopback  lo

# OR
$ sudo nmcli dev status
DEVICE         TYPE      STATE                   CONNECTION
eth0           ethernet  connected               Wired connection 1
lo             loopback  connected (externally)  lo
wlan0          wifi      disconnected            --
wlan1          wifi      disconnected            --
p2p-dev-wlan0  wifi-p2p  disconnected            --
p2p-dev-wlan1  wifi-p2p  disconnected            --
```

Now we know the name of the network connection we want to update,
we can send three commands to set the new IP address, Gateway and DNS server.

```bash
# set the new ip address
sudo nmcli con mod "Wired connection 1" ipv4.addresses 192.168.1.205/24

# set the new gateway address
sudo nmcli con mod "Wired connection 1" ipv4.gateway 192.168.1.1

# set the new dns server address
sudo nmcli con mod "Wired connection 1" ipv4.dns "192.168.1.1,8.8.8.8"

# change the addressing from DHCP to static
sudo nmcli con mod "Wired connection 1" ipv4.method manual
```

When you have finished updating the network settings on your Raspberry Pi,
you can restart the network connection with the following command:

```bash
# restart the network connection
sudo nmcli con down "Wired connection 1" && sudo nmcli con up "Wired connection 1"
```

>**NOTE:** If you are using SSH to connect to your Raspberry Pi,
>running the above command will cause the SSH session to end if the IP address changes.

You'll need to re-login to the Raspberry Pi,
but this time using the new IP address (i.e. `192.168.1.205`).

```bash
# re-login to the raspbrry pi
ssh pi@192.168.1.205

# examine the changes to the network interface
$ sudo nmcli -p connection show
```

Source:
* [Set a static IP Address on Raspberry Pi OS Bookworm](https://www.abelectronics.co.uk/kb/article/31/set-a-static-ip-address-on-raspberry-pi-os-bookworm)
* [How to Configure Network Connection Using ‘nmcli’ Tool](https://www.tecmint.com/nmcli-configure-network-connection/)

#### Step 7: Disable GUI Desktop Environment
I'll be using my `test-pi` system as a server,
instead of using the desktop GUI environment.
I'll be using a terminal for all work on the system,
and any GUI applications will run there graphics from my X Windows desktop environment.
This will decrease the load on the `test-pi` system and make boot up quicker.

To do this, we can use the `raspi-config` tool like this:
* Execute the tool via `sudo raspi-config`
* Select **System Options** > **Boot / Auto Login** > **Console**
* After a brief pause, select **Finish** and reboot.

Sources
* [How could one automate the raspbian raspi-config setup?](https://raspberrypi.stackexchange.com/questions/28907/how-could-one-automate-the-raspbian-raspi-config-setup)
* [The Ultimate Guide to the Raspi-Config Tool](https://pimylifeup.com/raspi-config-tool/)

#### Step 8: Copy Ansible SSH Keys to Raspberry Pi
Ansible primarily communicates with client computers through SSH.
While it has the ability to handle password-based SSH authentication,
using SSH keys can help to keep things simple.
(Check [here][72] if you need more information concerning SSH,
how to generate keys, using keys, etc.)

>**NOTE:** The Ansible server could exist anywhere as long as they are reachable via SSH.
>On your Ansible host machine,
>your first step is to install Ansible and any extension you may want to use.
>See `using-vagrant-docker-and-ansible.md` to understand how to do this.

On my Ansible server (my Linux desktop computer),
I have created a specific SSH key for Ansible work.
That key is `~/.ssh/ansible.pub`.
I'll use one of the methods below to push that key to my Raspberry Pi.

##### Method 8A: Copying Public Key Using ssh-copy-id
The simplest method to provide the SSH keys to the client computer
is to use the `ssh-copy-id` tool.
Launching from the Ansible server, the syntax is:
`ssh-copy-id username@remote_host`.
In my case:

```bash
# from my desktop computer, copying public key using ssh-copy-id
ssh-copy-id -i ~/.ssh/ansible.pub pi@192.168.1.205
```

To test if this is successful,
login to your Ansible client via SSH: `pi@192.168.1.205`
and you should get in without being prompted for a password.

##### Method 8B: Copying Public Key Using SSH
If you do not have `ssh-copy-id` available on your computer,
but you have password-based SSH access to an account on your server,
you can upload your keys using a conventional SSH method:

```bash
# from my desktop computer, copying public key using ssh
cat ~/.ssh/ansible.pub | ssh pi@test-pi "mkdir -p ~/.ssh && touch ~/.ssh/authorized_keys && chmod -R go= ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

##### Method 8C: Copying Public Key Manually
The final method is just to do it all manually.
Assuming SSH is already established on your Ansible server,
use the `cat` command to print the contents of your
non-root user’s SSH public key file to the terminal’s output:

```bash
# copy this public ssh key
cat ~/.ssh/id_rsa.pub
```

Copy the resulting output to your clipboard,
then open a new terminal and connect to one of your Ansible hosts using SSH,
and do the following:

1. Switch to the client machine’s root user.
1. As the root user, open the `authorized_keys` within the `~/.ssh` directory:
1. In the file, paste your Ansible server user’s SSH key, then save the file.

#### Step 9: Creating Inventory File
Ansible needs to know your remote server names or IP address.
This information is stored in a file called `hosts`, or often refered to as your "inventory".
The default file is `/etc/ansible/hosts`.
You can edit this one or create a new one in your `$HOME` directory,
or better yet, place the `hosts` file in your projects directory referance it
on the command-line when running `ansible`.

```bash
# create the hosts (aka inventory) file for your raspberry pi
cat <<EOF > inventory
# Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
# Version:      0.0.1

# aka ansible hosts file

# ansible control node
#[controller]
#127.0.0.1 ansible_connection=local

# ansible managed hosts (aka nodes)
[nodes]
test-pi ansible_ssh_host=192.168.1.205 ansible_ssh_port=22 kubernetes_role=node
#node-1 ansible_ssh_host=192.168.33.231 ansible_ssh_port=22 kubernetes_role=master
#node-2 ansible_ssh_host=192.168.33.232 ansible_ssh_port=22 kubernetes_role=node
#node-3 ansible_ssh_host=192.168.33.233 ansible_ssh_port=22 kubernetes_role=node

# ansible varables applied to [nodes]
[nodes:vars]
ansible_user='pi'
ansible_ssh_user=pi
deploy_target=pi
ansible_become=yes
ansible_become_method=sudo
ansible_python_interpreter='/usr/bin/env python3'
#ansible_python_interpreter=/usr/bin/python3
EOF
```

#### Step 10: Test Ansible Configuration
Ansilbe support many ad-hoc commands that can be used to manage your nodes.
You find a long list in the webpost "[How to Use Ansible: A Reference Guide][07]"
and some listed below.
Use them to test your Ansible setup so far.

```bash
# check your inventory
ansible-inventory -i inventory --list -y

# gather facts about a node
ansible test-pi -i inventory -m setup

# connectivity test, including localhost (aka controller)
ansible all -i inventory -m ping

# install the package vim on test-pi from your inventory
ansible test-pi -i inventory -m apt -a "name=vim"

# you can conduct a dry run to predict how the servers would be affected by your command
ansible test-pi -i inventory -m apt -a "name=vim" --check

# get current disk usage, including localhost (aka controller)
$ ansible all -i inventory -m shell -a "df -h"

# get current memory usage, including localhost (aka controller)
$ ansible all -i inventory -m shell -a "free -m"

# reboot all the linux hosts, but not localhost (aka controller)
$ ansible nodes -i inventory -m shell -a "sleep 1s; shutdown -r now" -b -B 60 -P 0

# shut down all the linux hosts, but not localhost (aka controller)
$ ansible nodes -i inventory -m shell -a "sleep 1s; shutdown -h now" -b -B 60 -P 0

# uptime check for individual host 'test-pi'
ansible test-pi -i inventory -a "uptime" -u root

# specify multiple hosts by separating them with colons
ansible test-pi:node-2 -i inventory -a "uptime" -u root

# install vim-nox package on test-pi
ansible test-pi -m apt -a "name=vim-nox" --become
```


-----



# Build test-pi Using Ansible Scripts
With the above steps completed,
I can begin leveraging Ansible to create the envirment I would like for `test-pi`.
In my case, I want to create an envirment sutable for testing out [Home Assistant][91].

#### Step 1: Update All packages
Before we load any targetted aplications,
We should update the currently load software to the latest versions, as shown below:

```bash
# go to the directory where the inventory file is located
cd ~/src/linux-tools/rpi-loader/playbooks

# validate the playbook 'update' role
ansible-playbook -i inventory -l test-pi  playbook.yml --tags update --skip-tags uninstall --list-tasks

# update all packages (equivalent to "apt update && apt full-upgrade")
ansible-playbook -i inventory -l test-pi  playbook.yml --tags update --skip-tags uninstall
```

Source:
* [Ansible apt update all packages on Ubuntu / Debian Linux][68]

#### Step 2: Install Battery Supply + Power Monitoring Tools
The [LiFePO4wered/Pi3][95] (purchase on [Tindie][96])
may be the best power solution for the Raspberry Pi 3.
It combines both the UPS and power monitoring functions into a single solution.
It also has PCB touch button that gives you clean shutdown instead of just pulling power.
A ultra-low power [MSP430G2231 microcontroller][97] monitors the battery
and also connected to the Pi's I2C bus and monitors the Pi's running state.
You can find more information in the [LiFePO4wered/Pi3 Product Brief][98].

The designer provides a [open source software package to interact with the LiFePO4wered/Pi3][99].
It contains an application development library,
a CLI interface to read/write device registers over the I2C bus,
and a tiny daemon (`lifepo4wered-daemon`) that continually tracks the power state.
The daemon can initiate a clean shutdown when the battery is empty
or the user wants to turn the RPi off using the touch button.
Touch button parameters, voltage thresholds,
and an auto boot flag can be customized by the user and saved to flash.
You can also set it up so the RPi will automatically boot whenever there is enough battery charge.
There is also a wake up timer that can be set so the Pi can shut down,
and automatically be started again after the wake timer expires.

The LiFePO4wered/Pi3 is specifically designed for the heavy load conditions
found on a typical Raspberry Pi 3 but can work on all the RPi versions.
(**NOTE:** The [LiFePO4wered/Pi][95] is smaller and engineered for the Raspberry Pi Zero.)
You can even get a case with room for the RPi3 and the LiFePO4wered/Pi3 [on Tindie][100].

The LiFePO4wered/Pi3 requires software to be running on the Raspberry Pi to operate correctly.
This software provides a daemon that automatically
manages the power state and shutdown of the RPi,
a library that allows integration of LiFePO4wered/Pi3 functionality in user programs,
and a CLI (command line interface) program that allows the user to
easily configure the LiFePO4wered/Pi3 or control it from shell scripts.

To run the Ansible playbook for installing the LiFePO4wered/Pi,
follow these instructions:

```bash
# go to the directory where the inventory file is located
cd ~/src/linux-tools/rpi-loader/playbooks

# ansible dry-run checking for errors and showing results of a run
ansible-playbook -i inventory -l test-pi playbook.yml --tags ups-pi --skip-tags uninstall --list-tasks

# run the just the role 'ups-pi' playbook for real
ansible-playbook -i inventory -l test-pi playbook.yml --tags ups-pi --skipp-tags uninstall
```

To completer this task,
I need to run an installation step that I could get to work (yet) in Ansible.
That task is running the following command:

* Execute the tool via `sudo raspi-config`
* Select **Interface Options** > **I2C** > **Yes**.
* After a brief pause, select **Finish** and reboot.
* On the Raspberry Pi, change directory to `/home/pi/src/LiFePO4wered-Pi` and
  run the comand `sudo make user-install` to install the daemon.

>**NOTE:** You need to restart for some configuration changes (such as enabling the I2C device) to take effect.

You can now power the Rasberry Pi via the LiFePO4wered/Pi3 using using its USB connection
and make use of the start/stop button.

You can check if the `LiFePO4wered` daemon and I2C services are running:

```bash
# ask systemctl to report on services that are in the running state
$ systemctl --type=service --state=running
  UNIT                        LOAD   ACTIVE SUB     DESCRIPTION
  avahi-daemon.service        loaded active running Avahi mDNS/DNS-SD Stack
  bluetooth.service           loaded active running Bluetooth service
  cron.service                loaded active running Regular background program processing daemon
  dbus.service                loaded active running D-Bus System Message Bus
  getty@tty1.service          loaded active running Getty on tty1
  lifepo4wered-daemon.service loaded active running Daemon for LiFePO4wered power manager
  ModemManager.service        loaded active running Modem Manager
  NetworkManager.service      loaded active running Network Manager
  ntpsec.service              loaded active running Network Time Service
  polkit.service              loaded active running Authorization Manager
  serial-getty@ttyS0.service  loaded active running Serial Getty on ttyS0
  ssh.service                 loaded active running OpenBSD Secure Shell server
  systemd-journald.service    loaded active running Journal Service
  systemd-logind.service      loaded active running User Login Management
  systemd-udevd.service       loaded active running Rule-based Manager for Device Events and Files
  triggerhappy.service        loaded active running triggerhappy global hotkey daemon
  user@1000.service           loaded active running User Manager for UID 1000
  wpa_supplicant.service      loaded active running WPA supplicant

LOAD   = Reflects whether the unit definition was properly loaded.
ACTIVE = The high-level unit activation state, i.e. generalization of SUB.
SUB    = The low-level unit activation state, values depend on unit type.

# show what I2C modules are loaded
$ lsmod | grep i2c
i2c_dev                20480  0
i2c_bcm2835            20480  0

# read the state of the I2C port (0 = true = i2c port is enabled)
$ sudo raspi-config nonint get_i2c
0

# scan the I2C address range
$ sudo i2cdetect -y 1
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:                         -- -- -- -- -- -- -- --
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
40: -- -- -- 43 -- -- -- -- -- -- -- -- -- -- -- --
50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
70: -- -- -- -- -- -- -- --
```

#### Step X: Run remaining Ansible Scripts

```bash
# go to the directory where the inventory file is located
cd ~/src/linux-tools/rpi-loader/playbooks

# ansible dry-run checking for errors and showing results of a run
ansible-playbook -i inventory -l test-pi playbook.yml --tags "prerequisites, sys-env, net-tools" --skip-tags uninstall --list-tasks

# run the just the role 'ups-pi' playbook for real
ansible-playbook -i inventory -l test-pi playbook.yml --tags "prerequisites, sys-env, net-tools" --skip-tags uninstall
```

Sources
* [Enabling and checking I2C on the Raspberry Pi using the command line for your own scripts](https://pi3g.com/enabling-and-checking-i2c-on-the-raspberry-pi-using-the-command-line-for-your-own-scripts/)


-----




-----



## Building Image and Video Processing Tools

### Install GStreamer and FFmpeg
[GStreamer][76] is a framework for creating streaming media applications.
The GStreamer framework is designed to make it easy to write applications
that handle audio or video or both.
It isn't restricted to audio and video,
and can process any kind of data flow.
Its main advantages are that the pluggable components can be mixed and matched
into arbitrary pipelines so that it's possible to write a
full-fledged video or audio editing application.
You can also use the pipelining capabilities of GStreamer
to take the video output from a Raspberry Pi camera module
and encode the video in H.264 format before passing it on to Janus.
GStreamer is a pipeline-based multimedia framework that links together
a wide variety of media processing systems to complete complex workflows.
For instance, GStreamer can be used to build a system that reads files in one format,
processes them, and exports them in another.
The formats and processes can be changed in a plug and play fashion.
(See this [diagram of the pipeline processing][77] for an example.)
This processing can be done on the [shell command line][82] or via
[Python bingdings][80] or [C bindings][81].

[FFmpeg][62] claims to play pretty much anything that humans and machines have created;
supporting the most obscure ancient formats up to the cutting edge.
FFmpeg is able to decode, encode, transcode, mux, demux, stream, filter and play most anything.
Effectively, FFmpeg continuously streams a webcam's video to single `.jpg` file.
This toolkit contains:

* `**[ffmpeg][61]**` - is a command line tool for fast video and audio converter that can also grab from a live audio/video source.
* `**[ffserver][60]`** - is a streaming server for both audio and video.
* `**[ffplay][59]**` - is a command line simple and portable media player using the FFmpeg libraries and the SDL library.
* `**[ffprobe][58]**` - is a command line tool to gathers information from multimedia streams and prints it in human- and machine-readable fashion.

Unfortunately, Debian Jessie and later [no longer include the ffmpeg package][64].
To install it and make sure we have the latest and greatest ffmpeg,
I choose to [install from source code][63].

You can install this two powerful image/video processing tools on the  Raspberry Pi
via the following script:

```bash
# install GStreamer and FFmpeg
~/src/rpi-loader/part-10.sh
```

### OpenCV
This solution requires [OpenCV][33] to be used with the Raspberry Pi Camera.
First of all, hopefully its one of the [RPi Board Cameras][44].
While you could use a cheaper [USB-Webcam on the RPi][38],
you'll get none of the benefits of the Raspberry Pi's native GPU or [Graphics Processing Unit][45].

My major source of inspiration for the steps below are from:
"[Optimizing OpenCV on the Raspberry Pi][06]".

>**NOTE:** Make sure you install FFmpeg prior to the OpenCV install.
OpenCV can use the FFmpeg library as backend to record, convert and stream audio and video.
A common symptom in OpenCV of a poorly install FFmpeg is when `cv2.VideoCapture`
fails to read a file or video device.

### Step 1: Install OpenCV Dependencies
The first thing we should do is update and upgrade any existing packages,
followed by updating the Raspberry Pi firmware.

```bash
# update the raspberry pi platform
sudo apt-get update && sudo apt-get upgrade
sudo rpi-update

# if the firmware is updated, you need to reboot
sudo shutdown -r now
```

Now let install OpenCV dependency packages.

```bash
# install opencv dependency packages
sudo -H ~/src/rpi-loader/part-7.sh
```

### Step 4: Install and Compile OpenCV Source Code
We are now ready to compile and install OpenCV.
We will grab the [latest version of OpenCV][41] from GitHub and install it.
Make sure your `opencv` and `opencv_contrib` versions match up,
otherwise you will run into errors during compilation.

The script used below contains `make` [recommended flags][06]
intended to optimize the performance of OpenCV on the Raspberry Pi.
Specifically, flags to make us of Arm CPU features [NEON][07] and [VFPV3][08].
There is an expected 30% to 45% boost in performance.

>**NOTE:** We are not using `sudo` to run this script.
The tools your installing here should be owned by `pi` and not `root`.

```bash
# install and compile opencv source code
~/src/rpi-loader/part-8.sh
```

This script will run an exceptionally long time;
as long as four hours.
(This could run faster if you increase the swap space
and use `make -j` but this does have draw backs.
Read more about this [here][06].)

Provided the above steps finished without error,
and assuming your Python 3 version is 3.5.x,
OpenCV should now be installed in `/usr/local/lib/python3.5/dist-packages`
or `/usr/local/lib/python3.5/dist-packages`.
You should verify this:

```bash
# check your python 3 version
$ python3 --version
Python 3.5.3

# verify the opencv install
$ ls -l /usr/local/lib/python3.5/dist-packages/
total 3876
-rw-r--r-- 1 root staff 3968464 Sep  5 17:11 cv2.cpython-35m-arm-linux-gnueabihf.so
```

For some reason (I suspect so it doesn't clobber an existing version),
the OpenCV 3 file for Python 3+ binding may have the
name `cv2.cpython-35m-arm-linux-gnueabihf.so` (or some variant of)
rather than simply `cv2.so` like  it should.
This needs to be fixed:

```bash
# enter the target directory
cd /usr/local/lib/python3.5/dist-packages/

# rename the file
sudo mv cv2.cpython-35m-arm-linux-gnueabihf.so cv2.so

# sym-link our opencv bindings into the cv virtual environment for python 3.5
cd ~/src/cv_env/lib/python3.5/dist-packages/
ln -s /usr/local/lib/python3.5/dist-packages/cv2.so cv2.so
```

### Step 5: Test OpenCV 3 Install
To validate the install of OpenCV and its binding with Python3,
open up a new terminal,
and then attempt to import the Python + OpenCV bindings:

```bash
$ python3
Python 3.5.3 (default, Jan 19 2017, 14:11:04)
[GCC 6.3.0 20170124] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import cv2
>>> cv2.__version__
'3.3.0'
>>>
```

SLEEP......wait until it opens otherwise it fails!!
* [A Comprehensive Guide to Installing and Configuring OpenCV 2.4.2 on Ubuntu](http://www.ozbotz.org/opencv-installation/)
* [Compile OpenCV (and ffmpeg) on Ubuntu Linux](http://www.wiomax.com/compile-opencv-and-ffmpeg-on-ubuntu/)
* [Installing OpenCV 2.3.1 with FFmpeg on 64-bit Ubuntu](http://vinayhacks.blogspot.com/2011/11/installing-opencv-231-with-ffmpeg-on-64.html)
* [Installing OpenCV on Debian Linux](https://indranilsinharoy.com/2012/11/01/installing-opencv-on-linux/)
* [FFmpeg Compilation Guide](https://trac.ffmpeg.org/wiki/CompilationGuide)

```python
import cv2
import platform

print('Python Version =', platform.python_version())
print('OpenCV Version =', cv2.__version__)

# read data from device /dev/video0
video = cv2.VideoCapture(0)

if video.isOpened():
    while True:
        check, frame = video.read()
        if check:
            cv2.imshow('Color Frame', frame)
            key = cv2.waitKey(50)
            if chr(key & 255) == 'q' or key == 27:   # break on 'q' or esc key
                break
        else:
            print('Frame not available')
            print(video.isOpened())

# close your display window
video.release()
cv2.destroyAllWindows()
```

Appears that OpenCV 3.3.0 has been successfully installed
on Raspberry Pi 3 + Python 3.5 environment.

Once your absolutely sure OpenCV has been successfully installed,
you can remove both the `~/src/opencv-3.3.0` and `~/src/opencv_contrib-3.3.0`
directories to free up a bunch of space on your disk.

-----
## Building Deep Learning Tools

### Install dlib
[!dlib-logo](http://dlib.net/dlib-logo.png)
[Dlib][10] is a C++ toolkit containing machine learning,
linear algebra, image processing, optimization, and other well established algorithms.
For the installation of dlib,
I followed ["Install dlib on the Raspberry Pi"][26] and ["Install Dlib on Ubuntu"][27].
Within the first article,
you'll find a warning about common memory error your likely to encounter
when trying to compile dlib with Python bindings on your Raspberry Pi.
To over come this,
we'll need to reclaim as much available memory as possible.
You can do this by these three (temporary) steps:

1. **Increase your swap file size** by changing the line `CONF_SWAPSIZE=100`
to `CONF_SWAPSIZE=1024` in the `/etc/dphys-swapfile` file.
Now execute `sudo /etc/init.d/dphys-swapfile stop` followed by
`sudo /etc/init.d/dphys-swapfile start` (this could take a few minutes).
Confirm that your swap size has been increased with `free -m`.
1. **Switch your boot options** to boot into directly to the terminal instead of GUI.
This should be the case but `sudo raspi-config nonint do_boot_behaviour B2`
assure this on next boot up.
1. **Update your GPU/RAM split** to 16MB instead of the default allocate of 128MB the onboard GPU.
Use this command `sudo raspi-config nonint do_memory_split 16`.

>**NOTE:** See ["Install a Memory Drive as Swap for Compiling"][34]
for an alternative way to increase your swap.

Now reboot the Raspberry Pi via `sudo shutdown -r now` and
run the script to load dlib:

```bash
# install and compile dlib
sudo -H ~/src/rpi-loader/part-11.sh
```

>**NOTE:** This procedure doesn't load the C libraries for Dlib.
To address this, see the article ["Install Dlib on Ubuntu"][37].
Or does it ... since the setup.py appears to involve a long compile time.

To validate the installation of dlib:

```bash
# validate the install of dlib
$ python3 -c "import dlib ; import cv2 ; print('OpenCV Version =', cv2.__version__) ; print('Dlib Version =', dlib.__version__)"
OpenCV Version = 3.3.0
Dlib Version = 19.8.1
```

With this complete,
return the you system settings to their original state
([see warning about leaving you swap too large][17]):

```bash
# return the swap space
sudo sed -i 's/CONF_SWAPSIZE=1024/CONF_SWAPSIZE=100/' /etc/dphys-swapfile
sudo /etc/init.d/dphys-swapfile stop
sudo /etc/init.d/dphys-swapfile start

# check the swap space
free -m

# return the GPU/RAM split
sudo raspi-config nonint do_memory_split 128

# re-boot the raspberry pi
sudo shutdown -r now
```

### Building a TensorFlow Environment
TensorFlow is changing rapidly, and you might want to consider installing it from source code.
If you choose to install TensorFlow via it source code,
the source code build and test tool being used by the TensorFlow project is [Bazel][29].
Bazel, developed and supported by Google,
is an open-source build and test tool similar to [Make][32], [Maven][31], and [Gradle][30].
It uses a human-readable, high-level build language, supports projects in multiple languages,
and builds outputs for multiple platforms.

Building from source also gives you greater control of the features installed.
During the build process, you'll be provided a series of questions, as shown [here][35],
to customize your features.

I choose to do the install from the Python repository,
which is a much easier process.
While not the latest and full featured version of TensorFlow,
it does appear to be fairly complete and current.
I found where several Google folks where [cross-compiling TensorFlow for the Raspberry Pi][65]
and loading it up [TensorFlow’s Jenkins continuous integration system][66].

**What about TensorFlow Learn = TFLearn - http://tflearn.org/**

```bash
# install TensorFlow
sudo -H ~/src/rpi-loader/part-13.sh
```

To test the install, import the TensorFlow and check the version:

```bash
# print version number of tensorflow
 $ python3 -c 'import tensorflow as tf; print(tf.__version__)'
/usr/lib/python3.5/importlib/_bootstrap.py:222: RuntimeWarning: compiletime version 3.4 of module 'tensorflow.python.framework.fast_tensor_util' does not match runtime version 3.5
  return f(*args, **kwds)
/usr/lib/python3.5/importlib/_bootstrap.py:222: RuntimeWarning: builtins.type size changed, may indicate binary incompatibility. Expected 432, got 412
  return f(*args, **kwds)
RuntimeError: module compiled against API version 0xb but this version of numpy is 0xa
1.4.0
```

Note that because we are running Python 3.5 on a Wheel built for Python 3.4,
you will see a couple of warnings every time you `import tensorflow`, but it should work correctly.

Notice that [TensorBoard][39] is also loaded:

```bash
# print tensorflow relate packages
$ pip3 list --format=columns | grep tensorflow
tensorflow             1.4.0
tensorflow-tensorboard 0.1.8
```

-----
## Building the Jupyter Notebook Environment
Personally, I want a interactive and feature rich environment for doing my OpenCV work,
and I found that in [Jupyter Notebook][55] does the trick.
Just like the OpenCV package, giving a proper introduction to Jupyter Notebook
could fill multiple books, web pages, news articles, and in fact does!
Jupyter is an evolution of [Interactive Python (IPython) and its notebook][56],
but now [language agnostic and much more][54]
If you want to get a sense of the power and versatility of Jupyter Notebook,
check out the links below:

* [A gallery of interesting Jupyter Notebooks](https://github.com/jupyter/jupyter/wiki/A-gallery-of-interesting-Jupyter-Notebooks)
* [Jupyter nbviewer](http://nbviewer.jupyter.org/)
* [IPython Notebook best practices for data science](https://www.youtube.com/watch?v=JI1HWUAyJHE)

If you wish to covert the Jupyter Notebooks to another format for publishing
(ex. HTML, PDF, Markdown, and more),
they can be created by using the [nbconvert][52] utility.
Another nice fact is that Jupyter Notebook files
(i.e. `*.ipynb`) will render automatically on GitHub/Gist ([example][53])
giving you a public way to share or .

### Step 1: Install Jupyter and Supporting Packages
Installing Jupyter Notebook on your computer is documented [here][50].
For new users, they highly recommend installing it via [Anaconda][51],
but I install the individual components using this script:

```bash
# install Jupyter Notebook
sudo -H ~/src/rpi-loader/part-12.sh
```

### Step 2: Test Jupyter
Your ready now to start the Jupyter Notebook.
This can be done via several ways.
The easiest is to just enter `jupyter notebook`
in a terminal window on the Raspberry Pi
and the default browser on teh Raspberry Pi will open with Jupyter (`http://localhost:8888`).
I prefer to put the burden of running the browser on my local computer.
You can do this via running Jupyter as a server.

With this, you Jupyter environment isn't on your local computer,
but instead on a remote compute (Raspberry Pi) accessible over TCP/IP.
You want to open and manipulate an Jupyter Notebook running on the remote computer.
This can be done by [opening an SSH tunnel to the server][28].
This tunnel will forward the port used by the remotely running Jupyter Notebook server instance
to a port on your local machine,
where it can be accessed in a browser just like a locally running Jupyter Notebook instance.

On the remote machine, start the Jupyter Notebooks server:

```bash
# on the raspberry pi (remote machine), start the jupyter notebooks server
jupyter notebook --no-browser --port=8889
```

On the local machine, start an SSH tunnel:

```bash
# on you desktop linux (local machine), start an SSH tunnel
# run in background: ssh -f -N -L localhost:8888:localhost:8889 remote_user@remote_host
# run in foreground: ssh -N -L localhost:8888:localhost:8889 remote_user@remote_host
ssh -N pi@BlueRPi -L localhost:8888:localhost:8889
```

Now enter `localhost:8888` in your favorite browser on your desktop Linux (local machine)
to use the Raspberry Pi (remote machine) Jupyter Notebook.
You should see Jupyter popup in your browser.
You need to enter the token provided via the server
or a [password if you choose to set it up][19].

To test Jupyter, enter the code from the script
created earlier during the OpenCV install, `~/tmp/test_video.py`.
You should get a popup window with the Raspberry Pi camera streaming live video.
Or if you don't have a camera installed,
do something simple like the following:

```python
from IPython.display import Image

Image(url='http://api.brain-map.org/api/v2/atlas_image_download/100883869?downsample=4&annotation=true')
```

-----
# Battery Supply + Power Monitoring
[!LiFePO4wered/Pi](https://cdn.hackaday.io/images/9332751457457361166.jpg)
The [LiFePO4wered/Pi][85] (purchase on [Tindie][87])
may be the best power solution for the Raspberry Pi Zero.
It combines both the UPS and power monitoring functions into a single solution.
It also has PCB touch button that gives you clean shutdown instead of just pulling power.
A ultra-low power [MSP430G2231 microcontroller][86] monitors the battery
and also connected to the Pi's I2C bus and monitors the Pi's running state.

The designer provides a [open source software package to interact with the LiFePO4wered/Pi][88].
It contains an application development library,
a CLI interface to read/write device registers over the I2C bus,
and a tiny daemon (`lifepo4wered-daemon`) that continually tracks the power state.
The daemon can initiate a clean shutdown when the battery is empty
or the user wants to turn the RPi off using the touch button.
Touch button parameters, voltage thresholds,
and an auto boot flag can be customized by the user and saved to flash.
You can also set it up so the RPi will automatically boot whenever there is enough battery charge.
There is also a wake up timer that can be set so the Pi can shut down,
and automatically be started again after the wake timer expires.

The LiFePO4wered/Pi works fine for the Raspberry Pi Zero and 1,
but it could have difficulty maintaining a charge for a RPi 2 or 3 under load.
The  latest version, the [LiFePO4wered/18650][89] ([product brief][40]),
can hand these heavy load conditions.
You can even get a case with room for the RPi3 and the LiFePO4wered/Pi [on Tindie][90].
**Note:** Adafruit has a similar solution to the LiFePO4wered/Pi
doing a [hack of its PowerBoost 500 Charger][84].

The LiFePO4wered/Pi requires software to be running on the Raspberry Pi to operate correctly.
This software provides a daemon that automatically
manages the power state and shutdown of the RPi,
a library that allows integration of LiFePO4wered/Pi functionality in user programs,
and a CLI (command line interface) program that allows the user to
easily configure the LiFePO4wered/Pi or control it from shell scripts.

```bash
# install LiFePO4wered/Pi3 software
~/src/rpi-loader/part-14.sh
```

At this time, the blinking LiFePO4wered/Pi PWR LED should now go on solid.
If the PWR LED does not yet go on solid,
it is likely that the I2C was not yet enabled before the installer was run,
and a reboot is required.

The only necessary user interaction is with the touch button,
with feedback provided by the green PWR LED.
The LiFePO4wered/Pi touch button can be used to turn the Raspberry Pi on and off.
The touch button needs to be pressed and held to take effect.
During this press-and-hold delay, the PWR LED glow will ramp up.
During booting or shutdown,
if the user touches the button during this time,
the PWR LED will do a quick flashing sequence to
indicate it cannot comply with the user request at that time.

To make it convenient to interact with the LiFePO4wered/Pi,
the software package installed on the RPi provides a command line tool.

```bash
# get help message
lifepo4wered-cli

# get the current battery voltage
# returns the battery voltage in millivolts
lifepo4wered-cli get vbat

# get the supply voltage
# returns the  raspberry pi supply battery voltage in millivolts
lifepo4wered-cli get vout

# to set the wake time to an hour
# if you shut down the Raspberry Pi, it will wake up again in about 60 minutes
lifepo4wered-cli set wake_time 60

# Raspberry Pi to always run whenever there is power to do so
lifepo4wered-cli set auto_boot 1

# Raspberry Pi to boot whenever the USB input voltage is applied
lifepo4wered-cli set auto_boot 3
```

-----
# Other Assorted Tools (Optional)

## Building Dweet for ThingSpace
Now its time to install the People-Counter application.

Dweepy is a simple Python library for [dweet.io][23]
and modeled after the [BugLabs Javascript library][21].
The developers of Dweepy claim they have fully test it
and aims to have 100% coverage of the dweet.io API.

What we'll install here is the equivalent of Dweepy but supporting
[Verizon's ThingSpace version of dweet][22] instead of [Bub Labs dweet.io][20].
Effectively, the Dweepy library was modified to no longer point to `https://dweet.io`
and instead point to `https://thingspace.io`.

### Step 1: Install TS_Dweepy Code
The software for [`ts_dweepy` is on GitHub][09]
and this downloads it, builds the Python library,
installs it , and cleans up after itself.

>**NOTE:** We are not using `sudo` to run this script.
The tools your installing here should be owned by `pi` and not `root`.

```bash
# install ts_dweepy
~/src/rpi-loader/part-9.sh
```





* [Video - Build Tensorflow From Source in Ubuntu 16.04](https://www.youtube.com/watch?v=VebcaH_gb0c)
* [Installing TensorFlow on Raspberry Pi 3](https://github.com/samjabrahams/tensorflow-on-raspberry-pi)
* [Installing Keras with TensorFlow backend](https://www.pyimagesearch.com/2016/11/14/installing-keras-with-tensorflow-backend/)
* [Installing Tflearn on Raspberry Pi 3](http://www.instructables.com/id/Installing-Tflearn-on-Raspberry-Pi-3/)


################################################################################

* [Install guide: Raspberry Pi 3 + Raspbian Jessie + OpenCV 3](http://www.pyimagesearch.com/2016/04/18/install-guide-raspberry-pi-3-raspbian-jessie-opencv-3/)
* [OpenCV and Pi Camera Board](https://thinkrpi.wordpress.com/2013/05/22/opencv-and-camera-board-csi/)
* [OpenFace - Free and open source face recognition with deep neural networks](https://cmusatyalab.github.io/openface/)
* [Face Detection Using OpenCV With Raspberry Pi](https://www.hackster.io/deligence-technologies/face-detection-using-opencv-with-raspberry-pi-93a8fe)
* [Face Recognition: Kairos vs Microsoft vs Google vs Amazon vs OpenCV](https://www.kairos.com/blog/face-recognition-kairos-vs-microsoft-vs-google-vs-amazon-vs-opencv)

* [How to Process Live Video Stream Using FFMPEG and OpenCV](http://blog.lemberg.co.uk/how-process-live-video-stream-using-ffmpeg-and-opencv)
* [OpenCV remote (web-based) stream processing](https://github.com/ECI-Robotics/opencv_remote_streaming_processing)
* [Raspberry Pi Camera openCV rendering with low latency streaming with gstreamer via RTP](http://hopkinsdev.blogspot.com/2016/06/raspberry-pi-camera-opencv-rendering.html)


################################################################################
# Test the Camera and Install Required Python Module
Before we go any further,
we need to make sure the camera on the Raspberry Pi works.
The install instructions for the camera can bout found [here][47].
To test out the camera, just use some of the simple tools
that come with the RPi:

```bash
# test the raspberry pi camera to make sure it works
raspistill -o ~/tmp/output.jpg

# view the image captured
display ~/tmp/output.jpg
```

With the last command, you should see a picture displayed.

So we know now the Raspberry Pi camera is working properly,
but how do we interface with the Raspberry Pi camera module using Python?
To do this, we'll use [Python's picamera][48].
To do the install,
and execute the following commands:

```bash
# install picamera modual with the array sub-module
# (this may run long as python creates wheels for all packages)
pip3 install "picamera[array]"
```
The standard picamera module provides methods to interface with the camera,
but we need the array sub-module so that we can utilize OpenCV.
With our Python bindings,
OpenCV represents images as [NumPy][49] arrays
and the array sub-module enables this.

To test if the Python `picamera` module is up and working with OpenCV,
run place the code below in the file `~/tmp/test_image.py`
and execute it with `python3 ~/tmp/test_image.py`:

```python
# import the necessary packages
from picamera.array import PiRGBArray
from picamera import PiCamera
import time
import cv2

# initialize the camera and grab a reference to the raw camera capture
camera = PiCamera()
rawCapture = PiRGBArray(camera)

# allow the camera to warmup
time.sleep(0.5)

# grab an image from the camera
camera.capture(rawCapture, format="bgr")
image = rawCapture.array

# display the image on screen and wait for a keypress to kill this process
cv2.imshow("Image", image)
cv2.waitKey(0)
```

You can also test the video capabilities via the script below
(execute with `python3 ~/tmp/test_video.py`):

```python
# import the necessary packages
from picamera.array import PiRGBArray
from picamera import PiCamera
import time
import cv2

# initialize the camera and grab a reference to the raw camera capture
camera = PiCamera()
camera.resolution = (640, 480)
camera.framerate = 32
rawCapture = PiRGBArray(camera, size=(640, 480))

# allow the camera to warmup
time.sleep(0.5)

# capture frames from the camera
for frame in camera.capture_continuous(rawCapture, format="bgr", use_video_port=True):
	# grab the raw NumPy array representing the image, then initialize the timestamp
	# and occupied/unoccupied text
	image = frame.array

	# show the frame
	cv2.imshow("Frame", image)
	key = cv2.waitKey(1) & 0xFF

	# clear the stream in preparation for the next frame
	rawCapture.truncate(0)

	# if the `q` key was pressed, break from the loop
	if key == ord("q"):
		break
```

### Step 7: Uploading Test Data
OpenCV is all about processing visual images,
so your going to need test data,
potential a great deal of it, in the form of pictures and videos.
Some sources to consider are:

* Search Google for images or videos to download
* You can use the utility [`youtube-dl`][46] (may want to use the `-k` option)
to download videos from Youtube, or from nearly any website.
* [USC-SIPI image database](http://sipi.usc.edu/database/)

You can use SSH to move data from your local desktop to the Raspberry Pi.
I did this with the following commands:

```bash
# make directory for data to be uploaded (Videos and Pictures directory should already exist)
cd ~
mkdir Data

# to copy a file from your local computer to the raspberry pi, you use the following
# scp <file> <username>@<IP address or hostname>:<Destination>

# load images, video and data to the raspberry pi
scp ~/Pictures/* pi@BlueRPi:~/Pictures
scp ~/Videos/* pi@BlueRPi:~/Videos
scp ~/Data/* pi@BlueRPi:~/Data
```
################################################################################
################################################################################

### Step 2: Install People-Counter

```bash
# enter directory where people-counter will be stored
cd ~/src

# install people-counter
git clone https://github.com/jeffskinnerbox/people-counter.git
```

################################################################################


# Node Binding Using node-opencv
[node-opencv][42] is OpenCV's bindings for Node.js.


* https://github.com/drejkim/pyenv-opencv/blob/master/detection.py
* [node-opencv GitHub](https://github.com/peterbraden/node-opencv)
* [node-opencv documentation](http://peterbraden.github.io/node-opencv/)
* [Real-time face detection using OpenCV, Node.js, and WebSockets](http://drejkim.com/blog/2014/12/02/real-time-face-detection-using-opencv-nodejs-and-websockets/)
* [face-detection-node-opencv GitHub](https://github.com/drejkim/face-detection-node-opencv)

################################################################################


###############################################################################

This completes the building of the Raspberry Pi's foundational operating environment.
We can now layer on additional tools for our applications.

### Options
You might want to always use an Ethernet connection,
so you need to disable the WiFi such that it does not even turn on after a reboot.
One sure fire way to do this is to disable the WiFi drivers.
This can be done by editing the file `/etc/modprobe.d/raspi-blacklist.conf` and adding:

```bash
# disable wifi
blacklist brcmfmac
blacklist brcmutil
```

In a similar fashion, your could disable Bluetooth
by editing the file `/etc/modprobe.d/raspi-blacklist.conf` and adding:

```bash
# disable bluetooth
blacklist btbcm
blacklist hci_uart
```

Of course, WiFi can be temporally turned off via `sudo iwconfig wlan0 txpower off`,
and for Bluetooth, you can use `sudo systemctl disable hciuart`.

###############################################################################


https://downloads.raspberrypi.com/raspios_lite_arm64/images/raspios_lite_arm64-2023-10-10/2023-10-10-raspios-bookworm-arm64-lite.img.xz

[01]:https://www.52pi.com/blog/19-instructions-of-command-line-in-raspi-config
[02]:https://raspberrypi.stackexchange.com/questions/28907/how-could-one-automate-the-raspbian-raspi-config-setup
[03]:http://jeffskinnerbox.me/posts/2016/Apr/27/howto-set-up-the-raspberry-pi-as-a-headless-device/
[04]:https://lifepo4wered.com/lifepo4wered-pi.html
[05]:https://blog.robseder.com/2015/09/29/scripts-to-update-the-raspberry-pi-and-debian-based-linux-distros/
[06]:https://www.pyimagesearch.com/2017/10/09/optimizing-opencv-on-the-raspberry-pi/
[07]:https://developer.arm.com/technologies/neon
[08]:https://developer.arm.com/technologies/floating-point
[09]:https://github.com/jeffskinnerbox/ts_dweepy
[10]:http://dlib.net/
[11]:https://downloads.raspberrypi.com/raspios_lite_arm64/images/raspios_lite_arm64-2023-10-10/2023-10-10-raspios-bookworm-arm64-lite.img.xz
[12]:https://www.raspberrypi.org/downloads/raspbian/
[13]:https://www.raspberrypi.com/software/operating-systems/
[14]:http://www.amazon.com/gp/product/B00GVRHON2?psc=1&redirect=true&ref_=oh_aui_detailpage_o00_s01
[15]:http://www.wirelesshack.org/best-micro-sd-card-for-the-raspberry-pi-model-2.html
[16]:https://ozzmaker.com/check-raspberry-software-hardware-version-command-line/
[17]:https://www.bitpi.co/2015/02/11/how-to-change-raspberry-pis-swapfile-size-on-rasbian/
[18]:https://cdn-learn.adafruit.com/downloads/pdf/adafruits-raspberry-pi-lesson-5-using-a-console-cable.pdf
[19]:https://jupyter-notebook.readthedocs.io/en/stable/public_server.html
[20]:https://dweet.io
[21]:https://github.com/buglabs/dweetio-client
[22]:https://thingspace.verizon.com/develop/apis/dweet/v1/index.html
[23]:https://www.networkworld.com/article/3133738/internet-of-things/dweetio-a-simple-effective-messaging-service-for-the-internet-of-things.html
[24]:https://stackoverflow.com/questions/1471994/what-is-setup-py
[25]:https://docs.python.org/3/install/index.html
[26]:https://www.pyimagesearch.com/2017/05/01/install-dlib-raspberry-pi/
[27]:https://www.learnopencv.com/install-dlib-on-ubuntu/
[28]:https://coderwall.com/p/ohk6cg/remote-access-to-ipython-notebooks-via-ssh
[29]:https://www.bazel.build/
[30]:https://gradle.org/
[31]:https://maven.apache.org/what-is-maven.html
[32]:https://www.gnu.org/software/make/
[33]:http://opencv.org
[34]:https://github.com/samjabrahams/tensorflow-on-raspberry-pi/blob/master/GUIDE.md#2-install-a-memory-drive-as-swap-for-compiling
[35]:https://www.tensorflow.org/install/install_sources
[36]:http://www.jeffgeerling.com/blogs/jeff-geerling/raspberry-pi-microsd-card
[37]:https://www.learnopencv.com/install-dlib-on-ubuntu/
[38]:https://www.raspberrypi.org/documentation/usage/webcams/
[39]:https://www.tensorflow.org/get_started/summaries_and_tensorboard
[40]:https://lifepo4wered.com/files/LiFePO4wered-Pi3-Product-Brief.pdf
[41]:https://github.com/opencv/opencv
[42]:https://www.npmjs.com/package/opencv
[43]:http://www.pyimagesearch.com/2017/09/04/raspbian-stretch-install-opencv-3-python-on-your-raspberry-pi/
[44]:https://www.adafruit.com/product/3099
[45]:https://en.wikipedia.org/wiki/Graphics_processing_unit
[46]:https://rg3.github.io/youtube-dl/download.html
[47]:https://thepihut.com/blogs/raspberry-pi-tutorials/16021420-how-to-install-use-the-raspberry-pi-camera
[48]:http://picamera.readthedocs.io/en/release-1.9/index.html
[49]:http://www.numpy.org/
[50]:http://jupyter.org/install.html
[51]:https://www.anaconda.com/
[52]:https://nbconvert.readthedocs.io/en/latest/
[53]:https://github.com/barbagroup/AeroPython/blob/master/lessons/01_Lesson01_sourceSink.ipynb
[54]:https://www.quora.com/What-is-the-difference-between-Jupyter-and-IPython-Notebook
[55]:http://jupyter.org/
[56]:https://ipython.org/
[57]:https://www.pyimagesearch.com/2015/03/30/accessing-the-raspberry-pi-camera-with-opencv-and-python/
[58]:https://ffmpeg.org/ffprobe.html
[59]:https://ffmpeg.org/ffplay.html
[60]:https://ffmpeg.org/ffserver.html
[61]:https://ffmpeg.org/ffmpeg.html
[62]:https://ffmpeg.org/documentation.html
[63]:http://superuser.com/questions/286675/how-to-install-ffmpeg-on-debian
[64]:http://unix.stackexchange.com/questions/242399/why-was-ffmpeg-removed-from-debian
[65]:https://petewarden.com/2017/08/20/cross-compiling-tensorflow-for-the-raspberry-pi/
[66]:http://ci.tensorflow.org/view/Nightly/job/nightly-pi-python3/86/
[67]:https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-1804
[68]:https://www.cyberciti.biz/faq/ansible-apt-update-all-packages-on-ubuntu-debian-linux/
[69]:https://www.youtube.com/watch?v=hx7DB7Iqslk
[70]:https://www.linux-magazine.com/Online/Features/Using-ARP-for-Network-Recon
[71]:https://shownotes.opensourceisawesome.com/netdiscover/
[72]:https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-1804
[73]:https://www.bleepingcomputer.com/news/security/raspberry-pi-removes-default-user-to-hinder-brute-force-attacks/
[74]:https://www.raspberrypi.com/software/
[75]:https://forums.raspberrypi.com/viewtopic.php?t=357739
[76]:https://gstreamer.freedesktop.org/
[77]:http://developers-club.com/posts/236805/
[78]:https://www.efficientip.com/what-is-dhcp-and-why-is-it-important/
[79]:https://www.avast.com/c-static-vs-dynamic-ip-addresses
[80]:http://www.jonobacon.org/2006/08/28/getting-started-with-gstreamer-with-python/
[81]:https://arashafiei.files.wordpress.com/2012/12/gst-doc.pdf
[82]:http://wiki.oz9aec.net/index.php/Gstreamer_cheat_sheet
[83]:https://roy.marples.name/projects/dhcpcd
[84]:https://blog.adafruit.com/2015/12/18/how-to-run-a-pi-zero-and-other-pis-from-a-lipo-including-low-battery-raspberry_pi-piday-raspberypi/
[85]:http://lifepo4wered.com/files/LiFePO4wered-Pi-Product-Brief.pdf
[86]:http://www.ti.com/product/msp430g2231?utm_source=GOOGLE&utm_medium=cpc&utm_term=msp430g2231&utm_campaign=MSP_MSP_US_P_E_MSP430&utm_content=c97b21ff-897a-4a49-ab05-768cbb131e72&gclid=Cj0KEQiAperBBRDfuMf72sr56fIBEiQAPFXszTBkL4s4n9_P97FxDOL0d8UuoD1Gcq1jyD1Jw38jNbIaAs8j8P8HAQ
[87]:https://lifepo4wered.com/
[88]:https://github.com/xorbit/LiFePO4wered-Pi
[89]:https://hackaday.io/project/18041-lifepo4wered18650
[90]:https://www.tindie.com/products/mjrice/enclosure-for-raspberry-pi-3-and-lifepo4weredpi/
[91]:https://www.home-assistant.io/
[92]:https://www.edgexfoundry.org/
[93]:https://opencv.org/
[94]:https://www.tensorflow.org/
[95]:https://cdn.tindiemedia.com/images/resize/NS8E-8h1An68bOqZrKHhnukm44c=/full-fit-in/2400x1600/smart/58262/products/2016-12-15T20%3A35%3A06.599Z-IMGP8966.JPG
[96]:https://www.tindie.com/products/xorbit/lifepo4weredpi3/
[97]:https://lifepo4wered.com/lifepo4wered-pi.html
[98]: https://lifepo4wered.com/files/LiFePO4wered-Pi3-Product-Brief.pdf
[99]:https://github.com/xorbit/LiFePO4wered-Pi
[100]:https://www.tindie.com/products/mjrice/enclosure-for-raspberry-pi-3-and-lifepo4weredpi3/

