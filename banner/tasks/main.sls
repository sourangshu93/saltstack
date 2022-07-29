Stop Printing motd:
    file.append:
        - name: /etc/ssh/sshd_config
        - text: PrintMotd no
Restart sshd service:
    service.running:
        - name: sshd
        - enable: True
        - reload: True
Copy banner to profiles.d:
    file.managed:
        - name: /etc/profile.d/login_info.sh
        - source: salt://salt/banner/files/login_info.sh
        - makedirs: True