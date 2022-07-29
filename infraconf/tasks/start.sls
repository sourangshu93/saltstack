{% set new_minion = pillar.get('new_minion') %}
Run_Infraconf:
  salt.state:
    - tgt: {{ new_minion }}
    - sls:
      - saltstack.vra-terraform.saltstates.infraconf.tasks.main
    - pillar:
        patch_repo: 'presentquarter'
    - saltenv: saltstack
    - concurrent: true

