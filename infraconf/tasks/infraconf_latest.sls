{% set cbagent = salt['service.missing']('cbagentd') %}
{% set osver = salt['grains.get']('osmajorrelease') | string %}


Set root password:
  user.present:
    - name: root
    - password: $6$klrKSfHE$uQmGOgL7ciblq4lNg1cbcAzs08P2zxdzkmlGauzjy1LMdHBqnLVwAYDuDIqoYQ3IJPqIXuD0hfH452Oe5Z5qn.

Install Yum packages:
  pkg.installed:
    - pkgs:
      - telnet
      - mlocate
      - mutt
      - nmap
      - bind-utils
      - mailx
      - traceroute
      - sos
      - yum-utils
      - tree
      - vim-enhanced
      - rsync
      - openssh-clients
      - wget
      - tcpdump
      - strace
      - net-snmp
      - sysstat

{% if osver != '8' %}
Install Extra packages:
  pkg.installed:
    - pkgs:
      - ntp
      - perl

{% endif %}

{% if osver == '7' %}

Install Inotify:
  pkg.installed:
    - pkgs:
      - python-inotify

Install package:
  cmd.run:
    - name: /usr/bin/pip3 install pyinotify
    - require:
      - Install Inotify

{% elif osver == '8' %}

Install Inotify:
  pkg.installed:
    - pkgs:
      - python3-inotify

{% elif osver == '6'  %}

Salt-Repo:
  pkgrepo.managed:
    - humanname: [salt-latest-repo]
    - baseurl: https://archive.repo.saltproject.io/yum/redhat/6/x86_64/latest
    - gpgcheck: 1
    - enabled: 1
    - gpgkey: https://archive.repo.saltproject.io/yum/redhat/6/x86_64/latest/SALTSTACK-GPG-KEY.pub

Reinstall_EPEL:
  pkg.installed:
    - sources:
      - epel-release: https://archives.fedoraproject.org/pub/archive/epel/6/x86_64/epel-release-6-8.noarch.rpm
    - reinstall: True

Install Inotify:
  pkg.installed:
    - pkgs:
      - python-inotify
      - python27-pip
    - require:
      - Reinstall_EPEL

Install package:
  cmd.run:
    - name: pip2.7 install pyinotify
    - require:
      - Install Inotify

{% for repo_file in '/etc/yum.repos.d/epel.repo','/etc/yum.repos.d/epel-testing.repo','/etc/yum.repos.d/Salt-Repo.repo' %}
Cleanup_Repo_{{ repo_file }}:
  file.absent:
    - name: {{ repo_file }}
{% endfor %}
{% endif %}

Updating beacons configuration:
  file.managed:
    - name: /etc/salt/minion.d/beacons.conf
    - source: salt://saltstack/vra-terraform/saltstates/infraconf/files/beacons.jinja
    - template: jinja
    - require:
      - Install Inotify

Updating Minion configuration:
  file.managed:
    - name: /etc/salt/minion
    - source: salt://saltstack/vra-terraform/saltstates/infraconf/files/minion

Restart Salt Minion:
  cmd.run:
    - name: 'salt-call service.restart salt-minion'
    - bg: True
    - onchanges:
      - file: Updating beacons configuration
      - file: Updating Minion configuration

