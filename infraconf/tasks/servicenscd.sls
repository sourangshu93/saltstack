{% set new_minion = pillar.get('new_minion') %}
{% set service = pillar.get('service') %}

run_task:
  salt.state:
    - tgt: {{ new_minion }}
    - sls:
      - saltstack.vra-terraform.saltstates.infraconf.tasks.stopnscd
    - saltenv: saltstack

test.sleep:
  module.run:
    - length: 30

email-on-success:
  smtp.send_msg:
    - name: {{ service }} service was running. SaltStack stopped service successfully.
    - profile: my-smtp-login
    - recipient: srakshiit@vmware.com
    - subject: Salt-Stack Monitoring-'{{ new_minion }}'
    - require:
      - run_task
      - test.sleep


email-on-failure:
  smtp.send_msg:
    - name: {{ service }} service was running. SaltStack failed to stop the service back.Please login and check.
    - profile: my-smtp-login
    - recipient: srakshiit@vmware.com
    - subject: Salt-Stack Monitoring-'{{ new_minion }}'
    - onfail:
      - smtp: email-on-success

