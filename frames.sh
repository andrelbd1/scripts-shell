#!/bin/bash
location=$(pwd)
filecount=0
format="png"  # jpg|png etc
scale_w=640
scale_h=400
default_total=10

if [-n $1]; #get argument number of frames
then
  total_frames=$1;
else
  total_frames=$default_total;
fi
  
echo "Directory: "$location

for item in $location/*
do
  if [ -f "$item" ]
  then
    if [ ${item##*.} = "mp4" -o ${item##*.} = "mkv" -o ${item##*.} = "webm" ]; #filter by extension
    then
      filecount=$[$filecount+1]
      echo "$item"
      if [ ! -d "${item%.*}" ]; #make a directory
      then
        mkdir "${item%.*}"
      fi
      cd "${item%.*}"
      duration=$(ffprobe -i "$item" -show_entries format=duration -v quiet -of csv="p=0") #get total time from video
      rate=0`echo "scale=2;$duration/($total_frames-1)" | bc`; #in order to get over N frames
      ffmpeg -i "$item" -r 1/$rate -vf scale=$scale_w:$scale_h "frame_"%03d.$format -hide_banner #saving frames
      cd ..
    fi
  fi
done

echo $filecount " files"
