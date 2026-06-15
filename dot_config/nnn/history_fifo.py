#!/usr/bin/python3
import ast
import os

history_file = os.environ.get("NNN_HISTORY_FILE") or os.path.expanduser(
    "~/.config/nnn/history.txt"
)


def history_append(fp, dir):
    fp.seek(0)
    try:
        history = ast.literal_eval(fp.read())
    except:
        history = []

    if not history or history[-1] != current_dir:
        history.append(dir)
        fp.seek(0)
        fp.write(str(history))


with open(history_file, "w+") as history_fp, open("/tmp/nnn.fifo") as fifo:
    while True:
        for line in fifo:
            current_dir = os.path.dirname(line)
            history_append(history_fp, current_dir)
