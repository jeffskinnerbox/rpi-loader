<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.0.1
-->


<div align="center">
<img src="https://raw.githubusercontent.com/jeffskinnerbox/blog/main/content/images/banners-bkgrds/work-in-progress.jpg" title="These materials require additional work and are not ready for general use." align="center" width=420px height=219px>
</div>


----


# Ansible Testing
Testing steps:

1. `yamllint`
2. `ansible-playbook --syntax-check`
3. `ansible-lint`
4. molecule test (integration)
5. `ansible-playbook --check` (against production)
6. parallel infrastucture

* [Provisioning your Raspberry Pi-4 Cluster with Ansible](https://shantanoo-desai.github.io/posts/technology/edge_cluster_provisioning_ansible/)
* [Continuous Testing with Molecule, Ansible, and GitHub Actions](https://www.youtube.com/watch?v=93urFkaJQ44)
* [Ansible 101 - Episode 7 - Molecule Testing and Linting and Ansible Galaxy](https://www.youtube.com/watch?v=FaXVZ60o8L8)

```bash
# install yaml and ansible lint tools
sudo apt-get install yamllint ansible-lint

# confirm the installation
$ ansible-lint --version
WARNING: PATH altered to include /usr/bin
ansible-lint 5.4.0 using ansible 2.12.5

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




#### Testing Ansible Roles
* [Testing Ansible roles with Molecule](https://opensource.com/article/18/12/testing-ansible-roles-molecule)

# Ansible Molecule
Molecule project is designed to aid in the development and testing of Ansible roles.

* [Rapidly Build & Test Ansible Roles with Molecule + Docker](https://www.toptechskills.com/ansible-tutorials-courses/rapidly-build-test-ansible-roles-molecule-docker/)
* [How To Test Ansible Roles with Molecule on Ubuntu 18.04](https://www.digitalocean.com/community/tutorials/how-to-test-ansible-roles-with-molecule-on-ubuntu-18-04)

# Drone
Automate Software Build and Testing
[Drone](https://www.drone.io/)
[Ansible 101 - Episode 4 - Your first real-world playbook]()



