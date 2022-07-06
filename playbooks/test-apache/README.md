
Lint the files

These commands ignore tags

```bash
cd ~/src/linux-tools/rpi-loader/playbooks

yamllint test-apache

ansible-lint test-apache/apache.yml

ansible-playbook -i ../inventory test-apache/apache.yml --syntax-check
```

* [Ansible tips’n’tricks: run select parts of a playbook using tags](https://martincarstenbach.wordpress.com/2021/02/22/ansible-tipsntricks-run-select-parts-of-a-playbook-using-tags/)
* []()

```bash
# list tags in a playbook
ansible-playbook -i inventory playbooks/test-apache/apache.yml --list-tags

# perfrom an install
ansible-playbook -i inventory playbooks/test-apache/apache.yml --tags install

# perfrom an uninstall
ansible-playbook -i inventory playbooks/test-apache/apache.yml --tags uninstall
```

https://phoenixnap.com/kb/ansible-playbook-dry-run#:~:text=The%20easiest%20way%20to%20do,but%20on%20a%20playbook%20level.

To dry-run the files
This produces the same output as actually running the playbook, except it will report on changes it would have made rather than making them.

```bash
ansible-playbook -i ../inventory test-apache/apache.yml --check
```
