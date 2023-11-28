<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.1
-->


<div align="center">
<img src="https://raw.githubusercontent.com/jeffskinnerbox/blog/main/content/images/banners-bkgrds/work-in-progress.jpg" title="These materials require additional work and are not ready for general use." align="center" width=420px height=219px>
</div>


----


In this example, we are going to write an Ansible role to configure the Apache HTTP server.

* [Ansible: Write Ansible role to configure apache webserver](https://faun.pub/ansible-write-ansible-role-to-configure-apache-webserver-9c08aaf66528)
* [How to Use Ansible to Install and Set Up Apache on Ubuntu 18.04](https://www.digitalocean.com/community/tutorials/how-to-use-ansible-to-install-and-set-up-apache-on-ubuntu-18-04)
* [How To Install/Uninstall Apache Using Ansible PlayBook](https://aspsqltutorials.blogspot.com/2019/10/how-to-install-apache-using-ansible.html)

# Inventory Files
* [How to create dynamic inventory files in Ansible](https://www.redhat.com/sysadmin/ansible-dynamic-inventories)

# Ad hoc Commands
The possibility to run ad hoc commands for quick (and dirty) tasks
accross a large set of machines is one of the reasons to use Ansible.
You can use these commands to gather information when you need them
or to get things done without the need to write a playbook first.

```bash
# query package version
ansible all -m command -a'/usr/bin/rpm -qi <PACKAGE NAME>' | grep 'SUCCESS\|Version'

# query OS-Release
ansible all -m command -a'/usr/bin/cat /etc/os-release'

# query running kernel version
ansible all -m command -a'/usr/bin/uname -r'

# query DNS servers in use by nodes
ansible all -m command -a'/usr/bin/cat /etc/resolv.conf' | grep 'SUCCESS\|nameserver'
```

#### Step 0: Install Your Ansible Tools

#### Step 1: Create Ansible Role Folder
Roles let you automatically load related `vars_files`, `tasks`, `handlers`,
and other Ansible artifacts based on a known file structure.
Grouping your content in the roles file structure makes it easer to reuse them and share them with other users.

>**NOTE:** An Ansible role has a defined directory structure with eight main standard directories.
You must include at least one of these directories in each role.
You can omit any directories the role does not use.
See the Ansible documentation: [Ansible Role directory][01] for more information.

```bash
# create roles directory
mkdir roles
cd roles

# create ansible role folder
ansible-galaxy init apache-http-server
```

It will often be the case you'll want to directly install an existing
Ansible Galaxy role into your porjects `roles/` directory.
In my case, I want to use the community supported [`geerlingguy.apache`][02].
If you run `ansible-galaxy install geerlingguy.apache`,
the role will get installed into `~/.ansible/roles` or `/usr/share/ansible/roles`.
To located in my directory structure, I'll need to use the `-p` flag.

```bash
# install roles to your personal directory, not globally
cd ~/src/linux-tools/rpi-loader/playbooks
ansible-galaxy install -p ./roles geerlingguy.apache
```


Whether to install (present or installed, latest), or remove (absent or removed) a package.
* present and installed will simply ensure that a desired package is installed.
* latest will update the specified package if it’s not of the latest available version.
* absent and removed will remove the specified package.

Default is None, however in effect the default action is present unless the autoremove option is enabled for this module, then absent is inferred.

Choices: absent installed latest present removed




[01]:https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html#role-directory-structure
[02]:https://galaxy.ansible.com/geerlingguy/apache
