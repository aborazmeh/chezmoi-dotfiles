export NNN_OPTS="cErx"
# export NNN_OPENER="/path/to/custom/opener"	custom opener (see plugin nuke)
# export NNN_BMS="d:$HOME/Documents;D:$HOME/Docs archive/" 1	key-bookmark pairs
# export NNN_PLUG='o:fzopen;m:nmount;x:!chmod +x $nnn' 1	key-plugin (or cmd) pairs
# export NNN_ORDER='t:/home/user/Downloads;S:/usr/bin' 2	directory-specific ordering
# with `atool` or `bsdtar` and `(un)rar` and `archivemount`
export NNN_ARCHIVE="\\.(7z|a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|rar|rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)$"
# NNN_COLORS='1234' (/'#0a1b2c3d'/'#0a1b2c3d;1234') 4 6	context colors [default: '4444' (blue)]
if [[ -f ~/.cache/wal/colors-nnn.sh ]]; then
  # NNN_FCOLORS='c1e2272e006033f7c6d6abc4' 5	file-specific colors
  source ~/.cache/wal/colors-nnn.sh
fi
# export NNN_SSHFS='sshfs -o reconnect,idmap=user' 6	custom SSHFS cmd
# export NNN_RCLONE='rclone mount --read-only' 6	custom rclone cmd
# export NNN_TRASH=n (n=1: trash-cli, n=2: gio trash)	use desktop Trash [default: delete]
# export NNN_SEL='/tmp/.sel'	custom selection file
[[ ! -e /tmp/nnn.fifo ]] && mkfifo /tmp/nnn.fifo
# python ~/.config/nnn/history_fifo.py &
export NNN_FIFO='/tmp/nnn.fifo'
# export NNN_LOCKER='saidar -c'	terminal locker
# export NNN_TMPFILE='/tmp/.lastd'	always cd on quit
# export NNN_HELP='pwy paris'	run cmd, show o/p on help page
# export NNN_MCLICK='^R' (/'m') 8	key emulated by middle mouse click
# export NO_COLOR=1 9
export NNN_PLUG='j:jump;p:preview-tui;h:history-backward;l:history-forward'
