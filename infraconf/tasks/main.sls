{% set os = salt['grains.get']('os') %}
{% set date = salt.cmd.shell('date "+%Y-%m-%d-%T"') %}
{% set osver = salt['grains.get']('osmajorrelease') | string %}
{% set cbagent = salt['service.missing']('cbagentd') %}
{%- import_yaml 'saltstack/vra-terraform/saltstates/infraconf/vars/map.yaml' as infraconf -%}
{% set osrelease = salt['grains.get']('osmajorrelease') | string %}
{% set patch_repo = pillar.get('patch_repo') %}
Update Resolv:
  file.managed:
    - name: /etc/resolv.conf
    - source: salt://saltstack/vra-terraform/saltstates/infraconf/files/resolv.jinja
    - template: jinja

{% include 'saltstack/vra-terraform/saltstates/infraconf/tasks/configureinfra.sls' %}

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

{% for package in 'ntp','snmp' %}
Update {{ package }}:
  file.managed:
    - name: /etc/{{ package }}.conf
    - source: salt://saltstack/vra-terraform/saltstates/infraconf/files/{{ package }}.jinja
    - template: jinja
{% endfor %}

{% for services  in [
  { 'service': 'ntpd', 'file': 'ntp' },
  { 'service': 'snmpd', 'file': 'snmp' }
  ]
%}
Restarting_Services {{ services.service }}:
  test.succeed_with_changes:
    - watch_in:
      - file:/etc/{{ services.file }}.conf
  service.running:
    - name: {{ services.service }}
    - enable: True
{% endfor %}

Configure Sysstat:
  file.managed:
    - name: /etc/cron.d/sysstat
    - source: salt://saltstack/vra-terraform/saltstates/infraconf/files/sysstat
    - mode: 600

{% else %}
Update SNMP:
  file.managed:
    - name: /etc/snmp.conf
    - source: salt://saltstack/vra-terraform/saltstates/infraconf/files/snmp.jinja
    - template: jinja

Restarting_Services SNMP:
  test.succeed_with_changes:
    - watch_in:
      - file:/etc/snmp.conf
  service.running:
    - name: snmpd
    - enable: True

{% endif %}
{% if osver == '7' or osver == '8' %}
Restarting_Services Sysstat:
  test.succeed_with_changes:
    - watch_in:
      - file:/etc/cron.d/sysstat
  service.running:
    - name: sysstat
    - enable: True
{% endif %}
Updating Bash  History format:
  file.line:
    - name: /etc/profile
    - content: HISTTIMEFORMAT="%d/%m/%y %T "
    - mode: insert
    - before: export PATH USER LOGNAME MAIL HOSTNAME HISTSIZE HISTCONTROL

Deleting Old history format:
  file.line:
    - name: /etc/profile
    - mode: delete
    - match: HISTSIZE=1000

Updating Bash history size:
  file.line:
    - name: /etc/profile
    - content: HISTSIZE=5000
    - mode: insert
    - before: HISTTIMEFORMAT="%d/%m/%y %T "

Configuring Activity Log:
  file.managed:
    - name: /etc/profile.d/test.sh
    - source: salt://saltstack/vra-terraform/saltstates/infraconf/files/test.sh

Configuring Historylog:
  file.append:
    - name: /etc/rsyslog.conf
    - text: local3.* /var/log/user-activity.log

Restarting_Syslog_Services:
  test.succeed_with_changes:
    - watch_in:
      - file: /etc/rsyslog.conf
  service.running:
    - name: rsyslog
    - enable: True

Set root password:
  user.present:
    - name: root
    - password: $6$klrKSfHE$uQmGOgL7ciblq4lNg1cbcAzs08P2zxdzkmlGauzjy1LMdHBqnLVwAYDuDIqoYQ3IJPqIXuD0hfH452Oe5Z5qn.


{% if osver != '8' and salt['pkg.version']('sssd') %} 
{% for file in [
  { 'src': '/etc/nsswitch.conf', 'dst': 'nsswitch.conf-backup' },
  { 'src': '/etc/pam.d/password-auth-ac', 'dst': 'password-auth-ac-backup' },
  { 'src': '/etc/pam.d/system-auth-ac', 'dst': 'system-auth-ac-backup' }
  ]
%}
Taking backup of {{ file.src }} config:
  file.copy:
    - name: /tmp/{{ file.dst }}-{{ date }}
    - source: {{ file.src }}
    - force: True
    - makedirs: True
    - preserve: True
{% endfor %}

{% elif salt['pkg.version']('sssd') %}
{% for file in [
  { 'src': '/etc/nsswitch.conf', 'dst': 'nsswitch.conf-backup' },
  { 'src': '/etc/authselect/password-auth', 'dst': 'password-auth-backup' },
  { 'src': '/etc/authselect/system-auth', 'dst': 'system-auth-backup' }
  ]
%}
Taking backup of {{ file.src }} config:
  file.copy:
    - name: /tmp/{{ file.dst }}-{{ date }}
    - source: {{ file.src }}
    - force: True
    - makedirs: True
    - preserve: True

{% endfor %}
{% endif %}

{% for config in [
  { 'src': 'nsswitch.jinja', 'dst': '/etc/nsswitch.conf' },
  { 'src': 'password-auth', 'dst': '/etc/pam.d/password-auth' },
  { 'src': 'system-auth', 'dst': '/etc/pam.d/system-auth' }
  ]
%}
{% if osver == '7' and salt['pkg.version']('sssd') %}
Copying {{ config.src }}:
  file.managed:
    - name: {{ config.dst }}
    - source: salt://saltstack/vra-terraform/saltstates/infraconf/files/{{ config.src }}_7
    - mode: 644

{% elif osver == '8' and salt['pkg.version']('sssd')  %}
Copying {{ config.src }}:
  file.managed:
    - name: {{ config.dst }}
    - source: salt://saltstack/vra-terraform/saltstates/infraconf/files/{{ config.src }}_8
    - mode: 644

{% elif salt['pkg.version']('sssd') %}
Copying {{ config.src }}:
  file.managed:
    - name: {{ config.dst }}
    - source: salt://saltstack/vra-terraform/saltstates/infraconf/files/{{ config.src }}_6
    - mode: 644
{% endif %}
{% endfor %}

{% if osver == '7' or osver =='6' and salt['pkg.version']('sssd') %}
{% for config in [
  { 'pattern': '^USELDAPAUTH=yes$', 'repl': 'USELDAPAUTH=no' },
  { 'pattern': '^USELDAP=yes', 'repl': 'USELDAP=no' }
  ]
%}
Disable {{ config.pattern}} in authconfig:
  file.replace:
    - name: '/etc/sysconfig/authconfig'
    - pattern: {{ config.pattern }}
    - repl: {{ config.repl }}
{% endfor %}


Disable nslcd:
  service.dead:
    - name: nslcd
    - enable: False

{% endif %}
{% if cbagent == 'False' %}
Restarting_Cbagent_Services:
  service.running:
    - name: cbagentd
    - enable: True
    - onchanges:
      - Check cbagentd
{% endif %}
{% include 'saltstack/vra-terraform/saltstates/sudo/tasks/main.sls' %}
