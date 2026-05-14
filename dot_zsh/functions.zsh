basename_without_extension() {
  echo ${1%.*}
}

watch_aria2c() {
  while inotifywait -qqe modify $1; do
    aria2c -i $1
  done
}

