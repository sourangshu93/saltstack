Allowing AD access via SSSD:
  file.managed:
    - name: /etc/sssd/sssd.conf
    - user: root
    - group: root
    - mode: 600
    - source: salt://saltstack/vra-terraform/saltstates/sudo/files/sssd.jinja
    - template: jinja

Restarting_Services:
  test.succeed_with_changes:
    - watch_in:
      - service: Restarting_Services
  service.running:
    - name: sssd
    - enable: True

