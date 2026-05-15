#!/bin/bash

rofi -show calc -modi calc -no-show-match -no-sort -calc-command "echo '{result}' | xclip -selection clipboard"
