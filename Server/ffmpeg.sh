#!/bin/bash


#Parameters
#1. GUID
#2. URL
#Add parameter filename
#Add parameter storageaccount
#add parameter storageaccountkey

ffmpeg=/home/lkmsft/node_modules/ffmpeg/ffmpeg-git-20161019-32bit-static/ffmpeg

echo "param 1 " $1
echo "param 2 " $2

assetURL=$2

assetName="temp.mp4"


wget $assetURL  -O  $assetName

if [ "$?" -ne "0"]; then
        echo "1" >> result.code
        exit 1
fi



$ffmpeg -y -i $assetName  -s 320x180 -y -strict experimental -acodec aac -ab 64k -ac 2 -ar 48000 -vcodec libx264 -vprofile baseline -level 30 -g 48 -b 200000 -threads 64 butterflyiphone_320.mp4

$ffmpeg -y -i $assetName -s 640x360 -y -strict experimental -acodec aac -ab 128k -ac 2 -ar 48000 -vcodec libx264 -vprofile baseline -level 30 -g 48 -b 520000 -threads 64 butterflyiphone_640.mp4

$ffmpeg -y -i $assetName -s 320x180 -y -strict experimental -acodec aac -ab 64k -ac 2 -ar 48000 -vcodec libx264 -vprofile main -g 48 -b 270000 -threads 64 butterfly_400.mp4

$ffmpeg -y -i $assetName -s 420x270 -y -strict experimental -acodec aac -ab 64k -ac 2 -ar 48000 -vcodec libx264 -vprofile main -g 48 -b 570000 -threads 64 butterfly_700.mp4

$ffmpeg -y -i $assetName -s 720x406 -y -strict experimental -acodec aac -ab 128k -ac 2 -ar 48000 -vcodec libx264 -vprofile main -g 48 -b 1000000 -threads 64 butterfly_1100.mp4

$ffmpeg -y -i $assetName -s 1024x576 -y -strict experimental -acodec aac -ab 128k -ac 2 -ar 48000 -vcodec libx264 -vprofile main -g 48 -b 1200000 -threads 64 butterfly_1300.mp4

$ffmpeg -y -i $assetName -s 1080x608 -y -strict experimental -acodec aac -ab 128k -ac 2 -ar 48000 -vcodec libx264 -vprofile main -g 48 -b 1400000 -threads 64 butterfly_1500.mp4


rm $assetName

export AZURE_STORAGE_ACCOUNT="use storage account name"
export AZURE_STORAGE_ACCESS_KEY="storage account key"


export container_name=$1

azure storage container create $container_name


FILES=./*.mp4
pre="./"

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