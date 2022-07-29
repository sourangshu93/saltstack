{% include 'salt/sddc-app-states/PublicEvals/tasks/lvm.sls' %}
{% include 'salt/sddc-app-states/PublicEvals/tasks/mysql.sls' %}
restart mysqld services post configuration:
  service.running:
    - name: mysqld
    - enable: True
    - reload: True