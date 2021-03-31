#!/usr/bin/env sh


#### Starts compton on kde-openbox session
#### V.0.1 2020-01-03

## Terminates any running compton session
killall -q picom

## Wait until the processes have been shut down
while pgrep -u $UID -x picom > /dev/null; do sleep 1; done

desktop=$(echo $DESKTOP_SESSION)

if [ "$desktop" == 'openbox-kde' ] ; then
    /usr/bin/picom -b --config $HOME/.config/picom.conf
    /usr/bin/sxhkd -c $HOME/.config/sxhkd/sxhkdrc
fi

###EOF
