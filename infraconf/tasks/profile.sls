Updating Bash  History format:
  file.line:
    - name: /etc/profile
    - content: HISTTIMEFORMAT="%d/%m/%y %T "
    - mode: insert
    - before: export PATH USER LOGNAME MAIL HOSTNAME HISTSIZE HISTCONTROL

Deleting Old history format:
  file.line:
    - name: /etc/profile
    - mode: delete
    - match: HISTSIZE=1000

Updating Bash history size:
  file.line:
    - name: /etc/profile
    - content: HISTSIZE=5000
    - mode: insert
    - before: HISTTIMEFORMAT="%d/%m/%y %T "
