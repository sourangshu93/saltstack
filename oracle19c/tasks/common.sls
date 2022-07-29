{% set oracle_hostname = salt['grains.get']('fqdn') %}
Create set_DB script file:
  file.touch:
    - name: "~oracle/set_DB.sh"
Modify the set_DB file oracle user:
    file.managed:
        - name: "~oracle/set_DB.sh"
        - contents: ''
        - contents_newline: False
        - user: oracle
        - group: oinstall

Create file for Admin:
  file.append:
    - name: "~oracle/set_DB.sh"
    - text: |
        export ORACLE_HOSTNAME={{ oracle_hostname }}
        export ORACLE_BASE={{ oracle19c.oracle_base }}
        export ORACLE_HOME={{ oracle19c.oracle_home }}
        export TNS_ADMIN={{ oracle19c.oracle_home }}/network/admin
        export PATH=/usr/sbin:$ORACLE_HOME/bin:$PATH
        export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib:/usr/lib64
        export CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib

Modify the bash profile oracle user:
    file.append:
        - name: ~oracle/.bash_profile
        - text: |
            ## Set Oracle DB env.
            source ~/set_DB.sh
Modifying the shell limit in limits.conf:
    file.append:
        - name: /etc/security/limits.conf
        - text: |
            # End of file
            oracle  soft    nproc   2048
            oracle  hard    nproc   16384
            oracle  soft    nofile  2048
            oracle  hard    nofile  131072

Assigning Kernel Parameters in sysctl file:
    sysctl.present:
        - name: net.core.rmem_default
          value: 262144
        - name: net.core.rmem_max
          value: 4194304
        - name: net.core.wmem_default
          value: 262144
        - name: net.core.wmem_max
          value: 1048576
        - name: fs.aio-max-nr
          value: 1048576