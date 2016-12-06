#!/bin/bash

#######################################
# Main script that is called by the client
# Globals:
#  This script is called by the client and executes the script that was passed as a parameter. 
# Arguments:
#   1. Name of the script to be executed
#   2. TransactionID in form of GUID
#   3. The parameters to be passed to the script.  
# Returns:
#   None
########################################

# create a directory with the name of the transaction id(GUID)
mkdir $2

# Switch to the directory just created
cd $2

# read all the parameters
string=$*

# Reading the parameter
myParameters=( "$@")
myCommand=""

#looping through the parameter and generating the command to be executed

for i in `seq 0 $#`;
        do
                echo ${myParameters[i]}
                myCommand+=" '${myParameters[i]}'"
        done

# saving the command line as command.sh
echo $myCommand > command.sh

#executing the command.sh

echo "Lunch process"
nohup bash command.sh >std.txt 2>error.txt &


# capturing the process id and writing to pid.txt 
pgrep -P $BASHPID >> pid.txt