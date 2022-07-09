<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.0.1
-->


<div align="center">
<img src="http://www.foxbyrd.com/wp-content/uploads/2018/02/file-4.jpg" title="These materials require additional work and are not ready for general use." align="center">
</div>


----



* [How to use Ansible for setting up a Raspberry Pi Zero W Web Server with PHP 7](http://www.heidislab.com/tutorials/using-ansible-to-set-up-a-raspberry-pi-zero-w-as-php-7-web-server)

* [raspi-ansible](https://github.com/codingmamalabs/raspi-ansible)
* [ansible-raspi-config](https://github.com/giuaig/ansible-raspi-config)

* [Installing Ansible (Raspberry Pi)](https://geektechstuff.com/2019/06/25/installing-ansible-raspberry-pi/)
* [Ansible Setting Up SSH (Raspberry Pi)](https://geektechstuff.com/2019/06/27/ansible-setting-up-ssh-raspberry-pi/)
* [Ansible – Looking at commands & Playbooks (Raspberry Pi)](https://geektechstuff.com/2019/06/27/ansible-looking-at-commands-playbooks-raspberry-pi/)




# Step 1: Prerequisites
Along with a machine hosting Ansible,
you'll need a Raspberry Pi running a recent version of Raspbian,
and you must be able to connect to it via SSH.

Also your Ansible controller machine
must be running Linux (or Mac OS),
since Ansible does not support Windows.

## Step 1A:
## Step 1B: Install Ansible
Ansible is dead simple to install using Python’s package manager, pip.
Just run:

```bash
# using python's pip
sudo pip install ansible

# OR using Unbutu's apt-get
sudo apt install ansible
```

With that you’re ready with Ansible on your local machine.

## ???
```bash
# check which version of Ansible is installed
$ ansible --version
ansible 2.7.8
  config file = /home/jeff/src/rpi-loader/ansible/ansible.cfg
  configured module search path = ['/home/jeff/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.7.3 (default, Oct  7 2019, 12:56:13) [GCC 8.3.0]
```

Ansible has a hosts file located at `/etc/ansible/hosts`
and this is an inventory of the remote hosts that you want Ansible to look after.

```bash
# see if ansible can correctly read the hosts file by doing a ping to each host
ansible GROUP_HEADING -m ping
```



lmost done! Now all you have to do is run this command to create that Droplet.
ansible-playbook newdroplet.yml -c local -i localhosts

And just like that, you deployed a Droplet on Digital Ocean using Ansible. You can test it’s existence by doing the following command.
ansible -m ping -u root -i dohosts all

Complete Guide to Set Up Raspberry Pi Without a Keyboard and Mouse - https://sendgrid.com/blog/complete-guide-set-raspberry-pi-without-keyboard-mouse/


### Step 1: Download Raspberry Pi Image
Before you can load a copy of the latest Raspberry Pi image onto your micro SD Card,
you must first download the official Raspberry Pi operating system, [Raspbian][13]
(in my case, the version is [Stretch][11]).
You can get that download [here][12].

>**NOTE:** I installed Raspbian Buster Lite
>(Version:September 2019, Release date:2019-09-26, Kernel version:4.19)

The Raspbian download site also lists a check sum for the download file.
(In my case, I down loaded the Raspbian file to `/home/jeff/Downloads/`.)
Check whether the file has been changed from its original state
by checking its digital signature (SHA1 hash value).

```bash
# validate file is uncorrupted via check of digital signature
$ sha256sum 2019-09-26-raspbian-buster-lite.zip
64c4103316efe2a85fd2814f2af16313abac7d4ad68e3d95ae6709e2e894cc1b 2019-09-26-raspbian-buster-lite.zip
```

Next you need to unzip the file to retrieve the Linux image file:

```bash
$ unzip 2019-09-26-raspbian-buster-lite.zip
Archive:  2019-09-26-raspbian-buster-lite.zip
  inflating: 2019-09-26-raspbian-buster-lite.img
```

### Step 2: Write Raspberry Pi Image to SD Card - DONE
Next using Linux, you have copied the Raspbian image onto the SD card mounted to your system.
I'll be using the [Rocketek 11-in-1 4 Slots USB 3.0 Memory Card Reader][14] to create my SD Card.
Make sure to [choose a reputable SD Card][15] from [here][24], don't go cheap.

When using your card reader,
you'll need to know the device name of the reader.
The easiest way to find this is just unplug your card reader from the USB port,
run `df -h`, then plug it back in, and run `df -h` again.

```bash
# with the SD card reader unplugged
$ df -h
Filesystem      Size  Used Avail Use% Mounted on
udev            7.8G     0  7.8G   0% /dev
tmpfs           1.6G  2.1M  1.6G   1% /run
/dev/sda3       110G   61G   44G  59% /
tmpfs           7.8G  833M  7.0G  11% /dev/shm
tmpfs           5.0M  8.0K  5.0M   1% /run/lock
tmpfs           7.8G     0  7.8G   0% /sys/fs/cgroup
/dev/loop3      157M  157M     0 100% /snap/gnome-3-28-1804/110
/dev/loop0       43M   43M     0 100% /snap/gtk-common-themes/1313
/dev/loop5       55M   55M     0 100% /snap/core18/1279
/dev/loop1      3.8M  3.8M     0 100% /snap/gnome-system-monitor/111
/dev/loop4       90M   90M     0 100% /snap/core/8213
/dev/loop6      141M  141M     0 100% /snap/gnome-3-26-1604/97
/dev/loop17      15M   15M     0 100% /snap/gnome-characters/367
/dev/loop13     1.0M  1.0M     0 100% /snap/gnome-logs/81
/dev/loop8      1.0M  1.0M     0 100% /snap/gnome-logs/73
/dev/loop16     157M  157M     0 100% /snap/gnome-3-28-1804/91
/dev/loop12     141M  141M     0 100% /snap/gnome-3-26-1604/98
/dev/loop9       45M   45M     0 100% /snap/gtk-common-themes/1353
/dev/loop15     4.3M  4.3M     0 100% /snap/gnome-calculator/536
/dev/loop10     4.3M  4.3M     0 100% /snap/gnome-calculator/544
/dev/sda1       461M  117M  321M  27% /boot
/dev/md0        917G  254G  617G  30% /home
/dev/sdb        3.6T  473G  3.0T  14% /mnt/backup
tmpfs           1.6G   64K  1.6G   1% /run/user/1000
/dev/loop18      90M   90M     0 100% /snap/core/8268
/dev/loop2       55M   55M     0 100% /snap/core18/1288
/dev/loop11     3.8M  3.8M     0 100% /snap/gnome-system-monitor/123
/dev/loop19      15M   15M     0 100% /snap/gnome-characters/375

# with the SD card reader plugged in USB
$ df -h
Filesystem      Size  Used Avail Use% Mounted on
udev            7.8G     0  7.8G   0% /dev
tmpfs           1.6G  2.1M  1.6G   1% /run
/dev/sda3       110G   61G   44G  59% /
tmpfs           7.8G  833M  7.0G  11% /dev/shm
tmpfs           5.0M  8.0K  5.0M   1% /run/lock
tmpfs           7.8G     0  7.8G   0% /sys/fs/cgroup
/dev/loop3      157M  157M     0 100% /snap/gnome-3-28-1804/110
/dev/loop0       43M   43M     0 100% /snap/gtk-common-themes/1313
/dev/loop5       55M   55M     0 100% /snap/core18/1279
/dev/loop1      3.8M  3.8M     0 100% /snap/gnome-system-monitor/111
/dev/loop4       90M   90M     0 100% /snap/core/8213
/dev/loop6      141M  141M     0 100% /snap/gnome-3-26-1604/97
/dev/loop17      15M   15M     0 100% /snap/gnome-characters/367
/dev/loop13     1.0M  1.0M     0 100% /snap/gnome-logs/81
/dev/loop8      1.0M  1.0M     0 100% /snap/gnome-logs/73
/dev/loop16     157M  157M     0 100% /snap/gnome-3-28-1804/91
/dev/loop12     141M  141M     0 100% /snap/gnome-3-26-1604/98
/dev/loop9       45M   45M     0 100% /snap/gtk-common-themes/1353
/dev/loop15     4.3M  4.3M     0 100% /snap/gnome-calculator/536
/dev/loop10     4.3M  4.3M     0 100% /snap/gnome-calculator/544
/dev/sda1       461M  117M  321M  27% /boot
/dev/md0        917G  254G  617G  30% /home
/dev/sdb        3.6T  473G  3.0T  14% /mnt/backup
tmpfs           1.6G   68K  1.6G   1% /run/user/1000
/dev/loop18      90M   90M     0 100% /snap/core/8268
/dev/loop2       55M   55M     0 100% /snap/core18/1288
/dev/loop11     3.8M  3.8M     0 100% /snap/gnome-system-monitor/123
/dev/loop19      15M   15M     0 100% /snap/gnome-characters/375
/dev/sdf2       1.8G  1.1G  634M  64% /media/jeff/rootfs
/dev/sdf1        41M   41M   512 100% /media/jeff/0298-4814
```

Note that in my example above, the new device is `/dev/sdf1` and `/dev/sdf2`.
The last part (the number 1) is the partition number
but we want to write to the whole SD card, not just one partition.
Therefore you need to remove that part when creating the image.
With this information, and know the location of the Raspbian image and
where we need to write the Raspbian image to the SD Card
(see more detail instructions [here][16]).

```bash
# go to directory with the RPi image
cd ~/Downloads/Raspbian

# unmount the sd card reader
sudo umount /dev/sdf1 /dev/sdf2

# write the image to the sd card reader
sudo dd bs=4M if=2019-09-26-raspbian-buster-lite.img of=/dev/sdf

# ensure the write cache is flushed
sudo sync

# (optional) check the integrity of the sd card image
sudo dd bs=4M if=/dev/sdf of=copy-from-sd-card.img
sudo truncate --reference 2019-09-26-raspbian-buster-lite.img copy-from-sd-card.img
diff -s 2019-09-26-raspbian-buster-lite.img copy-from-sd-card.img
```

Remove SD card reader on your computer and then reinstall it.
We’re going to set up the network interfaces next.

>**NOTE:** You could immediately put the SD Card in the RPi and boot it up,
>but you will have no WiFi access and you'll need to use the Ethernet interface,
>or if there is no Ethernet interface,
>you'll need to use a console cable to make the file modification
>outline in the next step.
>[Adafruit has good description on how to use a console cable][17]
>and the how to [enable the UART for the console][18].

### Step 3: Setup Networking - DONE
We now we need to setup
the hostname and networking features for the Raspberry Pi.
We do this by creating this file in

Using your card reader wuth the SD Card install,
plug it back into a USB port and find the file
`/media/jeff/rootfs/etc/network/interfaces`
modify this network interfaces file to look like this:

```bash
# Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
# Version:      0.5


# interfaces(5) file used by ifup(8) and ifdown(8)

# PLEASE NOTE that this file is written to be used with dhcpcd
# For static IP, consult /etc/dhcpcd.conf and 'man dhcpcd.conf'
# Also see https://raspberrypi.stackexchange.com/questions/39785/dhcpcd-vs-etc-network-interfaces


# include files from /etc/network/interfaces.d
source-directory /etc/network/interfaces.d

# The loopback network interface
auto lo
iface lo inet loopback

# establish ethernet (wired) network interface
iface eth0 inet manual

# establish wifi connection for embedded wifi
allow-hotplug wlan0
iface wlan0 inet manual
    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf

# establish wifi connection for dongle
allow-hotplug wlan1
iface wlan1 inet manual
    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
```

Next, you modify your `/media/jeff/rootfs/etc/wpa_supplicant/wpa_supplicant.conf`
WiFi file to look like this:


```bash
# Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
# Version:      0.5

# country code environment variable, required for RPi 3
country=US

# path to the ctrl_interface socket and the user group
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev

# allow wpa_supplicant to overwrite configuration file whenever configuration is changed
update_config=1

# 1 = wpa_supplicant initiates scanning and AP selection ; 0 = driver takes care of scanning
ap_scan=1

# home wifi network settings
network={
    id_str="home"                   # needs to match keyword you used in the interfaces file
    ssid="<home-ssid>"              # SSID either as an ASCII string with double quotation or as hex string
    mode=0                          # 0 = managed, 1 = ad-hoc, 2 = access point
    scan_ssid=0                     # = 1 do not broadcast SSID ; = 0 SSID is visible to scans
    proto=WPA RSN                   # list of supported protocals; WPA = WPA ; RSN = WPA2 (also WPA2 is alias for RSN)
    key_mgmt=WPA-PSK WPA-EAP        # list of authenticated key management protocols (WPA-PSK, WPA-EAP, ...)
    psk="<home-password>"           # pre-shared key used in WPA-PSK mode ; 8 to 63 character ASCII passphrase
    pairwise=CCMP                   # accepted pairwise (unicast) ciphers for WPA (CCMP, TKIP, ...)
    auth_alg=OPEN                   # authentication algorithms (OPEN, ShARED, LEAP, ...)
    priority=3                      # priority of selecting network (larger numbers are higher priority)
}

# jetpack wifi network settings
network={
    id_str="jetpack"                # needs to match keyword you used in the interfaces file
    ssid="<jetpack-ssid>"           # SSID either as an ASCII string with double quotation or as hex string
    mode=0                          # 0 = managed, 1 = ad-hoc, 2 = access point
    scan_ssid=0                     # = 1 do not broadcast SSID ; = 0 SSID is visible to scans
    proto=WPA RSN                   # list of supported protocals; WPA = WPA ; RSN = WPA2 (also WPA2 is alias for RSN)
    key_mgmt=WPA-PSK WPA-EAP        # list of authenticated key management protocols (WPA-PSK, WPA-EAP, ...)
    psk="<jetpack-password>"        # pre-shared key used in WPA-PSK mode ; 8 to 63 character ASCII passphrase
    pairwise=CCMP                   # accepted pairwise (unicast) ciphers for WPA (CCMP, TKIP, ...)
    auth_alg=OPEN                   # authentication algorithms (OPEN, ShARED, LEAP, ...)
    priority=5                      # priority of selecting network (larger numbers are higher priority)
}
```

### Step 4: Setup Hostname - DONE
If you want to change the hostname, do the following:

```bash
sudo sed -i 's/raspberrypi/berrygps/' /media/jeff/rootfs/etc/hosts
sudo sed -i 's/raspberrypi/berrygps/' /media/jeff/rootfs/etc/hostname
```

### Step 5: Enable SSH on Raspberry Pi - DONE
SSH is disabled by default in Raspberry Pi,
hence you’ll have to enable it when you turn on the Pi after a fresh installation of Raspbian.
SSH can be enabled by placing a file named `ssh`, without any extension,
onto the boot partition of the SD card.

```bash
# SSH can be enabled by placing a file named "ssh", without any extension,
# onto the boot partition of the SD card.
touch /media/jeff/boot/ssh
```

>**NOTE:** I'm not sure, but I believe this little trick
>only works on the first boot of the Raspberry Pi.

Now unmount the SD Card and move to the next step.

```bash
# unmount the sd card reader
sudo umount /dev/sdf1 /dev/sdf2
```

# Step 6: Finding Your Raspberry Pi IP Address - DONE
Next we'll power up the RPi Zero, but first,
lets check what IP address are being used on our WiFi network.
Place the SD-Card into the Raspberry Pi, power it up,
and login via ssh via WiFi or via Ethernet.

I will be run this Raspberry Pi headless,
and that can make login into them via `ssh` a challenge.
A typical secinario is you power up the device
and the interaction you have is this:

```bash
# attempting to log into a headless raspberry pi
$ ssh -X pi@berrygps
ssh: Could not resolve hostname berrygps: Temporary failure in name resolution
```

I'm quite sure DHCP has assigned an IP Address but DNS is failing to resolver the hostname `raspeberry`.
This will typically be resolved by DNS, but it never happens quick enough for me.
A simple trick to find your RPi is to `nmap` scan your network for open port 22,
the port supporting SSH, which must be open on the Raspberry Pi.

```bash
# scan for open port 22 on your network BEFORE powering up the rpi
$ nmap -T5 -n -p 22 --open 192.168.1.0/24 | grep "Nmap scan" | awk '{ print $5 }'
192.168.1.13
192.168.1.200
192.168.1.250

# scan for open port 22 on your network AFTER powering up the rpi
192.168.1.13
192.168.1.200
192.168.1.230
192.168.1.250
```

So the Raspberry Pi is amount this list of IP Addresses,
but I still have to decide which of the port-22-open devices is the RPi.

But there’s an even quicker way, that’s also more precise.
It turns out the Raspberry Pi Foundation actually has a range of MAC addresses all to themselves!
These ranges will have a prefix assigned, the [Organizationally Unique Identifiers (OUI)][76],
for the Ethernet or WiFi network interface on the Raspberry Pis.
The best resource to find the most current OUI assignments
is from the [MAC Address Block Large (MA-L) Public Listing at the IEEE][78].
A complete list of OUI assignments is compiled daily and is available [here][77].

According to this list there is a single OUI/MA-L assignment for the Raspberry Pi Foundation:

```
DC-A6-32   (hex)		Raspberry Pi Trading Ltd
				        Maurice Wilkes Building, Cowley Road
				        Cambridge    CB4 0DS
				        GB
```

But I also often use WiFi dongles from Edimax on my Raspberry Pis.
A search of the [OUI/MA-L assignment list][19] provides:

```
00-1F-1F   (hex)		Edimax Technology Co. Ltd.
00-50-FC                No. 278, Xinhu 1st Road
00-0E-2E                Taipei City  Neihu Dist  248
00-00-B4                TW
08-BE-AC
74-DA-38
80-1F-02

```

So `arp -a` can dump the candidate devices IP Addresses via this command:

```bash
# list of Edimax devices with open port 22 on your network
$ arp -a | grep -e 00:1f:1f -e 00:50:fc -e 00:0e:2e -e 00:00:b4 -e 08:be:ac -e 74:da:38 -e 80:1f:02

? (192.168.1.230) at 74:da:38:70:1c:08 [ether] on eth0
```

>**NOTE:** Sometimes the arp table has old cashed IP Addresses which are not live devices.
>See the article ["How to clear ARP cache on Linux or Unix"][79]
>to understand how to flush this cache.

So, we can now log into the Raspberry Pi via `ssh -X pi@berrygps` or `ssh -X pi@b192.168.1.230`.



[11]:https://www.raspberrypi.org/blog/raspbian-stretch/
[12]:https://www.raspberrypi.org/downloads/raspbian/
[13]:https://www.raspbian.org/
[14]:http://www.amazon.com/gp/product/B00GVRHON2?psc=1&redirect=true&ref_=oh_aui_detailpage_o00_s01
[15]:http://www.wirelesshack.org/best-micro-sd-card-for-the-raspberry-pi-model-2.html
[16]:https://www.raspberrypi.org/documentation/installation/installing-images/linux.md
[17]:https://www.bitpi.co/2015/02/11/how-to-change-raspberry-pis-swapfile-size-on-rasbian/
[18]:https://cdn-learn.adafruit.com/downloads/pdf/adafruits-raspberry-pi-lesson-5-using-a-console-cable.pdf


[24]:http://www.jeffgeerling.com/blogs/jeff-geerling/raspberry-pi-microsd-card


[76]:https://en.wikipedia.org/wiki/Organizationally_unique_identifier
[77]:http://standards.ieee.org/develop/regauth/oui/public.html
[78]:https://standards.ieee.org/products-services/regauth/oui/index.html



