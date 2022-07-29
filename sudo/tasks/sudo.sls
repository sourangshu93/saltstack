{% set date = salt.cmd.shell('date "+%Y-%m-%d-%T"') %}
{%- set custom = pillar.get('custom',"Disabled") -%}

Configure Sudoers:
  file.managed:
    - name: /etc/sudoers
    - user: root
    - group: root
    - mode: 0440
    - source: salt://saltstack/vra-terraform/saltstates/sudo/files/default.jinja
    - template: jinja
    - check_cmd: /usr/sbin/visudo -c -f
