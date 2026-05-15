#!/bin/bash

idate | sed -n '4p' | grep -oh  '[0-9]\{1,2\}/[ 0-9]\{1,2\}/[0-9]\{4\}' | sed -s 's/ //' | head -n1
