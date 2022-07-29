{% import_yaml 'salt/oam/vars/map.yaml' as oam %}
{% import 'salt/oamapp/tasks/oracle_user.sls' %}
{% import 'salt/oamapp/tasks/oam_lvm.sls' %}
{% include 'salt/oamapp/tasks/mount.sls' %}
{% include 'salt/oamapp/tasks/iam_mount.sls' %}
{% include 'salt/oamapp/tasks/SSHKEY.sls' %}
{% set hostenv = salt.grains.get('host').split('-')[1] %}
{% set host = salt.grains.get('host') %}
Create file for logs:
    file.directory:
        - name: /tmp/salt/logs
        - user: oracle
        - group: oinstall
        - mode: 775
        - makedirs: True
        - force: True
        - recurse:
            - user
            - group
            - mode

Copying the script file:
    file.copy:
        - name: "{{ oam.pull_script }}"
        - source: '{{ oam.drop_box }}/DB/common/pull.sh'
        - user: oracle
        - group: oinstall
        - mode: 775

Copy the dropbox content to oracle mount:
    rsync.synchronized:
        - name: '/oracle/'
        - source: '{{ oam.drop_box }}/IDM/IDMAPP/'
        - force: True

Changing permission of all folders to oracle:
    file.directory:
        - name: '/oracle/'
        - user: oracle
        - group: oinstall
        - recurse:
            - user
            - group

Provide execution permission for perforce pull:
    file.directory:
        - name: "{{ oam.pull_script }}"
        - mode: 755

Create file for perforce:
    file.touch:
        - name: /tmp/files

Set files to be pulled from Perforce:
    file.managed:
        - name: /tmp/files
        - text: "iam12cdb.properties"
        - mode: 644
        - user: oracle
        - group: oinstall

Replacing the parameters for perforce script:
    file.replace:
        - name: "{{ oam.pull_script }}"
        - pattern: "ENVNAME"
        - repl: "{{ hostenv }}"

Pulling configuration from Perforce:
    cmd.run:
        - name: '{{ pull_script }} >> /tmp/salt/logs/pull_script.log'

{% set ALL_SCHEMA_PASS = salt['cmd.shell']('cat /tmp/iam12cdb.properties | grep ALL_SCHEMA_PASS  | cut -d "=" -f2') %}
{% set jdbc_url = salt['cmd.shell']('cat /tmp/iam12cdb.properties | grep JDBC_URL | cut -d "=" -f2-') %}
{% set SID = salt['cmd.shell']('cat /tmp/iam12cdb.properties | grep IAM_DB_SID | cut -d "=" -f2') %}

{%- load_yaml as conf %}
export_jar: {{ oam.export_jar1 if (( (oam.num_node) < 2 )) else oam.export_jar2 }}
source_dir: {{ oam.source_dir1 if (( (oam.num_node) < 2 )) else oam.source_dir2 }}
{%- endload %}
Create file for oam variables:
    file.touch:
        - name: /tmp/oam_variables

Setting oracle environment variables:
    file.managed:
        - name: /tmp/oam_variables
        - contents: |
            ora_com_bin={{ oam.ora_com_bin }}
            oam_domain={{ oam.oam_domain }}
            oracle_home={{ oam.oracle_home }}
            oam_jdbc_dir={{ oam.oam_jdbc_dir }}
            oam_config_dir={{ oam.oam_config_dir }}
            ALL_SCHEMA_PASS={{ ALL_SCHEMA_PASS }}
            jdbc_url={{ jdbc_url }}
        - mode: 644
        - user: oracle
        - group: oinstall
###Running Installation on 1st Node
{% if "oam-1" in salt.grains.get("host") %}
{% if {{ iam.num_node }} == 1 %}
Unpacking oam domain jar for node 1:
    cmd.run: 
        - name: 'su oracle -c "{{ oam.ora_com_bin }}/unpack.sh -domain={{ oam.oam_domain }} -template={{ oam.source_dir }}/oam_domain_DEV.jar"'
{% endif %}

{% if {{ iam.num_node }} == 2 %}
Unpacking oam domain jar for node 2:
    cmd.run:
        - name: 'su oracle -c "{{ oam.ora_com_bin }}/unpack.sh -domain={{ oam.oam_domain }} -template={{ oa.source_dir }}/oam_testenv_domain_.jar"'
{% endif %}

{% for file in [
    { 'src': "{{ oam.drop_box }}/IAM11g/script/jdbc.sh", 'dest': "/tmp/" },
    { 'src': "{{ oam.source_dir }}/config-vra7.xml", 'dest': "{{ oam.oam_config_dir }}/config.xml" },
    { 'src': "{{ oam.source_dir }}/boot.properties", 'dest': "{{ oam.oam_domain }}/servers/AdminServer/security/" }
]
%}
Copy the Perforce files from from DropBox to {{ file.dest }}:
    file.copy:
        - name: '{{ file.dest }}'
        - source: '{{ file.src }}'
        - makedirs: True
        - user: oracle
        - group: oinstall
        - mode: 775
{% endfor %}

