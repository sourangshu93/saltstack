{% set mod_file = pillar.get('file') %}
{% set new_minion = pillar.get('new_minion') %}

{% if mod_file == "/etc/sudoers" %}

check_{{ mod_file }}:
  salt.state: 
    - tgt: {{ new_minion }}
    - sls: 
      - saltstack.vra-terraform.saltstates.sudo.tasks.sudo
    - saltenv: saltstack
    - concurrent: true
    - test: True

Run_{{ mod_file }}:
  salt.state:
    - tgt: {{ new_minion }}
    - sls:
      - saltstack.vra-terraform.saltstates.sudo.tasks.main
    - saltenv: saltstack
    - concurrent: true
    - onchanges:
      - check_{{ mod_file }}

{% elif mod_file == "/etc/sssd/sssd.conf" %}

check_{{ mod_file }}:
  salt.state:
    - tgt: {{ new_minion }}
    - sls:
      - saltstack.vra-terraform.saltstates.infraconf.tasks.sssdcheck
    - saltenv: saltstack
    - concurrent: true
    - test: True

Run_{{ mod_file }}:
  salt.state:
    - tgt: {{ new_minion }}
    - sls:
      - saltstack.vra-terraform.saltstates.infraconf.tasks.sssdrevert
    - saltenv: saltstack
    - concurrent: true
    - onchanges:
      - check_{{ mod_file }}

{% elif mod_file == "/etc/resolv.conf" %}

check_{{ mod_file }}:
  salt.state:
    - tgt: {{ new_minion }}
    - sls:
      - saltstack.vra-terraform.saltstates.infraconf.tasks.resolv
    - pillar:
        mod_file: {{ mod_file }}
    - saltenv: saltstack
    - concurrent: true
    - test: True

Run_{{ mod_file }}:
  salt.state:
    - tgt: {{ new_minion }}
    - sls:
      - saltstack.vra-terraform.saltstates.infraconf.tasks.resolv
    - pillar:
        mod_file: {{ mod_file }}    
    - saltenv: saltstack
    - concurrent: true
    - onchanges:
      - check_{{ mod_file }}

{% elif mod_file == "/etc/nsswitch.conf" %}

check_{{ mod_file }}:
  salt.state:
    - tgt: {{ new_minion }}
    - sls:
      - saltstack.vra-terraform.saltstates.infraconf.tasks.nsswitch
    - pillar:
        mod_file: {{ mod_file }}
    - saltenv: saltstack
    - concurrent: true
    - test: True

Run_{{ mod_file }}:
  salt.state:
    - tgt: {{ new_minion }}
    - sls:
      - saltstack.vra-terraform.saltstates.infraconf.tasks.nsswitch
    - pillar:
        mod_file: {{ mod_file }}
    - saltenv: saltstack
    - concurrent: true
    - onchanges:
      - check_{{ mod_file }}

{% elif mod_file == "/etc/yum.repos.d/VMware-CentOS-All.repo" or mod_file == "/etc/yum.repos.d/VMware-OracleLinux-All.repo" %}

check_{{ mod_file }}:
  salt.state:
    - tgt: {{ new_minion }}
    - sls:
      - saltstack.vra-terraform.saltstates.infraconf.tasks.configuretest
    - saltenv: saltstack
    - concurrent: true
    - test: True

Run_{{ mod_file }}:
  salt.state:
    - tgt: {{ new_minion }}
    - sls:
      - saltstack.vra-terraform.saltstates.infraconf.tasks.configurerepo
    - pillar:
        patch_repo: "presentquarter"
    - saltenv: saltstack
    - concurrent: true
    - onchanges:
      - check_{{ mod_file }}

{% elif mod_file == "/etc/ntp.conf" or mod_file == "/etc/snmp.conf" %}

check_{{ mod_file }}:
  salt.state:
    - tgt: {{ new_minion }}
    - sls:
      - saltstack.vra-terraform.saltstates.infraconf.tasks.ntpsnmpchk
    - pillar:
        mod_file: {{ mod_file }}
    - saltenv: saltstack
    - concurrent: true
    - test: True

Run_{{ mod_file}}:
  salt.state:
    - tgt: {{ new_minion }}
    - sls:
      - saltstack.vra-terraform.saltstates.infraconf.tasks.ntpsnmp
    - pillar:
        mod_file: {{ mod_file }}
    - saltenv: saltstack
    - concurrent: true
    - onchanges:
      - check_{{ mod_file }}

