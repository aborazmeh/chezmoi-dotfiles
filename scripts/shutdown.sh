#!/bin/bash - 

# Usage shutdown.sh (shutdown|suspend|hibernate).

yad --warning --center --on-top --sticky \
  --width=200 --height=100 \
  --title="Shutdown" --text="System will suspend in 60 seconds,\nare you sure you want to do this?" \
  --button=Cencel:0 --button=Suspend:1 --button=Shutdown:2 \
  --timeout=60 --timeout-indicator=bottom

if [[ $# -gt 0 ]]; then
  c=$1
else
  c=$?
fi

case $c in
  "0" )
    exit;;
  "1" )
    dbus-send --system --print-reply --dest=org.freedesktop.Hal \
      /org/freedesktop/Hal/devices/computer \
      org.freedesktop.Hal.Device.SystemPowerManagement.Suspend \
      int32:0;;
  "70" )    # timeout
    dbus-send --system --print-reply --dest=org.freedesktop.Hal \
      /org/freedesktop/Hal/devices/computer \
      org.freedesktop.Hal.Device.SystemPowerManagement.Suspend \
      int32:0;;
  "suspend" )    # argv
    dbus-send --system --print-reply --dest=org.freedesktop.Hal \
      /org/freedesktop/Hal/devices/computer \
      org.freedesktop.Hal.Device.SystemPowerManagement.Suspend \
      int32:0;;
  "2" )
    dbus-send --system --print-reply --dest=org.freedesktop.Hal \
      /org/freedesktop/Hal/devices/computer \
      org.freedesktop.Hal.Device.SystemPowerManagement.Shutdown \
      int32:0;;
  "shutdown" )    # argv
    dbus-send --system --print-reply --dest=org.freedesktop.Hal \
      /org/freedesktop/Hal/devices/computer \
      org.freedesktop.Hal.Device.SystemPowerManagement.Shutdown \
      int32:0;;
  #"3" )
    #dbus-send --system --print-reply --dest=org.freedesktop.Hal \
      #/org/freedesktop/Hal/devices/computer \
      #org.freedesktop.Hal.Device.SystemPowerManagement.Hibernate \
      #int32:0;;
  #"hibernate" )    # argv
    #dbus-send --system --print-reply --dest=org.freedesktop.Hal \
      #/org/freedesktop/Hal/devices/computer \
      #org.freedesktop.Hal.Device.SystemPowerManagement.Hibernate \
      #int32:0;;
esac
