{% set service = pillar.get('service') %}

Check if service is installed:
  module.run:
    - name: service.missing
    - m_name: {{ service }}
