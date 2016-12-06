#!/bin/bash

#######################################
# Call to check the process status.
# Globals:
# Arguments:
#   TransactionID
# Returns:
#   0 if still running
#   1.if error
#   2.if succesfull
########################################

# change to the right director
cd $1

# reading the operation system process ID
value=`cat pid.txt`
echo "$value"

# Checking if the process is active.  
if [ -z "$value" ]; then
        echo Not PID info
        r=1
else
        kill -0 $value
        r=$?
fi


# return if the process still running, 1 if there is an error and 2 if the process if successful
case "$r" in
        "0")
                echo "running"
                retcode=0;;
        "1")
                
                cod=`cat ./result.code`
                if [ "$cod" -eq "0" ]; then
                        echo ok
                        retcode=2
                else
                        echo nok
                        retcode=1
                fi
                ;;
esac

exit $retcode