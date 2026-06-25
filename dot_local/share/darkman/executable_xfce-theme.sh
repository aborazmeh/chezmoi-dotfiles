#!/bin/sh

case "$1" in
dark) THEME=Adwaita-dark ;;
light) THEME=Adwaita ;;
esac

exec xfconf-query -c xsettings -p /Net/ThemeName -s "$THEME"
