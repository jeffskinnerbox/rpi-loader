<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.0.1
-->


<div align="center">
<img src="http://www.foxbyrd.com/wp-content/uploads/2018/02/file-4.jpg" title="These materials require additional work and are not ready for general use." align="center">
</div>


----


# Roles

* ansible-ssh - Remove?? This Ansible playbook provides an alternative to manually preparing a server to be administered / provisioned by Ansible. Is primary function is to establish a login to be used by Ansible and the SSH keys to access that login.
* apache
* backup-user
* config-pi
* crypto-tools
* dev-env
* dotfiles
* dev-tools
* duplicati
* deploy-ssh
* docker
* login-env
* net-tools
* prerequisites
* rsnapshot
* rsnapshot-container
* static-ip
* sys-env
* ups-pi
* update
* vim-config

# Ansible Roles
To create a role using the `ansible-galaxy` command, we can simply

```bash
ansible-galaxy init <ROLE_NAME>
```

Directory Structure:
* tasks - contains the main list of tasks to be executed by the role.
* handlers - contains handlers, which may be used by this role or even anywhere outside this role.
* defaults - default variables for the role.
* vars - other variables for the role. Vars has the higher priority than defaults.
* files - contains files required to transfer or deployed to the target machines via this role.
* templates - contains templates which can be deployed via this role.
* meta - defines some data / information about this role (author, dependency, versions, examples, etc,.)

* [Ansible Roles: Directory Structure](https://blog.knoldus.com/ansible-roles-directory-structure/)
* [Ansible Roles Explained | Cheat Sheet](https://www.pluralsight.com/resources/blog/cloud/ansible-roles-explained)

