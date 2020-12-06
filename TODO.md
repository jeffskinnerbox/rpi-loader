<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.5
-->

# Thing That Require Attention

-----

* High Priority
    * Consider using this model / tool for your next round of deveploment
        * [Set Up A Headless Raspberry Pi, All From Another Computer’s Command Line](https://hackaday.com/2018/11/24/set-up-a-headless-raspberry-pi-all-from-another-computers-command-line/)
        * [Headless Raspberry Pi Configuration](http://peter.lorenzen.us/linux/headless-raspberry-pi-configuration)
    * Make use of the following "Maiden Script" capabilities
        * [Finding the Raspberry Pis on the network](https://www.youtube.com/watch?v=hx7DB7Iqslk)
            * nmap -sn 192.168.1.0/24
            * sudo arp-scan 192.168.1.0/24
            * sudo arp-scan 192.168.1.0/24 | grep dc:a6:32
        * [raspberian-firstboot](https://github.com/nmcclain/raspberian-firstboot)
        * [Hardware bootstrapping with Ansible](https://opensource.com/article/19/5/hardware-bootstrapping-ansible)
        * [Safely enabling ssh in the default Raspbian Image](http://hackerpublicradio.org/eps.php?id=2356)
        * []()
    * Use Ansible
        * [Using Ansible to configure a Raspberry Pi (Home Assistant, LIRC, 433Utils, Z-Wave, etc.)](https://chester.me/archives/2019/04/using-ansible-to-configure-a-raspberry-pi-home-assistant-lirc-433utils-zwave-etc/)
        * [Starting with Ansible in Raspberry Pi](https://dev.to/project42/starting-with-ansible-in-raspberry-pi-2mhm)
        * [Ansible and Raspberry Pi](https://leonelgalan.com/2020/04/24/ansible-raspberry-pi.html)
        * [Manage your Raspberry Pi fleet with Ansible](https://opensource.com/article/20/9/raspberry-pi-ansible)
        * [Installing Ansible on the Raspberry Pi](https://www.theurbanpenguin.com/installing-ansible-on-the-raspberry-pi/)
        * [Initial Pi configuration via Ansible](https://qmacro.org/2020/04/05/initial-pi-configuration-via-ansible/)
        * [Test Ansible configuration](https://www.pidramble.com/wiki/setup/test-ansible)

* Medium Priority
    * Shouldn't the "TARGET" variable be updated via the install.sh script
    * Have the script print comments about what its doing as the packages are load.  This is particularly tneeded for `part-5.sh`.
    * Using `getopt`, pass argument for HOME, ROOT, etc.

* Low Priority
    * Use the script to make a Docker or Resin.io package.
