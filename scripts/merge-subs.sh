#!/bin/bash

for i in *".mkv"
do
    mkvmerge -o "${i%%".mkv"}_sub.mkv" -d 0 -a 1 "$i" \
    --language 0:eng --track-name 0:English --sub-charset 0:ISO-8859-1  "${i%%".mkv"}.ass"
    mv "$i" "$i".old
done
