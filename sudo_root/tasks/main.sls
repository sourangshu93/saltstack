{% set user = pillar.get('user',"Disabled") %}

{% if user != 'Disabled' %}

Creating_sudoers:
  file.line:
    - name: /etc/sudoers.d/salt_sudo
    - content: {{ user }} ALL=(ALL) NOPASSWD:ALL
    - mode: insert
    - create: True
    - location: end

Modify_SSSD_list:
  file.replace:
    - name: /etc/sssd/sssd.conf
    - pattern: '^(simple_allow_users = )(.*)$'
    - repl: '\1,{{ user }}'

{% else %}

Creating sudoers for vars:
  file.managed:
    - name: /etc/sudoers.d/user_access
    - source: salt://saltstack/vra-terraform/saltstates/sudo_root/files/user_access.jinja
    - template: jinja

{% include 'saltstack/vra-terraform/saltstates/sudo/tasks/main.sls' %}

{% endif %}
