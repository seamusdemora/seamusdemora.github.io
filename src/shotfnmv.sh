#!/bin/zsh
# shotfnmv.sh
cd $HOME/TestShots
for afile in *.png
do
   echo $afile
   oldfile=$(basename "$afile")
   echo $oldfile
   if [[ $oldfile == *"Screen Shot"* ]]; then
     echo "Found an Apple-formatted Screen Shot file."

     oldtimestr=$(echo "$oldfile" | awk '{ printf "%s-%s_%s\n", $3, $5, substr($6,1,2) }')
     echo $oldtimestr
     newtimestr=$(date -j -f %Y-%m-%d-%I.%M.%S_%p "$oldtimestr" "+%Y-%m-%d-%T")
     echo $newtimestr
     newfile="screenshot-${newtimestr}.png"
     echo $newfile
#    mv "$oldfile" "$newfile"                   # overwrite fienames in place
     cp -np "$oldfile" "$newfile"               # copy file to same dir, new name
#    cp -np "$oldfile" ../TestShots2/"$newfile" # copy file to different dir, new name
  fi
done
