Copy ssh key for oracle:
    file.managed:
        - name: /home/oracle/.ssh/authorized_keys
        - source: salt://salt/oamapp/files/id_rsa.pub
        - makedirs: True
        - user: oracle
        - group: oinstall
        - mode: 644