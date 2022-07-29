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
        - password: 'oracle'
        - groups:
            - dba
            - oinstall

{% for dir in '/oracle','/home/oracle' %}
Change permission for {{ dir }}:
    file.directory:
        - name: "{{ dir }}"
        - user: oracle
        - group: oinstall
        - mode: 755
        - makedirs: True
        - force: True
        - recurse:
            - user
            - group
            - mode
{% endfor %}