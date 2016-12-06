#!/bin/bash

#######################################
# Custome SCRIPT: Run FFMPEG commands
# Globals:
# AZURE_STORAGE_ACCOUNT
# AZURE_STORAGE_ACCESS_KEY
# container_name
# Arguments:
#   1. Transaction ID
#   2. URL of the source Video file name 
#   3. Filename prefix
#   4. Storageaccount Name
#   5. Storageaccountkey.
# Returns:
#   None
########################################

# Capture starting transcoding time.
START=$(date +%s)

# ffmpeg binary location
ffmpeg=/home/lkmsft/node_modules/ffmpeg/ffmpeg-git-20161019-32bit-static/ffmpeg

#printing the value of parameter.
  
echo "param 1 " $1
echo "param 2 " $2

# reading parameters and assigning to local variables. 

assetURL=$2
filename=$3
storageacct=$4
storagekey=$5

assetName="temp.mp4"

# download the source video from url location and assign the assetname.  
wget $assetURL  -O  $assetName

# return error if fail to download.

if [ "$?" -ne "0"]; then
        echo "1" >> result.code
        exit 1
fi

# execute transcode command with the source file to various bitrates.  Assign name of output file with prefix from parameter(filename) + bitrate info.  


$ffmpeg -y -i $assetName  -s 320x180 -y -strict experimental -acodec aac -ab 64k -ac 2 -ar 48000 -vcodec libx264 -vprofile baseline -level 30 -g 48 -b 200000 -threads 64 "$3_320.mp4"

$ffmpeg -y -i $assetName -s 640x360 -y -strict experimental -acodec aac -ab 128k -ac 2 -ar 48000 -vcodec libx264 -vprofile baseline -level 30 -g 48 -b 520000 -threads 64 "$3_640.mp4"

$ffmpeg -y -i $assetName -s 320x180 -y -strict experimental -acodec aac -ab 64k -ac 2 -ar 48000 -vcodec libx264 -vprofile main -g 48 -b 270000 -threads 64 "$3_400.mp4"

$ffmpeg -y -i $assetName -s 420x270 -y -strict experimental -acodec aac -ab 64k -ac 2 -ar 48000 -vcodec libx264 -vprofile main -g 48 -b 570000 -threads 64 "$3_700.mp4"

$ffmpeg -y -i $assetName -s 720x406 -y -strict experimental -acodec aac -ab 128k -ac 2 -ar 48000 -vcodec libx264 -vprofile main -g 48 -b 1000000 -threads 64 "$3_1100.mp4"

$ffmpeg -y -i $assetName -s 1024x576 -y -strict experimental -acodec aac -ab 128k -ac 2 -ar 48000 -vcodec libx264 -vprofile main -g 48 -b 1200000 -threads 64 "$3_1300.mp4"

$ffmpeg -y -i $assetName -s 1080x608 -y -strict experimental -acodec aac -ab 128k -ac 2 -ar 48000 -vcodec libx264 -vprofile main -g 48 -b 1400000 -threads 64 "$3_1500.mp4"


#delete the mezzanine file
rm $assetName

# upload outof file to Azure storage. 

export AZURE_STORAGE_ACCOUNT=$storageacct
export AZURE_STORAGE_ACCESS_KEY=$storagekey

export container_name=$1

# create a storage container
azure storage container create $container_name

# CREATING A LIST
FILES=./*.mp4

# string preset name to purse after
pre="./"

# loop through the list and upload each file to Azure Blob
for f in $FILES
do
        foo=${f#$pre}
        echo $foo

 foo=${f#$pre}
        echo $foo
        export blob_name=$foo
        export image_to_upload=$foo
        export destination_folder="folder"
        echo "Uploading the image..."
        azure storage blob upload $image_to_upload $container_name $blob_name


done


echo "0" >> ./result.code