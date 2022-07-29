Configure Sysstat:
  file.managed:
    - name: /etc/cron.d/sysstat
    - source: salt://saltstack/vra-terraform/saltstates/infraconf/files/sysstat
    - mode: 600
Restarting_Services_sysstat:
  test.succeed_with_changes:
    - watch_in:
      - service: Restarting_Services_sysstat
  service.running:
    - name: sysstat
    - enable: True