{% elif mod_file == "/etc/cron.d/sysstat" %}

check_{{ mod_file }}:
  salt.state:
    - tgt: {{ new_minion }}
    - sls:
      - saltstack.vra-terraform.saltstates.infraconf.tasks.sysstat
    - pillar:
        mod_file: {{ mod_file }}
    - saltenv: saltstack
    - concurrent: true
    - test: True

Run_{{ mod_file }}:
  salt.state:
    - tgt: {{ new_minion }}
    - sls:
      - saltstack.vra-terraform.saltstates.infraconf.tasks.sysstat
    - saltenv: saltstack
    - concurrent: true
    - onchanges:
      - check_{{ mod_file }}


{% elif mod_file == "/etc/profile" %}

check_{{ mod_file }}:
  salt.state:
    - tgt: {{ new_minion }}
    - sls:
      - saltstack.vra-terraform.saltstates.infraconf.tasks.profile
    - pillar:
        mod_file: {{ mod_file }}
    - saltenv: saltstack
    - concurrent: true
    - test: True


Run_{{ mod_file }}:
  salt.state:
    - tgt: {{ new_minion }}
    - sls:
      - saltstack.vra-terraform.saltstates.infraconf.tasks.profile
    - saltenv: saltstack
    - concurrent: true
    - onchanges:
      - check_{{ mod_file }}


{% elif mod_file == "/etc/rsyslog.conf" %}

check_{{ mod_file }}:
  salt.state:
    - tgt: {{ new_minion }}
    - sls:
      - saltstack.vra-terraform.saltstates.infraconf.tasks.rsyslog
    - saltenv: saltstack
    - concurrent: true
    - test: True

Run_{{ mod_file }}:
  salt.state:
    - tgt: {{ new_minion }}
    - sls:
      - saltstack.vra-terraform.saltstates.infraconf.tasks.rsyslog
    - saltenv: saltstack
    - concurrent: true
    - onchanges:
      - check_{{ mod_file }}


{% elif mod_file == "/etc/pam.d/password-auth" or mod_file == "/etc/pam.d/system-auth" or mod_file == "/etc/profile.d/test.sh" %}

check_{{ mod_file }}:
  salt.state:
    - tgt: {{ new_minion }}
    - sls:
      - saltstack.vra-terraform.saltstates.infraconf.tasks.filecopy
    - pillar:
        mod_file: {{ mod_file }}
    - saltenv: saltstack
    - concurrent: true
    - test: True

Run_{{ mod_file }}:
  salt.state:
    - tgt: {{ new_minion }}
    - sls:
      - saltstack.vra-terraform.saltstates.infraconf.tasks.filecopy
    - pillar:
        mod_file: {{ mod_file }}
    - saltenv: saltstack
    - concurrent: true
    - onchanges:
      - check_{{ mod_file }}

 
{% elif mod_file == "/etc/sysconfig/authconfig" %}

check_{{ mod_file }}:
  salt.state:
    - tgt: {{ new_minion }}
    - sls:
      - saltstack.vra-terraform.saltstates.infraconf.tasks.authconfig
    - saltenv: saltstack
    - concurrent: true
    - test: True


Run_{{ mod_file }}:
  salt.state:
    - tgt: {{ new_minion }}
    - sls:
      - saltstack.vra-terraform.saltstates.infraconf.tasks.authconfig
    - saltenv: saltstack
    - concurrent: true
    - onchanges:
      - check_{{ mod_file }}

{% endif %}


email-on-success:
  smtp.send_msg:
    - name:  SaltStack found that {{ mod_file }} was modified. Reverting to the original state.
    - profile: my-smtp-login
    - recipient: srakshiit@vmware.com
    - subject: Salt-Stack Monitoring-'{{ new_minion }}-SUCCESS'
    - onchanges:
      - Run_{{ mod_file }}

email-on-failure:
  smtp.send_msg:
    - name: SaltStack found that {{ mod_file }} was modified. Failed to revert original state. Please login and check {{ mod_file }}.
    - profile: my-smtp-login
    - recipient: srakshiit@vmware.com
    - subject: Salt-Stack Monitoring-'{{ new_minion }}-FAILURE'
    - onfail:
      - Run_{{ mod_file }}
