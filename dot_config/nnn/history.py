#!/usr/bin/python
import ast
import os
import sys

history_file = os.environ.get("NNN_HISTORY_FILE") or os.path.expanduser(
    "~/.config/nnn/history.txt"
)

history_idx = os.path.expanduser("~/.config/nnn/history_idx.txt")

with open(history_file) as history_fp:
    try:
        history = ast.literal_eval(history_fp.read())
        if not history:
            raise BaseException()
    except BaseException:
        exit(1)

    try:
        with open(history_idx) as idx_fp:
            history_idx = int(idx_fp.read())
            if history_idx > len(history):
                history_idx = len(history) - 1
    except BaseException as ex:
        history_idx = len(history) - 1

    if sys.argv[1] == "forward":
        history_idx += 1
    elif sys.argv[1] == "backward":
        history_idx -= 1
    else:
        exit(1)

    if history_idx <= 0 or history_idx >= len(history):
        exit(0)

    with open(history_idx, "w") as idx_fp:
        idx_fp.write(str(history_idx))

    # pipe.write('0c' + history[history_idx])
    print(history[history_idx], end="")
