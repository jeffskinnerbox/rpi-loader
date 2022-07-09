<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.0.1
-->


<div align="center">
<img src="http://www.foxbyrd.com/wp-content/uploads/2018/02/file-4.jpg" title="These materials require additional work and are not ready for general use." align="center">
</div>


----


# Networking Tools Playbook

As the `root` user do the following

```yaml
#
# task file for 'network-tools' role - install various networking related tools
#
# See: https://github.com/mrlesmithjr/ansible-network-tools

---

- name: install various networking tools / packages
  apt:
    state: latest
    update_cache: true
    cache_valid_time: 86400
    pkg:
      - 'arp-scan'
      - 'arping'
      - 'arptables'
      - 'bmon'
      - 'dnsutils'
      - 'ifstat'
      - 'iftop'
      - 'iperf3'
      - 'iproute2'
      - 'lldpd'
      - 'lsof'
      - 'nbtscan'
      - 'netcat'
      - 'netdiscover'
      - 'netdiag'
      - 'nethogs'
      - 'netperf'
      - 'netsniff-ng'
      - 'net-tools'
      - 'nfdump'
      - 'ngrep'
      - 'nicstat'
      - 'nload'
      - 'nmap'
      - 'rfkill'
      - 'socat'
      - 'sysstat'
      - 'tcpdump'
      - 'tcpflow'
      - 'tcpstat'
      - 'tcptrace'
      - 'tcptrack'
      - 'telnet'
      - 'traceroute'
      - 'ufw'
      - 'wavemon'
```
