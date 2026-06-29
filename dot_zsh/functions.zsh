basename_without_extension() {
  echo ${1%.*}
}

watch_aria2c() {
  while inotifywait -qqe modify $1; do
    aria2c -i $1
  done
}

clip_watch() {
  wl-paste --watch sh -c 'printf "%s\n" "$(cat)"'
}

clip_notify() {
  while clipnotify; do
    echo $(wl-paste)
  done
}
