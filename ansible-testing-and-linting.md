<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.1
-->


<div align="center">
<img src="http://www.foxbyrd.com/wp-content/uploads/2018/02/file-4.jpg" title="These materials require additional work and are not ready for general use." align="center">
</div>


----

**Linting:** It is the process of scanning code for potential errors or violation of coding conventions.
The lint scans your code against some rules and provides you an analysis report but the corrections must be done manually.

## YAML
Ansible playbooks are written in [YAML][27]
because it is easier for humans to read & write than other common data formats like XML or JSON.
YAML is a [data serialisation language][26],
it’s a strict superset of JSON,
but with the addition of syntactically significant newlines and indentation, like Python.
Unlike Python, however, YAML doesn’t allow literal tab characters for indentation.

* [YAML best practices for Ansible playbooks - tasks](https://www.jeffgeerling.com/blog/yaml-best-practices-ansible-playbooks-tasks)

### Lint Tools

**`yamllint`**
* A linter for YAML files - `sudo apt-get install yamllint`
* [A linter for YAML files](https://github.com/adrienverge/yamllint)
* [yamllint documentation](https://yamllint.readthedocs.io/en/stable/)

**`ansible-lint`**
The `ansible-lint` command is a linter designed specifically for Ansible playbooks.
`ansible-lint` goes beyond regular YAML linters by checking Ansible tasks themselves.
This potentially saving you from execution errors and debugging time.

We can custom configure `ansible-lint` for your requirement.
Apart from the default rules, we can specify additional rules in a file,
and the command-line flag `-c <file path>` will lint the playbook based on the custom configuration.

* [Ansible Lint Documentation](https://ansible-lint.readthedocs.io/en/latest/)
* [How and why you should lint your Ansible playbooks](https://loganmarchione.com/2020/04/how-and-why-you-should-lint-your-ansible-playbooks/)
* [Linting your Ansible Playbooks and make a Continuous Integration(CI) Solution](https://faun.pub/linting-your-ansible-playbooks-and-make-a-continuous-integration-ci-solution-bcf8b4ea4c03)

```bash
# install yaml and ansible lint tools
sudo apt-get install yamllint ansible-lint

# check your installation of ansible-lint
$ ansible-lint --version
ansible-lint 5.4.0 using ansible 2.12.5

# check your installation of yamllint
$ yamllint --version
yamllint 1.26.3
```

```yaml
# place these linting rules in ~/.config/yamllint/config
---
extends: default

ignore: |
  *.template.yaml

rules:
  empty-lines: disable
  line-length:
    max: 200
    level: warning
```

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



[26]:https://en.wikipedia.org/wiki/Serialization
[27]:https://docs.ansible.com/ansible/latest/reference_appendices/YAMLSyntax.html#yaml-syntax
