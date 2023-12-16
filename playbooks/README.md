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

* [The Right Way to reboot a host with Ansible](https://earlruby.org/2019/07/rebooting-a-host-with-ansible/)
* [Ansible: Tasks vs Roles vs Handlers](https://roelofjanelsinga.com/articles/ansible-difference-between-tasks-and-roles/)




# Playbooks
* ansible-setup - This Ansible playbook provides an alternative to manually preparing a server to be administered / provisioned by Ansible. Is primary function is to establish a login to be used by Ansible and the SSH keys to access that login.
* pi-query
* ping
* rpi-loader
* rpi-config
* rpi-default-config


# Ansible's Interactive Input `vars_prompt`
If you want your playbook to prompt the user for certain input,
you can add a [`vars_prompt`][04] section.
Prompting the user for variables lets you avoid recording sensitive data like passwords
and dealing with data that may change over time or systems.
In my case, I used it the `rpi-config.yml` playbook.
It very useful to for initializing a fresh system with things like
static IP addresses, WiFi SSID & passwords, etc.

Sources
* [Introduction to Ansible prompts and runtime variables][04]
* [Interactive input: prompts](https://docs.ansible.com/ansible/latest/user_guide/playbooks_prompts.html)




# Ansible's Commandline

## Tags
ansible-playbook offers five tag-related command-line options:
* `--tags all` - run all tasks, ignore tags (default behavior)
* `--tags tag1,tag2` - run only tasks with either the tag `tag1` or the tag `tag2`
* `--skip-tags tag3,tag4` - run all tasks except those with either the tag `tag3` or the tag `tag4`
* `--tags tagged` - run only tasks with at least one tag
* `--tags untagged` - run only tasks with no tags

## No Inventory File
There are times when you'll want to run a playbook on one or more host
independently of any `inventory` file.
This is particularly true when your setting up a host and readying it for provisioning via Ansible.
This is a handy but quirky little feature of Ansible with [some rules you must follow][05]
or it will not work properly.
It takes the form:

```bash
# passing a host name
ansible-playbook -i test-pi.local, playbook.yml

# passing a host ip address
ansible-playbook -i 192.168.1.79, playbook.yml
```

The quirky stuff is:

* The `,` (comma) after the host is important.
Without this `ansible-playbook` will think the next commandline argument is an inventory file.
* You must `hosts` to `all` in your playbook or `ansible-playbook` command will fail.

Source:
* [Running Ansible without an Inventory File][05]
* [How to run Ansible without specifying the inventory but the host directly?](https://gist.github.com/lilongen/ebc11f69ae2ba48971c77527d5c02fab)

## Print Command Output
Ordinarily, when you run an Ansible playbook,
you get a summary of the execution on the terminal but you don't generally see `stdout` output.
This is fine until you specifically want to see the output created,
say from a shell script.
The playbook `list-interfaces.yml` is specifically intended to parses the network interfaces
and lists them out so you can spot the ethernet interface.

Source:
* [How to print command output in Ansible?](https://linuxhint.com/print-command-output-ansible/)




# Predictable Network Interface Names
The classic naming schemes for network interfaces used things like "eth0", "eth1", etc.
as the operating system probed for the devices at boot up.
Since the devices respond somewhat randomly,
it might very well happen that "eth0" on one boot ends up being "eth1" on the next.
This can have serious security implications.
(For example, in firewall rules which are coded for certain naming schemes,
and which are hence very sensitive to unpredictable changing names.)

over the years, several predictable network interface naming schemes have been applied,
depending on if the interface is on-board, PCI slot, etc.
The name is a combination multiple physical/logical characteristics of the device,
and therefore, should be unique and predictable.

This has definite drawbacks.
For one thing, you can nolong count on having a "eth0" interface.
Also, a system administrator now has to check first what the local interface name is
before they can invoke commands or make changes like establishing a static IP addess for the interface.

There are ways you can disable the predictable network interface scheme.

* To over ride the predictable network interface naming schemes,
create your own manual naming scheme by defining your own [udev rules][02] file
in the `/etc/udev/rules.d` folder and set the `NAME` property for the devices.
* Tell the Linux kernel to return to the classic naming scheme by
[adding some text to the `/boot/cmdline.txt` file][03].

I choose to find a way to live with predictable network interface naming scheme.
I this its best recognize that its here to stay and I want to find ways to cope with its use.

Sources:
* [Predictable Network Interface Names](https://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/)
* [Understanding systemd’s predictable network device names](https://major.io/2015/08/21/understanding-systemds-predictable-network-device-names/)
* [Raspberry Pi 3 - eth0 wrongfully named 'enx...'](https://raspberrypi.stackexchange.com/questions/43560/raspberry-pi-3-eth0-wrongfully-named-enx)






# Step 1: Prerequisites
Along with a machine hosting Ansible,
you'll need a Raspberry Pi running a recent version of Raspbian,
and you must be able to connect to it via SSH.

Also your Ansible controller machine
must be running Linux (or Mac OS),
since Ansible does not support Windows.

## Step 1A:
## Step 1B: Install Ansible
Ansible is dead simple to install using Python’s package manager, `pip`.
You'll also need the [noninteractive ssh password utility `sshpass`][01]
to allow you to use Ansible with login/password to enter your nodes.

```bash
# using python's pip
sudo pip install ansible

# OR using Unbutu's apt-get
sudo apt install ansible

# login to ssh server with a password using a shell script
sudo apt-get install sshpass
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





```bash
# establish ssh login into the raspberry pi
ansible-playbook -i inventory -l test-pi deploy-ssh.yml -u pi --ask-pass --tags install

# configure the raspberry pi
ansible-playbook -i inventory -l test-pi rpi-config.yml --tags install
```


------


# Ansible
Ansible

#### Step 1: Installing Ansible on Ansible Server - DONE
The Ansible host computers could exist anywhere as long as they are reachable via SSH.
On your Ansible host machine,
your first step is to install Ansible and any extension you may want to use.
See `using-vagrant-docker-and-ansible.md` to understand how to do this.

#### Step 2: Copy SSH Keys to Client - DONE
Ansible primarily communicates with client computers through SSH.
While it has the ability to handle password-based SSH authentication,
using SSH keys can help to keep things simple.
(Check [here][06] if you need more information concerning SSH,
how to generate keys, using keys, etc.)

On my Ansible server, I have created a specific SSH key for Ansible work.
That key is `~/.ssh/ansible.pub`.

##### Method A: Copying Public Key Using ssh-copy-id - DONE
The simplest method to provide the SSH keys to the client computer
is to use the `ssh-copy-id` tool.
Launching from the Ansible server, the syntax is:
`ssh-copy-id username@remote_host`.
In my case:

```bash
# from my desktop computer, copying public key using ssh-copy-id
ssh-copy-id -i ~/.ssh/ansible.pub pi@home-assist

# or
ssh-copy-id -i ~/.ssh/ansible.pub pi@192.168.1.203
```

To test if this is successful,
login to your Ansible client via SSH: `pi@192.168.1.203`
and you should get in without being prompted for a password.

##### Method B: Copying Public Key Using SSH
If you do not have `ssh-copy-id` available on your computer,
but you have password-based SSH access to an account on your server,
you can upload your keys using a conventional SSH method:

```bash
# from my desktop computer, copying public key using ssh
cat ~/.ssh/ansible.pub | ssh pi@home-assist "mkdir -p ~/.ssh && touch ~/.ssh/authorized_keys && chmod -R go= ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

##### Method C: Copying Public Key Manually
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

### Step 3: Creating Hosts File - DONE
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
home-assist ansible_ssh_host=192.168.1.203 ansible_ssh_port=22 kubernetes_role=node
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



------



# Test Ansible Configuration
Ansilbe support many ad-hoc commands that can be used to manage your nodes.
You find a long list in the webpost "[How to Use Ansible: A Reference Guide][07]"
and some listed below.
Use them to test your Ansible setup so far.

```bash
# check your inventory
ansible-inventory -i inventory --list -y

# gather facts about a node
ansible home-assist -i inventory -m setup

# connectivity test, including localhost (aka controller)
ansible all -i inventory -m ping

# install the package vim on home-assist from your inventory
ansible home-assist -i inventory -m apt -a "name=vim"

# you can conduct a dry run to predict how the servers would be affected by your command
ansible home-assist -i inventory -m apt -a "name=vim" --check

# get current disk usage, including localhost (aka controller)
$ ansible all -i inventory -m shell -a "df -h"

# get current memory usage, including localhost (aka controller)
$ ansible all -i inventory -m shell -a "free -m"

# reboot all the linux hosts, but not localhost (aka controller)
$ ansible nodes -i inventory -m shell -a "sleep 1s; shutdown -r now" -b -B 60 -P 0

# shut down all the linux hosts, but not localhost (aka controller)
$ ansible nodes -i inventory -m shell -a "sleep 1s; shutdown -h now" -b -B 60 -P 0

# uptime check for individual host 'home-assist'
ansible home-assist -i inventory -a "uptime" -u root

# specify multiple hosts by separating them with colons
ansible home-assist:node-2 -i inventory -a "uptime" -u root

# install vim-nox package on home-assist
ansible home-assist -m apt -a "name=vim-nox" --become

# reboot all the raspberry pi
ansible all -i inventory -m shell -a "sleep 1s; shutdown -r now" -b -B 60 -P 0

# shut down all the raspberry pi
ansible all -i inventory -m shell -a "sleep 1s; shutdown -h now" -b -B 60 -P 0
```

To run a playbook and execute all the tasks defined within it, use the `ansible-playbook` command:

```bash
# use a playbook to install the LEMP stack on home-assist
ansible-playbook -i inventory -l home-assist tasks/lemp.yml

# to understand the impacted of a play book without making changes
ansible-playbook -i inventory -l home-assist tasks/lemp.yml --list-tasks

# Ansible will then skip anything that comes before the specified task
ansible-playbook -i inventory -l home-assist tasks/lemp.yml --start-at-task="Set Up Nginx"

# only execute tasks associated with specific tags
ansible-playbook -i inventory -l home-assist tasks/lemp.yml --tags=mysql,nginx
```

----



[01]:https://linux.die.net/man/1/sshpass
[02]:https://www.thegeekdiary.com/how-to-disable-predictable-network-interface-device-names-in-centos-rhel-7/
[03]:https://kalitut.com/change-network-interfaces-in-raspbian/
[04]:https://linuxconfig.org/introduction-to-ansible-prompts-and-runtime-variables
[05]:https://ericsysmin.com/2017/01/29/running-ansible-without-an-inventory-file/
[06]:https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-1804
[07]:https://www.digitalocean.com/community/cheatsheets/how-to-use-ansible-cheat-sheet-guide

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



