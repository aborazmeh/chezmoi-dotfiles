#!/bin/bash - 

# Usage shutdown.sh (shutdown|suspend|hibernate).

action=$(yad --warning --center --on-top --width=300 --height=100 \
  --timeout=10 --timeout-indicator=bottom \
  --entry --title "System Logout" \
  --image=gnome-shutdown \
  --button="Switch User:3" \
  --button="gtk-ok:0" \
  --button="gtk-close:1" \
  --text "System will be suspended in 10 seconds.\nChoost action:" \
  --entry-text \
  "Suspend" "Power Off" "Reboot" "Logout" "Hibernate")
ret=$?

[[ $ret -eq 1 ]] && exit

if [[ $ret -eq 2 ]]; then
  gdmflexserver --startnew &
  exit 0
fi

if [[ $ret -eq 70 ]]; then
  action="Suspend"
fi

case $action in
  Suspend*)
    cmd="systemctl suspend" ;;
  Power*)
    cmd="systemctl poweroff" ;;
  Reboot*)
    cmd="systemctl reboot" ;;
  Logout*)
    case $(wmctrl -m | grep Name) in
      *Openbox) cmd="openbox --exit" ;;
      *FVWM) cmd="FvwmCommand Quit" ;;
      *Metacity) cmd="gnome-save-session --kill" ;;
      *awesome) cmd="echo 'awesome.restart()' | awesome-client" ;;
      *) exit 1 ;;
    esac
    ;;
  Hibernate*)
    cmd="systemctl hibernate" ;;
esac

eval exec $cmd




#if [[ $# -gt 0 ]]; then
#c=$1
#else
#c=$?
#fi

#c=$?
#case $c in
#"0" )
#exit;;
#"1" )
  #dbus-send --system --print-reply --dest=org.freedesktop.Hal \
    #/org/freedesktop/Hal/devices/computer \
    #org.freedesktop.Hal.Device.SystemPowerManagement.Suspend \
    #int32:0;
  #exit;;
#"70" )    # timeout
  #dbus-send --system --print-reply --dest=org.freedesktop.Hal \
    #/org/freedesktop/Hal/devices/computer \
    #org.freedesktop.Hal.Device.SystemPowerManagement.Suspend \
    #int32:0;
  #exit;;
#"suspend" )    # argv
  #dbus-send --system --print-reply --dest=org.freedesktop.Hal \
    #/org/freedesktop/Hal/devices/computer \
    #org.freedesktop.Hal.Device.SystemPowerManagement.Suspend \
    #int32:0;
  #exit;;
#"2" )
  #dbus-send --system --print-reply --dest=org.freedesktop.Hal \
    #/org/freedesktop/Hal/devices/computer \
    #org.freedesktop.Hal.Device.SystemPowerManagement.Shutdown \
    #int32:0;
  #exit;;
#"shutdown" )    # argv
  #dbus-send --system --print-reply --dest=org.freedesktop.Hal \
    #/org/freedesktop/Hal/devices/computer \
    #org.freedesktop.Hal.Device.SystemPowerManagement.Shutdown \
    #int32:0;
  #exit;;
##"3" )
  ##dbus-send --system --print-reply --dest=org.freedesktop.Hal \
    ##/org/freedesktop/Hal/devices/computer \
    ##org.freedesktop.Hal.Device.SystemPowerManagement.Hibernate \
    ##int32:0;
  ##exit;;
##"hibernate" )    # argv
  ##dbus-send --system --print-reply --dest=org.freedesktop.Hal \
    ##/org/freedesktop/Hal/devices/computer \
    ##org.freedesktop.Hal.Device.SystemPowerManagement.Hibernate \
    ##int32:0;
  ##exit;;
  #esac
