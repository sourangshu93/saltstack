#!/bin/bash
for count in {1..6}
  do
     jobchk=`salt-call pillar.item sssd_sudo_access | grep "None" | wc -l`
     if [[ $jobchk -eq 0 ]];then
        echo "Retrying till 1 minute"
        sleep 10
     else
        exit 0
     fi
  done
