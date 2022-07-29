{% set os = salt['grains.get']('os') %}
{% set osver = salt['grains.get']('osmajorrelease') %}

Configuring yum:
  file.managed:
    - name: /etc/yum.repos.d/VMware-{{ os }}-All.repo
    - source: salt://saltstack/vra-terraform/saltstates/patch/files/{{ os }}-{{ osver }}.repo.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644

