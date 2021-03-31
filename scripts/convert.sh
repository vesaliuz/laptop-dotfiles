#!/bin/bash

countdown() {
  secs=$1
  shift
  msg=$@
  while [ $secs -gt 0 ]
  do
    printf "\r\033[KWaiting %.d seconds $msg" $((secs--))
    sleep 1
  done
  echo
}
        
for i in *".mkv"
do
    countdown 5 "Press Ctrl-C to stop"
    echo "####################"
    printf "\n"
    echo "Converting $i"
    echo "####################"
    printf "\n\n"
    ffmpeg -i "$i" -map 0 -c:v libx265 -crf 23 -preset veryfast  -c:a libopus -b:a 192k -c:s copy  "${i%%".mkv"}_x265_AAC.mkv"
    ## audio only
#    ffmpeg -i "$i" -map 0 -c:v copy -c:a libopus -b:a 128k -c:s copy "${i%%".mkv"}_x265_Opus.mkv"
    # To set sub as default
# ffmpeg -i "$i"  -map 0 -map -0:1 -map -0:3 -c:v libx265 -crf 25 -preset fast -c:a libopus -b:a 128k -c:s copy -disposition:s:0 default "${i%%".mkv"}_x265_Opus.mkv"
    
    # Downmix to stereo
#  ffmpeg -i "$i"  -map 0 -c:v libx265 -crf 22 -preset veryfast -c:a libopus -ac 2 -b:a 160k -c:s copy  "${i%%".mkv"}.x265.Opus.mkv"
    
    mv "$i" "${i%%".mkv"}.mkv"
    printf "####################\n\nDONE\n"
done
echo "Conversion Finished"
