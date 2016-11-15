#!/bin/bash

#Parameters
#1 script
#2 guid
#3 all others

mkdir $2
cd $2

string=$*


myParameters=( "$@")
myCommand=""

for i in `seq 0 $#`;
        do
                echo ${myParameters[i]}
                myCommand+=" '${myParameters[i]}'"
        done

echo $myCommand > command.sh

echo "Lunch process"
nohup bash command.sh >std.txt 2>error.txt &



pgrep -P $BASHPID >> pid.txt