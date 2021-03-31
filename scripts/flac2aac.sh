#!/bin/bash

for i in *".flac"
do
    ffmpeg -i "$i" -map 0 -c:a libfdk_aac -b:v 320k  "${i%%".flac"}.m4a"
done
