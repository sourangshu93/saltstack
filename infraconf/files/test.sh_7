remoteip=$(who am i | awk '{print $5}' | sed "s/[()]//g")
export PROMPT_COMMAND='RETRN_VAL=$?;logger -p local3.debug "$(whoami)  $remoteip  [$$]: $(history 1 | sed "s/^[ ]*[0-9]\+[ ]*//") [$RETRN_VAL]"'
