Run command to install telegraf:
    cmd.run:
        - name: "curl -ks http://vov-prd-app-1.vmware.com/scripts/telegraf/telegraf-setup.rpm.sh | sudo bash"

Install Telegraf package:
    pkg.installed:
        - pkgs:
            - telegraf

Start and enable the telegraf service:
    service.running:
        - name: telegraf
        - enable: True
        - reload: True