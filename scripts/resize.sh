#!/bin/bash
location=$(pwd)
dircount=0
filecount=0

echo "Directory: "$location

for item in $location/*
do
  if [ -d "$item" ]
  then
    dircount=$[$dircount+1]
    dir="$item"   
    echo $item
    for subdir in $dir/*
    do
      if [ -d "$subdir" ]
      then
        subdircount=$[$subdircount+1]
        itemdir="$subdir"
        echo $subdir
        for itemdir in $subdir/*
        do
          if [ -f "$itemdir" ]
          then
            if [ ${itemdir##*.} = "jpg" -o ${itemdir##*.} = "jpeg" -o ${itemdir##*.} = "png" ]; #extension
            then
              filecount=$[$filecount+1]
              convert $itemdir -resize 299x299 $itemdir
              echo ${itemdir%.*}           
            fi
          fi
        done
      fi
    done
  fi
done

echo $filecount " files"
echo $dircount " directory"
echo $subdircount " subdiretórios"
