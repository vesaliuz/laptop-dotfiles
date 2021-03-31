#!/usr/bin/env sh

## Add this to your wm startup file.

# Terminate already running bar instances
killall -q polybar

## Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

## Launch
polybar -l trace primary -c ~/.config/polybar/polybar-13/current.ini &
#polybar -l trace secondary -c ~/.config/polybar/polybar-13/current.ini &
#polybar -l trace top -c ~/.config/polybar/polybar-13/current.ini &

#polybar primary -c ~/.config/polybar/polybar-13/apps.ini &
#polybar secondary -c ~/.config/polybar/polybar-13/apps.ini &

# polybar primary -c ~/.config/polybar/polybar-13/system.ini &
# polybar secondary -c ~/.config/polybar/polybar-13/system.ini &
# 
# polybar primary -c ~/.config/polybar/polybar-13/mpd.ini &
# polybar secondary -c ~/.config/polybar/polybar-13/mpd.ini &
# 
# polybar primary -c ~/.config/polybar/polybar-13/workspace.ini &
# polybar secondary -c ~/.config/polybar/polybar-13/workspace.ini &
# 
# polybar primary -c ~/.config/polybar/polybar-13/cpu.ini &
# polybar secondary -c ~/.config/polybar/polybar-13/cpu.ini &
# 
# polybar primary -c ~/.config/polybar/polybar-13/memory.ini &
# polybar secondary -c ~/.config/polybar/polybar-13/memory.ini &
# 
# polybar primary -c ~/.config/polybar/polybar-13/fs.ini &
# polybar secondary -c ~/.config/polybar/polybar-13/fs.ini &
