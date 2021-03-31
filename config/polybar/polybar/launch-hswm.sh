#!/usr/bin/env sh

# More info : https://github.com/jaagr/polybar/wiki

# Install the following applications for polybar and icons in polybar if you are on ArcoLinuxD
# awesome-terminal-fonts
# Tip : There are other interesting fonts that provide icons like nerd-fonts-complete

killall -q polybar
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done
desktop=$(echo $DESKTOP_SESSION)
count=$(xrandr --query | grep " connected" | cut -d" " -f1 | wc -l)
polybar --reload mainbar-herbstluftwm -c ~/.config/polybar/config.hswm &
