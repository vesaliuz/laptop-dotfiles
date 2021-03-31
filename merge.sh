#!/bin/bash

for i in *".mkv"
do
    mkvmerge -o "${i%%".mkv"}_.mkv" -d 0 -a 1 -s 2 --default-track 2:1 \
    "$i"
    mv "$i" "${i%%".mkv"}.old"
done
