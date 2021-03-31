#!/bin/sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.5; done

# Auto detect hardware
export wificard="$(ls /sys/class/net | grep wifi)"
export ethernetcard="$(ls /sys/class/net | grep net)"
export cputhermalzone="$(for i in /sys/class/thermal/thermal_zone*; do
                      if [ $(cat $i/type) = "x86_pkg_temp" ]; then
                          echo $i
                      fi
                  done | grep -oP "\d+")"

[ "$wificard" ] && sed -i "s/wifi1/$wificard/g" ~/.config/polybar/config
[ "$ethernetcard" ] && sed -i "s/net1/$ethernetcard/g" ~/.config/polybar/config
[ "$cputhermalzone" ] && sed -i "s/thermal-zone\ =\ 10/thermal-zone\ =\ $cputhermalzone/g" ~/.config/polybar/config

# Launch Polybar, using default config location ~/.config/polybar/config
polybar -c ~/.config/polybar/bspwm.polybar top &
