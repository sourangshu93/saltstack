create mysql group:
  group.present:
    - name: mysql
    - gid: 27
create mysql user:
  user.present:
    - name: mysql
    - fullname: MySQL Server
    - shell: /bin/bash
    - home: /var/lib/mysql
    - uid: 27
    - gid: 27
    - groups:
      - mysql