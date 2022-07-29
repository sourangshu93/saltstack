{% if ((grains['os_family'] == 'RedHat') and (grains['osmajorrelease'] == 7)) %}
Copy the package for CentOS and OEL 7:
  file.managed:
    - name: /tmp/cb-psc-sensor-rhel-2.12.0.698755.tgz
    - source: https://artifactory-pub.bit9.local/artifactory/production/psc/product/agent/linux/signed/release-psc-lnx-2.12.0/2.12.0.698755/cb-psc-sensor-rhel-2.12.0.698755.tgz
    - makedirs: True
    - skip_verify: True
    - verify_ssl: False
Extract the installer for CentOS and OEL 7:
  archive.extracted:
    - name: /tmp/cb-psc-sensor-rhel
    - source: /tmp/cb-psc-sensor-rhel-2.12.0.698755.tgz
    - user: root
    - group: root
    - enforce_toplevel: False
Install the rpm package for CentOS and OEL 7:
  pkg.installed:
    - sources: 
      - cb-psc-sensor: /tmp/cb-psc-sensor-rhel/cb-psc-sensor-2.12.0-698755.el7.x86_64.rpm
Install the blades and register comapny for CentOS and OEL 7:
  cmd.run:
    - name: /usr/bin/bash /tmp/cb-psc-sensor-rhel/blades/bladesUnpack.sh && /opt/carbonblack/psc/bin/cbagentd -d '7RQ18OONWX!K3'
Start cb-cloud-sensor service for CentOS and OEL 7:
  service.running:
    - name: cbagentd
    - enable: True
Delete the package post installation for CentOS and OEL 7:
  file.absent:
    - names: 
      - /tmp/cb-psc-sensor-rhel-2.12.0.698755.tgz
      - /tmp/cb-psc-sensor-rhel/
{% elif ((grains['os_family'] == 'RedHat') and (grains['osmajorrelease'] == 8)) %}
Copy the package for CentOS and OEL 8:
  file.managed:
    - name: /tmp/cb-psc-sensor-rhel-2.12.0.698755.tgz
    - source: https://artifactory-pub.bit9.local/artifactory/production/psc/product/agent/linux/signed/release-psc-lnx-2.12.0/2.12.0.698755/cb-psc-sensor-rhel-2.12.0.698755.tgz
    - makedirs: True
    - skip_verify: True
    - verify_ssl: False
Extract the installer for CentOS and OEL 8:
  archive.extracted:
    - name: /tmp/cb-psc-sensor-rhel
    - source: /tmp/cb-psc-sensor-rhel-2.12.0.698755.tgz
    - user: root
    - group: root
    - enforce_toplevel: False
Install the rpm package for CentOS and OEL 8:
  pkg.installed:
    - sources: 
      - cb-psc-sensor: /tmp/cb-psc-sensor-rhel/cb-psc-sensor-2.12.0-698755.el8.x86_64.rpm
Install the blades and register comapny for CentOS and OEL 8:
  cmd.run:
    - name: /usr/bin/bash /tmp/cb-psc-sensor-rhel/blades/bladesUnpack.sh && /opt/carbonblack/psc/bin/cbagentd -d '7RQ18OONWX!K3'
Start cb-cloud-sensor service for CentOS and OEL 8:
  service.running:
    - name: cbagentd
    - enable: True
Delete the package post installation for CentOS and OEL 8:
  file.absent:
    - names: 
      - /tmp/cb-psc-sensor-rhel-2.12.0.698755.tgz
      - /tmp/cb-psc-sensor-rhel/
{% elif ( grains['os_family'] == 'RedHat'  and grains['osmajorrelease'] == 6) %}
Copy the package for CentOS and OEL 6:
  file.managed:
    - name: /tmp/cb-psc-sensor-2.11.3-629089.el6.x86_64.rpm
    - source: https://linux-repo.vmware.com/utilities/cb-sensors/cb-psc-sensor-2.11.3-629089.el6.x86_64.rpm
    - makedirs: True
    - skip_verify: True
    - verify_ssl: False
Install the RPM for CentOS and OEL 6:
  cmd.run:
    - name: yum install -y /tmp/cb-psc-sensor-2.11.3-629089.el6.x86_64.rpm
Register company for CentOS and OEL 6:
  cmd.run:
    - name: /opt/carbonblack/psc/bin/cbagentd -d '7RQ18OONWX!K3'
Start cb-cloud-sensor service for CentOS and OEL 6:
  cmd.run:
    - name: service cbagentd start
Delete the package post installation CentOS and OEL 6:
  file.absent:
    - names: 
      -  /tmp/cb-psc-sensor-2.11.3-629089.el6.x86_64.rpm
{% elif grains['os_family'] == 'Debian' %}
Copy the package for Ubuntu:
  file.managed:
    - name: /tmp/cb-psc-sensor-ubuntu-2.12.0.698755.tgz
    - source: https://artifactory-pub.bit9.local/artifactory/production/psc/product/agent/linux/signed/release-psc-lnx-2.12.0/2.12.0.698755/cb-psc-sensor-ubuntu-2.12.0.698755.tgz
    - makedirs: True
    - skip_verify: True
    - verify_ssl: False
Extract the installer for Ubuntu:
  archive.extracted:
    - name: /tmp/cb-psc-sensor-ubuntu
    - source: /tmp/cb-psc-sensor-ubuntu-2.12.0.698755.tgz
    - user: root
    - group: root
    - enforce_toplevel: False
Install the package for Ubuntu:
  pkg.installed:
    - sources:
      - cb-psc-sensor: /tmp/cb-psc-sensor-ubuntu/cb-psc-sensor-2.12.0-698755.x86_64.deb
Install the blades and register comapny for Ubuntu:
  cmd.run:
    - name: /usr/bin/bash /tmp/cb-psc-sensor-ubuntu/blades/bladesUnpack.sh && /opt/carbonblack/psc/bin/cbagentd -d '7RQ18OONWX!K3'
Start cb-cloud-sensor service for Ubuntu:
  service.running:
    - name: cbagentd
    - enable: True
Delete the package post installation:
  file.absent:
    - names: 
      - /tmp/cb-psc-sensor-ubuntu-2.12.0.698755.tgz
      - /tmp/cb-psc-sensor-ubuntu/
{% endif %}