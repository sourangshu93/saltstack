{% set ip_addr = (grain['fqdn_ip4']) %}
Download installer script from cloud proxy:
    file.managed:
        - name: /tmp/download.sh
        - source: https://10.148.218.144/downloads/salt/download.sh
        - user: root
        - group: root
        - mode: 0755
        - makedirs: True
        - skip_verify: True
        - verify_ssl: False
Install prerequisite packages:
    pkg.installed:
        - pkgs:
            - zip
            - unzip
Eexecute the agent installation script:
    cmd.run:
        - name: /usr/bin/bash ./download.sh -o install -v 10.128.129.145 -u agent_install -p Allowme@123 -i {{ ip_addr }} 
        - cwd: /tmp
Remove the downloaded file:
    file.absent:
        - name: /tmp/download.sh