Move file Code.sh:
    cmd.run:
        - name: 'mv /oracle/Code.sh /tmp/'

{% for line in [
    { 'path': "{{ oam.jdbc_script }}", 'regexp': "jdbc_url", 'replace': "{{ oam.jdbc_url }}" },
    { 'path': "{{ oam.jdbc_script }}", 'regexp': "oam_jdbc_dir", 'replace': "{{ oam.oam_jdbc_dir }}" },
    { 'path': "{{ oam.jdbc_script }}", 'regexp': "ALL_SCHEMA_PASS", 'replace': "{{ ALL_SCHEMA_PASS }}" }
    { 'path': "{{ oam.oam_config_dir }}/config.xml", 'regexp': "HOST1_UPDATE", 'replace': "{{ host }}.vmware.com" },
    { 'path': "{{ oam.oam_config_dir }}/config.xml", 'regexp': "HOST2_UPDATE", 'replace': "iam-{{ hostenv }}-oam-2.vmware.com" },
    { 'path': "/tmp/Code.sh", 'regexp': "SERVER", 'replace': "iam-{{ hostenv }}-ora1" },
    { 'path': "/tmp/Code.sh", 'regexp': "SID", 'replace': "{{ SID }}" },
    { 'path': "/tmp/Code.sh", 'regexp': "ALL_SCHEMA_PASS", 'replace': "{{ ALL_SCHEMA_PASS }}" }
]%}
Replacing the parameters for scripts {{ file.regexp }}:
    file.replace:
        - name: {{ line.path }}
        - pattern: {{ line.regexp }}
        - repl: {{ line.replace }}
{% endfor %}

Execute Script:
    cmd.run:
        - name: 'sh /tmp/Code.sh'

Changing Permission of {{ oam.oam_config_dir }} to oracle:
    file.directory:
        - name: {{ oam.oam_config_dir }}
        - user: oracle
        - group: oinstall
        - recurse:
            - user
            - group

Creating security policy store:
    cmd.run:
        - name: 'su oracle -c "{{ oam.ora_com_bin }}/wlst.sh {{ oam.oracle_home }}/common/tools/configureSecurityStore.py -d {{ oam.oam_domain }} -c IAM -p {{ ALL_SCHEMA_PASS }} -m create"'

Creating Directories:
    file.directory:
        - name: {{ oam.oam_domain }}/servers/WLS_OAM1/security/
        - user: oracle
        - group: oinstall
        - mode: 775
        - makedirs: True
        - force: True
        - recurse:
            - user
            - group
            - mode

{% for files in [
    { 'src': "{{ oam.source_dir }}/boot.properties", 'dest': "{{ oam.oam_domain }}/servers/WLS_OAM1/security/" },
    { 'src': "{{ oam.source_dir }}/boot.properties", 'dest': "{{ oam.oam_domain }}/servers/AdminServer/security/" },
    { 'src': "{{ oam.drop_box }}/IAM11g/oam", 'dest': "/etc/init.d/" }
]
%}
Copy Boot Propery files from Dropbox:
    file.copy: 
        - name: {{ file.dest }}
        - source: {{ file.src }}
        - makedirs: True
        - user: oracle
        - group: oinstall
        - mode: 775
{% endfor %}

{% set Nodemanagerout = salt['cmd.shell']('su - oracle -c "{{ ora_com_bin }}/setNMProps.sh > /tmp/salt/logs/NodeManager"') %}

Display Nodemanager Output:
    cmd.run:
        - name: 'echo {{ Nodemanagerout }}'

Start Weblogic Service in 1st Node:
    cmd.run:
        - name: 'su - oracle -c "nohup /oracle/Middleware/user_projects/domains/OAM_Domain/bin/startWebLogic.sh > /tmp/salt/logs/Weblogicstart &"'

Wait until Admin Service is Up:
    cmd.run:
        - name: 'cat /tmp/salt/logs/Weblogicstart | grep "RUNNING"'
        - retry:
            - attempts: 35
            - interval: 60
            - until: True
        - shell: '/bin/bash'

Copy EM Console Configuration files from Dropbox:
    file.copy:
        - name: "{{ oam.oam_domain }}/sysman/state/"
        - source: "{{ oam.source_dir }}/targets.xml"
        - makedirs: True
        - user: oracle
        - group: oinstall
        - mode: 775

