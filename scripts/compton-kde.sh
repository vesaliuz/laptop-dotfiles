#!/usr/bin/env sh


#### Starts compton on kde-openbox session
#### V.0.1 2020-01-03

## Terminates any running compton session
killall -q picom

## Wait until the processes have been shut down
while pgrep -u $UID -x picom > /dev/null; do sleep 1; done

desktop=$(echo $DESKTOP_SESSION)

if [ "$desktop" == '/usr/share/xsessions/plasma' ] ; then
    /usr/bin/picom -b --experimental-backends --config $HOME/.config/picom.conf
fi

###EOF
