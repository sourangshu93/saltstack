Update Resolv:
  file.managed:
    - name: /etc/resolv.conf
    - source: salt://saltstack/vra-terraform/saltstates/infraconf/files/resolv.jinja
    - template: jinja
