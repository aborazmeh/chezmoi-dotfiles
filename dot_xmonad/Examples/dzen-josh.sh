#!/bin/sh

UPDATE=1
SYSTEM=`uname -sr`

while :; do
    DATE=`date +"%a %B %d, %I:%M %p"`
    BATTERY=`sysctl -n hw.acpi.battery.life`
    # if xmms2d is running
    if pgrep xmms2d > /dev/null ; then
        # another if statement, stopped or not
        if [ `nyxmms2 status -f "\\${playback_status}"` = "Stopped" ]; then
            XMMS2=" ^fg(green)XMMS2 is stopped^fg() |"
        else
            XMMS2=" ^fg(green)`nyxmms2 status | grep -Eo '^[^:]+:[^:]+'`^fg() |"
        fi
    else
        XMMS2=""
    fi
    echo "^fg(red)$SYSTEM^fg() |$XMMS2 ^fg(#00FFFF)$BATTERY%^fg() | ^fg(orange)$DATE^fg() "
    sleep $UPDATE
done | dzen2 -fn '-*-terminus-medium-r-*-*-12-*-*-*-*-*-*-*' -bg '#222222' -fg '#aaaaaa' -w 840 -ta r -x 840
