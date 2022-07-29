Configuring Historylog:
  file.append:
    - name: /etc/rsyslog.conf
    - text: local3.* /var/log/user-activity.log
