Create oinstall group:
    group.present:
        - name: oinstall
        - gid: 511
Create dba group:
    group.present:
        - name: dba
        - gid: 512
Create oracle user and add to oinstall and dba group:
    user.present:
        - name: oracle
        - fullname: Oracle user
        - shell: /bin/bash
        - home: /home/oracle
        - uid: 200
        - gid: 511
        - password: '$6$mysecretsalt$lxylT5/9wlw9WuBfvTqwo3NjO1PJwZTV4KVGSAIe2xlTgChgaK.4sJh2y2OtiDFettZkCfZcdvLXfeutyXaxA.'
        - groups:
            - dba
            - oinstall
    
  