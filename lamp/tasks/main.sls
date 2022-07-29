{% set passwd = salt['random.get_str'](8, lowercase=True, uppercase=True, digits=True, punctuation=False, whitespace=False) %}
##Apache configuration##
Upgrade all the available packages:
    pkg.uptodate:
        - refresh: True

Install Apache:
    pkg.installed:
        - pkgs:
            - apache2

List available application using ufw:
    cmd.run:
        - name: ufw app list

##Database server configuration##
Upgrade available packages:
    pkg.uptodate:
        - refresh: True

Install MySQL:
    pkg.installed:
        - pkgs:
            - mysql-server
            - mysql-client

Display Mysql Version:
    cmd.run:
        - name: mysql --version

Start mysqld service:
    service.started:
        - name: mysql.service