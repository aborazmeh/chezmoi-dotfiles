#!/bin/sh
# The names for the Arc theme variations are ambiguous:
# "Darker" is actually LESS DARK than "Dark".

case "$1" in
dark)
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
  sed -i 's/gtk-application-prefer-dark-theme=[0-1]/gtk-application-prefer-dark-theme=1/' ~/.config/gtk-[34]*/settings.ini
  ;;
light)
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
  sed -i 's/gtk-application-prefer-dark-theme=[0-1]/gtk-application-prefer-dark-theme=0/' ~/.config/gtk-[34]*/settings.ini
  ;;
default) exit 1 ;;
esac
