Copy ssh key for oracle:
    file.managed:
        - name: /home/oracle/.ssh/authorized_keys
        - source: salt://salt/oracle19c/files/ora-test-mon-a1_id_rsa.pub
        - makedirs: True
        - user: oracle
        - group: oinstall
        - mode: 644