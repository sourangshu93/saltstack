{% import_yaml 'salt/oracle19c/vars/map.yaml' as oracle19c %}
{% include 'salt/oracle19c/tasks/mount.sls' %}
{% include 'salt/oracle19c/tasks/useradd.sls' %}
{% include 'salt/oracle19c/tasks/lvm.sls' %}
{% set oracle_hostname = salt['grains.get']('fqdn') %}
{% set sddcenv = salt.pillar.get('sddcenv') %}
{% set pwd_alias = salt['random.get_str'](10, lowercase=True, uppercase=True, digits=True, punctuation=False, whitespace=False) %}
Install latest version of oracle prerequisite packages:
    pkg.installed:
        - pkgs:
            - ksh
            - libaio-devel
            - smartmontools
            - oracle-database-preinstall-19c
{%- load_yaml as dbpass %}
SYSTEM_PASSWORD: {{ pwd_alias|yaml_encode }}
SYS_PASSWORD: {{ pwd_alias|yaml_encode }}
ORACLE_PASS: {{ pwd_alias|yaml_encode }}
DBSNMPPASS: {{ pwd_alias|yaml_encode }}
ALL_SCHEMA_PASS: {{ pwd_alias|yaml_encode }}
{%- endload %}

{% for dirs in '/oracle/product','/oracle/product/19.0.0','/oracle/product/oraInventory','/oracle/product/orclinstaller','/oracle/product/orclinstaller/database/response','/oracle/product/orclinstaller/log','/tmp/salt/log','/oracle/scripts' -%}
Creating Directory {{ dirs }}:
    file.directory:
        - name: "{{ dirs }}"
        - user: oracle
        - group: oinstall
        - mode: 775
        - makedirs: True
        - force: True
        - recurse:
            - user
            - group
            - mode
{% endfor %}
Collecting values of password variables:
    file.append:
        - name: "{{ oracle19c.passfile }}"
        - text : |
            {{ dbpass.SYS_PASSWORD }}
            {{ dbpass.ALL_SCHEMA_PASS }}
Create Info.txt file for Admin:
  file.append:
    - name: "{{ oracle19c.info }}"
    - text: |
        oracle: {{ oracle_hostname }}
        sys: {{ dbpass.SYS_PASSWORD }}
        system: {{ dbpass.SYSTEM_PASSWORD }}
        ALL_OTHER_SCHEMAS: {{ dbpass.ALL_SCHEMA_PASS }}
Unzip Oracle 19c Binary:
    archive.extracted:
        - name: "{{ oracle19c.oracle_home }}"
        - source: "/tmp/mount/ORACLE_SOFTWARES/19.0.0/19.0.0.zip"
        - user: oracle
        - group: oinstall
        - enforce_toplevel: False
        - use_cmd_unzip: True
        - force: True
Sync response from Dropbox mountpoint:
    rsync.synchronized:
        - name: "{{ oracle19c.oracle_installer_location }}/database/response"
        - source: "/tmp/mount/INFADB/response/"
        - force: True
{% for file in [
  { 'path': oracle19c.dbcafile, 'regexp': 'SYSPASS', 'replace': dbpass.SYS_PASSWORD },
  { 'path': oracle19c.dbcafile, 'regexp': 'SYSTEMPASS', 'replace': dbpass.SYSTEM_PASSWORD },
  { 'path': oracle19c.dbcafile, 'regexp': 'DBSNMPPASS', 'replace': dbpass.DBSNMPPASS },
  { 'path': oracle19c.dbcafile, 'regexp': 'ORCLHOME', 'replace': oracle19c.oracle_home },
  { 'path': oracle19c.dbcafile, 'regexp': 'ORCLBASE', 'replace': oracle19c.oracle_base },
  { 'path': oracle19c.netcafile, 'regexp': 'LISTENER_PROTOCOLS', 'replace': 'LISTENER_PROTOCOLS =' + oracle19c.listenerprotocol },
  { 'path': oracle19c.dbfile, 'regexp': 'INVLOC', 'replace': oracle19c.inventory_location },
  { 'path': oracle19c.dbfile, 'regexp': 'ORAHOME', 'replace': oracle19c.oracle_home },
  { 'path': oracle19c.dbfile, 'regexp': 'ORABASE', 'replace': oracle19c.oracle_base },
  ]
%}
Replacing the parameters for {{ file.regexp }}:
    file.replace:
        - name: {{ file.path }}
        - pattern: {{ file.regexp }}
        - repl: {{ file.replace }}
{% endfor %}
{% include 'salt/oracle19c/tasks/common.sls' %}
Create key file:
    file.touch:
        - name: '/tmp/key.txt'
Protect file with password:
    file.append:
        - name: '/tmp/key.txt'
        - text: |
            :set key={{ oracle19c.password }}
            :wq!
Encrypting the file:
    cmd.run:
        - name: "vim -s /tmp/key.txt ~oracle/info.txt >/dev/null 2>&1;echo 'Success'"

Changing Permission of All folders to Oracle:
    file.directory:
        - name: /oracle
        - user: oracle
        - group: oinstall
        - recurse:
            - user
            - group
{% include 'salt/oracle19c/tasks/unmount.sls' %}
{% include 'salt/oracle19c/tasks/SSHKEY.sls' %}