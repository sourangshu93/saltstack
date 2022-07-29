{% set os = salt['grains.get']('os') %}
{% set osver = salt['grains.get']('osmajorrelease') %}

Check-yum-repo:
  module.run:
    - name: pkg.refresh_db

Backing up Repo:
  file.copy:
    - name: /etc/yum.repos.d-backup
    - source: /etc/yum.repos.d
    - force: True
    - makedirs: True
    - preserve: True
    - onfail:
      - Check-yum-repo

Cleaning yum:
  file.directory:
    - name: /etc/yum.repos.d
    - clean: True
    - require:
      - Backing up Repo

Configuring yum:
  file.managed:
    - name: /etc/yum.repos.d/VMware-{{ os }}-All.repo
    - source: salt://saltstack/vra-terraform/saltstates/patch/files/{{ os }}-{{ osver }}.repo.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644

