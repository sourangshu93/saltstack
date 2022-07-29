{% set host = salt['grains.get']('fqdn_ip4')%}
Correct the hosts file:
    cmd.run:
        - name: sed -i '/^$/d' /etc/hosts;sed -i '1,2!d' /etc/hosts;cat /etc/hosts;nslookup $host|awk '/^Name/ split($2,arr,".");{print arr[1]}' | awk -v RS="" '{$1=$1}1'|awk '/^Name/ {print $5 "\t" $2 "\t" $3}'>>/etc/hosts;done ;cat /etc/hosts