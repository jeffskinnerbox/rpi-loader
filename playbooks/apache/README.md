<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.0.1
-->


<div align="center">
<img src="http://www.foxbyrd.com/wp-content/uploads/2018/02/file-4.jpg" title="These materials require additional work and are not ready for general use." align="center">
</div>


----


# Apach2 Playbook
This is based on
[Ansible Playbook to Install and Setup Apache on Ubuntu](https://linoxide.com/ansible-playbook-to-install-and-setup-apache-on-ubuntu/)
[How to Use Ansible to Install and Set Up Apache on Ubuntu 18.04](https://www.digitalocean.com/community/tutorials/how-to-use-ansible-to-install-and-set-up-apache-on-ubuntu-18-04)
[Ansible: Write Ansible role to configure apache webserver](https://faun.pub/ansible-write-ansible-role-to-configure-apache-webserver-9c08aaf66528)


I want to structure my Ansible playbooks
where I can do some action and undo them (I can install or remove same packages; place file or remove this file).
I have seen examples ([here][01])
where two Ansible playbooks are used: `delete.yml` and `install.yml`.
I have seen another design ([here][02]) where `tags` are also used within these files.

[Ansible: Tasks vs Roles vs Handlers](https://roelofjanelsinga.com/articles/ansible-difference-between-tasks-and-roles/)


# Checking Ansible Playbooks
>**NOTE:** Always remember to do this checking before you run your Ansible playbook.
>Doing so lets you avoid accidentally messing things up with your project.

Lint the files

These commands ignore tags

```bash
cd ~/src/linux-tools/rpi-loader/playbooks

yamllint test-apache

ansible-lint test-apache/apache.yml

ansible-playbook -i ../inventory test-apache/apache.yml --syntax-check
```

* [Ansible tips’n’tricks: run select parts of a playbook using tags](https://martincarstenbach.wordpress.com/2021/02/22/ansible-tipsntricks-run-select-parts-of-a-playbook-using-tags/)
* [Ansible Playbook Dry Run: Run Playbook in "Check Mode"](https://phoenixnap.com/kb/ansible-playbook-dry-run)

```bash
# list tags in a playbook
ansible-playbook -i inventory playbooks/test-apache/apache.yml --list-tags

# perfrom an install
ansible-playbook -i inventory playbooks/test-apache/apache.yml --tags install

# perfrom an uninstall
ansible-playbook -i inventory playbooks/test-apache/apache.yml --tags uninstall
```

https://phoenixnap.com/kb/ansible-playbook-dry-run#:~:text=The%20easiest%20way%20to%20do,but%20on%20a%20playbook%20level.

# Ansible Check Mode (“Dry Run”)
Using Ansible’s dry run feature enables users to execute a playbook without making changes to the servers. It uses the built-in check mode to proof a playbook for errors before execution.
This produces the same output as actually running the playbook, except it will report on changes it would have made rather than making them.

The easiest way to do a dry run in Ansible is to use the check mode. This mode works like the `--syntax-check` command, but on a playbook level.
This produces the same output as actually running the playbook, except it will report on changes it would have made rather than making them.

Using the `--diff` flag with the `ansible-playbook` command reports what changes were made while executing the playbook.
Combining the `--check` and `--diff` flags with the `ansible-playbook` command gives you a more detailed overview of all the changes made by your playbook:


```bash
ansible-playbook -i ../inventory test-apache/apache.yml --check --tags install
ansible-playbook -i ../inventory test-apache/apache.yml --check --diff --tags install
```

>**NOTE:** Using the dry run feature is useful one node at a time
>and for basic configuration management.
>If your playbook contains conditional or result-based tasks,
>it won’t work in check mode.
>This is because the conditions for those tasks can’t be satisfied without
>actually executing the playbook and making changes.

* [Understanding Ansible’s check_mode](https://medium.com/opsops/understanding-ansibles-check-mode-299fd8a6a532)
* [Ansible Check Mode Tips](https://engineering.nordeus.com/ansible-check-mode-tips/)

# Preventing Ansible Playbook from Stopping Executing Tasks
while you execute the playbook, Ansible may receive a non-zero return code from a command,
or a failure from a module stopping the playbook from executing further.
To prevent the failures of stopping other tasks from executing, consider using the [error handling][11] feature in the Ansible playbook. Error handling allows you to operate even when any task fails using [rescue and always functions][12] and the output you want.

# Test
* [How To Set Up Apache Virtual Hosts on Ubuntu 20.04](https://www.digitalocean.com/community/tutorials/how-to-set-up-apache-virtual-hosts-on-ubuntu-20-04)

google-chrome http://192.168.1.79:80



[01]:https://mykidong.medium.com/howto-organize-ansible-playbook-to-install-uninstall-start-and-stop-kafka-and-kafka-connect-e7250c5def9d
[02]:https://aspsqltutorials.blogspot.com/2019/10/how-to-install-apache-using-ansible.html
[03]:
[04]:
[05]:
[06]:
[07]:
[08]:
[09]:
[10]:
[11]:https://docs.ansible.com/ansible/latest/user_guide/playbooks_error_handling.html
[12]:https://docs.ansible.com/ansible/latest/user_guide/playbooks_blocks.html#handling-errors-with-blocks
[13]:
[14]:
[15]:
[16]:
[17]:
[18]:
[19]:
[20]:
