#!/bin/bash

if pgrep mpd 2>/dev/null
then
    pkill mpd
else
    mpd ; sleep 1 ; mpDris2 &
fi
