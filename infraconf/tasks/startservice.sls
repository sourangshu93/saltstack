{% set service = pillar.get('service') %}

Start_service_{{ service }}:
  service.running:
    - name: {{ service }}
    - enable: True
