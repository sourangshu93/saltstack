{% set date = salt.cmd.shell('date "+%Y-%m-%d-%T"') %}
{%- set custom = pillar.get('custom',"Disabled") -%}

Checking chattr:
  cmd.run:
    - name: chattr -i /etc/sudoers

{% for list in date,'last' %}
Taking backup of sudoers config usng {{ list }}:
  file.copy:
    - name: /tmp/sudoers-{{ list }}
    - source: /etc/sudoers
    - force: True
    - makedirs: True
    - preserve: True
{% endfor %}
{% if custom == 'Disabled' %}

Always-passes:
  cmd.script:
    - name: pillar.sh
    - source: salt://saltstack/vra-terraform/saltstates/sudo/files/pillar.sh
    - cwd: /root


{% endif %}

Configure Sudoers:
  file.managed:
    - name: /etc/sudoers
    - user: root
    - group: root
    - mode: 0440
    - source: salt://saltstack/vra-terraform/saltstates/sudo/files/default.jinja
    - template: jinja
    - check_cmd: /usr/sbin/visudo -c -f

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
