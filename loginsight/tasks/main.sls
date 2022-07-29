Download loginsight agent:
  file.managed:
    - name: /tmp/VMware-Log-Insight-Agent-8.4.0-17798181.noarch_10.79.203.252.rpm
    - source: http://itapps.vmware.com/installs/VMware-Log-Insight-Agent-8.4.0-17798181.noarch_10.79.203.252.rpm
    - makedirs: True
Install loginsight agent on server:
  pkg.installed:
    - sources:
      - loginsight_agent: /tmp/VMware-Log-Insight-Agent-8.4.0-17798181.noarch_10.79.203.252.rpm
Configure Log-Insight Hostname:
  file.line:
    - name: /var/lib/loginsight-agent/liagent.ini
    - match: ;hostname=LOGINSIGHT
    - mode: replace
    - content: hostname=montools-dev-loginsight.vmware.com
Configure Log-Insight To Accept SSL:
  file.line:
    - name: /var/lib/loginsight-agent/liagent.ini
    - mode: insert
    - after: ;ssl_ca_path=/etc/pki/tls/certs/ca.pem
    - content: ssl_accept_any=yes
Set log path:
  file.line:
    - name: /var/lib/loginsight-agent/liagent.ini
    - mode: insert
    - after: ^;include=messages;
    - content: [filelog|log_file] /n directory= /var/log/ /n include=*
{% for  path in '/var/lib/loginsight-agent','/var/log/loginsight-agent'%}
Set file permission:
  file.directory:
    - name: {{ path }}
    - user: root
    - group: root
    - dir_mode: 777
    - recurse:
      - user
      - group
      - mode
{% endfor %}
Restart loginsigh agent:
  service.running:
    - name: liagentd
    - enable: True
    - reload: True
Remove the RPM package post installation:
  file.absent:
    - name: /tmp/VMware-Log-Insight-Agent-8.4.0-17798181.noarch_10.79.203.252.rpm