install percona mysql release rpm:
  cmd.run:
    - name: sudo yum install -y https://repo.percona.com/yum/percona-release-1.0-27.noarch.rpm
copy percona mysql8 repo:
  file.managed:
    - name: /etc/yum.repos.d/percona.repo
    - source: salt://mysql/files/percona-ps-80-release.repo
    - makedirs: True
instal percona mysql pkgs:
  pkg.installed:
    - pkgs:
      - percona-server-server
      - percona-server-client
      - percona-server-shared-compat
      - percona-server-shared
      - percona-xtrabackup-80
backup existing mysql config file:
  file.managed:
    - name: /root/my.cnf-old
    - source: /etc/my.cnf
remove old mysql conf file:
  file.absent:
    - name: /etc/my.cnf
copy new mysql conf file:
  file.managed:
    - name: /etc/my.cnf
    - source: salt://mysql/files/my.cnf
    - makedirs: True
create a binlogs directory:
  file.directory:
    - name: /var/log/mysql/binlogs
    - user: mysql
    - group: mysql
    - dir_mode: 755
    - recurse:
      - user
      - group
      - mode
{% for dir in '/var/log/mysql','/opt/mysql','/backup' %}    
set required permission for log dir:
  file.directory:
    - name: {{ dir }}
    - user: mysql
    - group: mysql
    - recurse:
      - user
      - group
{% endfor %}
