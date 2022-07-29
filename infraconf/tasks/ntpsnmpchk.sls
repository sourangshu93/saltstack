{% set package = pillar.get('mod_file').split('/')[2].split('.')[0] %}

Update {{ package }}:
  file.managed:
    - name: /etc/{{ package }}.conf
    - source: salt://saltstack/vra-terraform/saltstates/infraconf/files/{{ package }}.jinja
    - template: jinja
