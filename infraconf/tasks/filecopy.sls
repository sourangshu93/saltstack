{% set mod_file = pillar.get('mod_file') %}
{% set file = pillar.get('mod_file').split('/')[3] %}
{% set osver = salt['grains.get']('osmajorrelease') | string %}

Configuring_{{ file }}:
  file.managed:
    - name: {{ mod_file }}
    - source: salt://saltstack/vra-terraform/saltstates/infraconf/files/{{ file }}_{{ osver }}
