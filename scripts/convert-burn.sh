#!/bin/bash

for i in *".mkv"
do
    new="$i"
    subtitle="$i"
    # make a temp hardlink to evade `ffmpeg`'s 
    # onerous quoting requirements.
    x=`mktemp -u -p . --suffix=.mkv`
    ln "$subtitle" $x
    < /dev/null ffmpeg -i "$i" -map 0:v -map 0:a -c:v libx265 -crf 25 -preset fast -vf scale=-2:480,subtitles=$x -c:a copy "${i%%".mkv"}_480p_x265.mp4"
    rm $x
    mv "$i" "${i%%".mkv"}.old"
    sleep 12
done
