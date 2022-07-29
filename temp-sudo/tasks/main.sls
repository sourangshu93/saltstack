{% set username = pillar.get('username') %}
#{% set days = pillar.get('days') %}
Create users file inside sudoers.d:
    file.managed:
        - name: /etc/sudoers.d/users
        - contents: 
          - {{ username }} ALL=(ALL) ALL
        - user: root
        - group: root
        - mode: 644
{% set day = salt['cmd.shell']('date +"%d" -d "+'+pillar['days']+' days"|sed "s/^0*//"') %}
{% set month = salt['cmd.shell']('date +"%m" -d "+'+pillar['days']+' days"|sed "s/^0*//"') %}
Add crontab file:
    cron.present:
        - name: 'crontab -r; rm -rf /etc/sudoers.d/users'
        - user: root
        - minute: 0
        - hour: 0
        - daymonth: {{ day }}
        - month: {{ month }}
        - comment: "Cron job sudo access"