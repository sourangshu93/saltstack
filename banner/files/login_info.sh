#! /usr/bin/env bash

# Basic info
HOSTNAME=`uname -n`
IPADDR=`hostname -I| awk {'print $1'}`
KERNEL=`uname -r`
# OS Info
ROOT=`df -Ph | grep lvroot | awk '{print $5}' | tr -d '%'`
let FREE=100-$ROOT
OS=`cat /etc/os-release|awk -F= '$1=="NAME" { print $2}'|tr -d '"'`
VERSION=`cat /etc/os-release|awk -F= '$1=="VERSION_ID" { print $2}'|tr -d '"'`
# System load
MEMORY1=`free -t -m | grep Total | awk '{print $3" MB";}'`
MEMORY2=`free -t -m | grep "Mem" | awk '{print $2" MB";}'`
LOAD1=`cat /proc/loadavg | awk {'print $1'}`
LOAD5=`cat /proc/loadavg | awk {'print $2'}`
LOAD15=`cat /proc/loadavg | awk {'print $3'}`
SWAP=`free -m | tail -n 1 | awk '{print $3}'`
USER=`whoami`
EXP_DATE=`date -d '2022-08-07' +%s`
TODAY=`date +%s`
UP=`uptime -s|awk {'print $1'}`
UPTIME=`date -d $UP +%s`
let UPDAYS=($TODAY-$UPTIME)/86400
let DIFF=($EXP_DATE-$TODAY)/86400 
echo -e "
=========================\033[1;31mServer Info\033[1;m=================================
 -\033[1;34m Hostname............:\033[1;m \033[1;32m$HOSTNAME\033[1;m
 -\033[1;34m IP Address..........:\033[1;m \033[1;32m$IPADDR\033[1;m                                  
 -\033[1;34m Disk Space(root)....:\033[1;m \033[1;32m$FREE% Free\033[1;m
 -\033[1;34m Server Uptime.......:\033[1;m \033[1;32m$UPDAYS+ Days\033[1;m
=========================\033[1;31mOS Info\033[1;m=====================================
 -\033[1;34m Operating System....:\033[1;m \033[1;32m$OS $VERSION\033[1;m
 -\033[1;34m Kernel Version......:\033[1;m \033[1;32m$KERNEL\033[1;m
 -\033[1;34m OS Owner............:\033[1;m \033[1;32mit-devops-linuxsa@vmware.com\033[1;m
=========================\033[1;31mLoad Info\033[1;m===================================
 -\033[1;34m CPU usage...........:\033[1;m \033[1;32m$LOAD1, $LOAD5, $LOAD15 (1, 5, 15 min)\033[1;m
 -\033[1;34m Memory used.........:\033[1;m \033[1;32m$MEMORY1 / $MEMORY2\033[1;m
 -\033[1;34m Swap usage..........:\033[1;m \033[1;32m$SWAP MB\033[1;m
 -\033[1;34m Logged in as........:\033[1;m \033[1;32m$USER\033[1;m
=========================\033[1;31mSystem Lease\033[1;m================================
 -\033[1;34m System Lease........:\033[1;m \033[1;34mLease will expire in $DIFF days\033[1;m
=====================================================================
"