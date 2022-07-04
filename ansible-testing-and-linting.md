<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.1
-->


<div align="center">
<img src="http://www.foxbyrd.com/wp-content/uploads/2018/02/file-4.jpg" title="These materials require additional work and are not ready for general use." align="center">
</div>


----


# Ansible Testing
Testing steps:

* `yamllint`
* `ansible-playbook --syntax-check`
* `ansible-lint`
* molecule test (integration)
* `ansilbe-playbook --check` (against production)
* parallel infrastucture

* [Provisioning your Raspberry Pi-4 Cluster with Ansible](https://shantanoo-desai.github.io/posts/technology/edge_cluster_provisioning_ansible/)
* [Continuous Testing with Molecule, Ansible, and GitHub Actions](https://www.youtube.com/watch?v=93urFkaJQ44)
* [Ansible 101 - Episode 7 - Molecule Testing and Linting and Ansible Galaxy](https://www.youtube.com/watch?v=FaXVZ60o8L8)

```bash
# install yaml lint
sudo apt install yamllint

# lint the yaml files
yamllint playbooks/*.yml playbooks/roles/*

# do syntax checking of your playbooks
ansible-playbook --syntax-check playbooks/*.yml
```

To install the latest stable release of a role from Ansible Galaxy,
you do the following:

```bash
# Source: https://github.com/nginxinc/ansible-role-nginx

# create your nginx role in the roles directory
cd  ~/src/vagrant-machines/ansible/playbooks/roles
ansible-galaxy install nginxinc.nginx

# list your global library of ansible roles
# ANSIBLE_ROLES_PATH=/home/jeff/src/ansible-roles
$ ansible-galaxy list
- nginxinc.nginx, 0.21.0

# to install nginx your playbooks/roles diectory
cd  ~/src/vagrant-machines/ansible/playbooks/roles
ansible-galaxy install nginxinc.nginx --roles-path=.

# list roles in your curent project
$ ls ~/src/vagrant-machines/ansible/playbooks/roles
mongodb/  nginxinc.nginx/  nodejs/  prerequisites/
```



```bash
# path to your globally installed roles
echo $ANSIBLE_ROLES_PATH

# list the roles installed globally
ansible-galaxy list
```

```bash
# check if the virtual machines are stated
ansible-playbook -i inventory -l nodes playbooks/ping.yml

#
vagrant status

# start the virtual machines for the cluster
vagrant up

# ping the inventory to make sure they are running
ansible-playbook -i inventory playbooks/ping.yml

# create your development envirnment with the cluster
ansible-playbook -i inventory playbooks/ping.yml
```

```bash
# run playbook to create the cluster
ansible-playbook -i inventory -l nodes playbooks/cluster.yml
```


----