Replacing Parameters:
    file.replace:
        - name: '{{ oam.oam_domain }}/sysman/state/targets.xml'
        - pattern: "ENV"
        - repl: "{{ hostenv }}"

Stop Admin service:
    cmd.run:
        - name: su - oracle -c "nohup /oracle/Middleware/user_projects/domains/OAM_Domain/bin/stopWebLogic.sh > /tmp/salt/logs/Weblogicstop &"

Loop until Admin Service is down:
    cmd.run:
        - name: 'cat /tmp/salt/logs/Weblogicstop | grep Disconnected'
        - retry:
            - attempts: 35
            - interval: 60
            - until: True
        - shell: '/bin/bash'

Start Weblogic Service again in 1st Node:
    cmd.run:
        - name: 'su - oracle -c "nohup /oracle/Middleware/user_projects/domains/OAM_Domain/bin/startWebLogic.sh > /tmp/salt/logs/Weblogicstart &"'

Loop until Admin Service is Up:
    cmd.run:
        - name: 'cat /tmp/salt/logs/Weblogicstart | grep "RUNNING"'
        - retry:
            - attempts: 35
            - interval: 60
            - until: True
        - shell: '/bin/bash'

Change Ownership of sharebox:
    cmd.run:
        - name: chown oracle /sharebox/

Pack Node for 2nd Node:
    cmd.run:
        - name: "{{ oam.ora_com_bin }}/pack.sh -domain={{ oam.oam_domain }} -template={{ oam.export_jar2 }} -template_name=OAM -managed=true"

Copy EMConsole Configuration files:
    file.copy:
        - name: "{{ oam.iam_mount }}/{{ hostenv }}-config.xml"
        - source: "{{ oam.oam_config_dir }}/config.xml"
        - makedirs: True
        - user: oracle
        - group: oinstall
        - mode: 775

Start the Weblogic Service in 1st Node:
    cmd.run:
        - name: 'su - oracle -c "nohup /oracle/Middleware/user_projects/domains/OAM_Domain/bin/startManagedWebLogic.sh WLS_OAM1 > /tmp/salt/logs/Managerstart &"'


Wait until Admin Service is Up and running:
    cmd.run:
        - name: 'cat /tmp/salt/logs/Managerstart | grep "RUNNING"'
        - retry:
            - attempts: 35
            - interval: 60
            - until: True
        - shell: '/bin/bash'
{% endif %}

#Running Installation on 2nd Node
{% if "oam-2" in salt.grains.get("host") %}
Loop until Pack is over:
    cmd.run:
        - name: 'ls -ld "{{ oam.iam_mount }}/{{ hostenv }}-config.xml"'
        - retry:
            - attempts: 35
            - interval: 60
            - until: True
        - shell: '/bin/bash'

Unpack the IAM Domain:
    cmd.run:
        - name: "{{ oam.ora_com_bin }}/unpack.sh -domain={{ oam.oam_domain }} -template={{ oam.export_jar2 }}"

Update OAM Configuration file:
    file.copy:
        - name: "{{ oam.oam_config_dir }}/config.xml"
        - source: "{{ oam.iam_mount }}/{{ hostenv }}-config.xml"
        - makedirs: True
        - user: oracle
        - group: oinstall
        - mode: 775

{% for file in "{{ iam_mount }}/{{ sddcenv }}-config.xml","{{ export_jar2 }}" %}
Change the {{ file }} file:
    file.absent:
        - name: {{ file }}
{% endfor %}

Creating Directories:
    file.diretory:
        - name: "{{ oam.oam_domain }}/servers/WLS_OAM2/security/"
        - user: oracle
        - group: oinstall
        - mode: 775
        - makedirs: True
        - force: True
        - recurse:
            - user
            - group
            - mode

Copy Boot Property for 2nd Node:
    file.copy:
        - name: "{{ oam.oam_domain }}/servers/WLS_OAM2/security/"
        - source: "{{ oam.source_dir }}/boot.properties"
        - makedirs: True
        - user: oracle
        - group: oinstall
        - mode: 775

Changing Permission of /oracle folders to oracle:
    file.directory:
        - name: /oracle
        - user: oracle
        - group: oinstall
        - recurse:
            - user
            - group

Start Weblogic Service in 2nd Node:
    cmd.run:
        - name: su - oracle -c "nohup /oracle/Middleware/user_projects/domains/OAM_Domain/bin/startManagedWebLogic.sh WLS_OAM2 > /tmp/salt/logs/Managerstart &"

Wait until Admin Service is Up on node 2:
    cmd.run:
        - name: 'cat /tmp/salt/logs/Managerstart | grep "RUNNING"'
        - retry:
            - attempts: 35
            - interval: 60
            - until: True
        - shell: '/bin/bash'
{% endfor %}
{% include 'salt/oamapp/tasks/unmount.sls' %}