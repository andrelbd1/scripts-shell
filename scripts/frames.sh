#!/bin/bash
location=$(pwd)
filecount=0

echo "Directory: "$location

for item in $location/*
do
  if [ -f "$item" ]
  then
    if [ ${item##*.} = "mp4" -o ${item##*.} = "mkv" -o ${item##*.} = "webm" ]; #filter by extension
    then
      filecount=$[$filecount+1]
      echo $item
      if [ ! -d ${item%.*} ]; #make a directory
      then
        mkdir ${item%.*}
      fi
      cd ${item%.*}
      duration=$(ffprobe -i $item -show_entries format=duration -v quiet -of csv="p=0") #get total time from video
      rate=0`echo "scale=2;$duration/100" | bc`; #in order to get over 100 frames      
      ffmpeg -i $item -r 1/$rate -vf scale=255:255 "frame_"%03d.jpg -hide_banner #saving frames     
      cd ..
    fi
  fi
done

echo $filecount " files"
