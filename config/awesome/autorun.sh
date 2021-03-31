#!/usr/bin/env bash

function run {
  if ! pgrep -f $1 ;
  then
    $@&
  fi
}

picom -b &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
nm-applet --no-agent &
pkill redshift && redshift &
variety &
