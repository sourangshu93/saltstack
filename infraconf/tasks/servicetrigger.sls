{% set new_minion = pillar.get('new_minion') %}
{% set service = pillar.get('service') %}

Check_task:
  salt.state:
    - tgt: {{ new_minion }}
    - sls:
      - saltstack.vra-terraform.saltstates.infraconf.tasks.checkservice
    - pillar:
        service: {{ service }}
    - saltenv: saltstack
    - concurrent: true

run_task:
  salt.state:
    - tgt: {{ new_minion }}
    - sls:
      - saltstack.vra-terraform.saltstates.infraconf.tasks.startservice
    - pillar:
        service: {{ service }}   
    - saltenv: saltstack
    - concurrent: true
    - onfail:
      - Check_task


email-on-success:
  smtp.send_msg:
    - name: {{ service }} service was down. SaltStack started it successfully.
    - profile: my-smtp-login
    - recipient: it-devops-linuxsa@vmware.com
    - subject: Salt-Stack Monitoring-'{{ new_minion }}'
    - onchanges:
      - run_task


email-on-failure:
  smtp.send_msg:
    - name: {{ service }} service was down. SaltStack failed to start it.Please login and check.
    - profile: my-smtp-login
    - recipient: it-devops-linuxsa@vmware.com
    - subject: Salt-Stack Monitoring-'{{ new_minion }}'
    - onfail_all:
      - Check_task
      - run_task
