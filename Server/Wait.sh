#!/bin/bash


cd $1

value=`cat pid.txt`
echo "$value"
if [ -z "$value" ]; then
        echo Not PID info
        r=1
else
        kill -0 $value
        r=$?
fi



case "$r" in
        "0")
                echo "running"
                retcode=0;;
        "1")
                #error=`cat ./error.txt`
                #if [ -z "$error" ]; then
                #       echo "Finish"
                #       retcode=2
                #else
                #       echo $error
                #       retcode=1
                #fi
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