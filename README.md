<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.0.1
-->


<div align="center">
<img src="http://www.foxbyrd.com/wp-content/uploads/2018/02/file-4.jpg" title="These materials require additional work and are not ready for general use." align="center">
</div>


----


The main purpose of this GitHub repository is the maintenance of several Ansible Playbooks & Roles
to be used in the creation of a Raspberry Pi test environment I call `test-pi`.
`test-pi` is currently a [Raspberry Pi 3 Model B Rev 1.2][01]
along with a Uninterruptible Power Supply (UPS) [LiFePO4wered/Pi3][02].
I'm using the `test-pi` as a testbed for the creation of Raspberry Pi based devices.

Playbooks:
* ping.yml - usage is `ansible-playbook -i inventory ping.yml` (functionally equivalent to `ansible all -i inventory -m ping`)
* rpi-default-config.yml
* setup-ansible.yml
* pi-query.yml
* rpi-config.yml
* rpi-loader.yml
* static-ip.yml

```bash
# Reboot all the Pis.
$ ansible all -i inventory -m shell -a "sleep 1s; shutdown -r now" -b -B 60 -P 0

# Shut down all the Pis.
$ ansible all -i inventory -m shell -a "sleep 1s; shutdown -h now" -b -B 60 -P 0
```



[01]:https://www.raspberrypi.com/products/raspberry-pi-3-model-b/
[02]:https://lifepo4wered.com/lifepo4wered-pi3.html

