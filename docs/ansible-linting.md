<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.0.1
-->


<div align="center">
<img src="https://raw.githubusercontent.com/jeffskinnerbox/blog/main/content/images/banners-bkgrds/work-in-progress.jpg" title="These materials require additional work and are not ready for general use." align="center" width=420px height=219px>
</div>


----


A **syntax checker** checks for syntax errors in each statement, according to the data set type.
The syntax checker scans each line a user enters, in input mode, when the user edits a data set.
Traditionally, to check for basic syntax errors in an Ansible playbook,
you would run the playbook with the `--syntax-check` flag.
However, the `--syntax-check` flag is not as comprehensive or in-depth as linting.

**Linting** is the process of scanning code for potential errors or violation of coding conventions.
The lint scans your code against some rules and provides you an analysis report but the corrections must be done manually.
In this document I outline the use of a linting tool useful for [YAML][27] formatted files used in [Ansible][01].

Ansible playbooks are written in [YAML][27]
because it is easier for humans to read & write than other common data formats like XML or JSON.
YAML is a [data serialisation language][26],
it’s a strict superset of JSON,
but with the addition of syntactically significant newlines and indentation, like Python.
Unlike Python, however, YAML doesn’t allow literal tab characters for indentation.

To learn more, consider these sources:

* [YAML for beginners](https://www.redhat.com/sysadmin/yaml-beginners)
* [Understanding YAML for Ansible](https://www.redhat.com/sysadmin/understanding-yaml-ansible)
* [YAML best practices for Ansible playbooks - tasks](https://www.jeffgeerling.com/blog/yaml-best-practices-ansible-playbooks-tasks)

# Some Linting Tools
There are several candidate linters that could be used for lint scanning of Ansible files.
The ones I prefer are listed here.
The first (`ymallint`) focus on linting of raw YAML.
The second dives deeper into the specifics of Ansible.

## yamllint
[`yamllint`][02] is simple to used but goes beyond check for syntax validity,
but also checks for for repetition and cosmetic problems such as lines length, trailing spaces, indentation, etc.

```bash
# install yaml lint tool
sudo apt install yamllint

# check your installation of yamllint
$ yamllint --version
yamllint 1.26.3
```

You cam place your `yamllint` linting rules in `~/.config/yamllint/config`.
Below is an example rules file:

```yaml
# place these linting rules the file ~/.config/yamllint/config

---

extends: default

# ignore this files when processing
ignore:
  .github
  *.template.yaml

# linting rules to be disabled or modified
rules:
  empty-lines: disable
  line-length:
    max: 200
    level: warning
```

Sources:
* [A linter for YAML files][02]
* [yamllint documentation](https://yamllint.readthedocs.io/en/stable/)
* [Check your YAML for errors with yamllint](https://www.redhat.com/sysadmin/check-yaml-yamllint)

## ansible-lint
[`ansible-lint`][03] is a linter designed specifically for Ansible playbooks.
`ansible-lint` goes beyond regular YAML linters by checking Ansible tasks themselves,
checking playbooks for practices and behavior that could potentially be improved
and can fix some of the most common ones for you.

You can integrate Ansible Lint into a [CI/CD][04] pipeline to check for potential issues,
such as deprecated or removed modules, syntax errors, idempotent playbooks, and more.
It offers suggestions as to which Ansible module can best suit a particular situation.
Ansible Lint ensures best practices by using a set of default rules built into the tool.

We can custom configure `ansible-lint` for your requirement.
Apart from the default rules, we can specify additional rules in a file,
and the command-line flag `-c <file path>` will lint the playbook based on the custom configuration.

```bash
# install the latest version of ansible lint tools
#sudo apt install ansible-lint                          # version 5.4.0
pip3 install ansible-lint                              # version 6.22.1

# where was ansible-list installed
whereis ansible-list

# check your installation of ansible-lint
$ ansible-lint --version
ansible-lint 6.22.1 using ansible-core:2.12.5 ansible-compat:4.1.10 ruamel-yaml:0.18.5 ruamel-yaml-clib:0.2.8

# list all the default rules (doesn't include .ansible-lint file)
ansible-lint -L
```

You customize how `ansible-lint` runs so you can ignore certain rules,
enable opt-in rules, and control various other settings.
`ansible-lint` loads configuration either `.ansible-lint`, `.config/ansible-lint.yml`
from a file in the current working directory,
or from a file that you specify in the command line (e.g. `ansible-lint -c <path-to-ansible-lint-file>`).
Any configuration option that is passed from the command line will override
the one specified inside the configuration file.

A `.ansible-lint` file I find useful is:

```yaml
# see https://ansible.readthedocs.io/projects/lint/configuring/#ansible-lint-configuration
# see https://github.com/ansible/ansible-lint/blob/main/.ansible-lint
```

`ansible-lint` will load skip rules from an `.ansible-lint-ignore` or `.config/ansible-lint-ignore.txt`
file that should reside adjacent to the config file.
The file format is very simple, containing the filename and the rule to be ignored.

A `.ansible-lint-ignore` file I find useful is:

```yaml
# see https://ansible.readthedocs.io/projects/lint/configuring/#ignoring-rules-for-entire-files
```

Sources:
* [Ansible Lint Documentation][03]
* [Find mistakes in your playbooks with Ansible Lint](https://www.redhat.com/sysadmin/ansible-lint)
* [Avoid errors in your Ansible playbooks with ansible-lint](https://www.redhat.com/sysadmin/ansible-lint-YAML)
* [How and why you should lint your Ansible playbooks](https://loganmarchione.com/2020/04/how-and-why-you-should-lint-your-ansible-playbooks/)
* [Linting your Ansible Playbooks and make a Continuous Integration(CI) Solution](https://faun.pub/linting-your-ansible-playbooks-and-make-a-continuous-integration-ci-solution-bcf8b4ea4c03)



[01]:https://www.ansible.com/
[02]:https://github.com/adrienverge/yamllint
[03]:https://ansible-lint.readthedocs.io/en/latest/
[04]:https://www.redhat.com/en/topics/devops/what-is-ci-cd?intcmp=701f20000012ngPAAQ

[26]:https://en.wikipedia.org/wiki/Serialization
[27]:https://docs.ansible.com/ansible/latest/reference_appendices/YAMLSyntax.html#yaml-syntax
