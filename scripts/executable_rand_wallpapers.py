#!/usr/bin/env python

import os
import sys
import imghdr
import random

pictures = []

for a,b,files in os.walk(sys.argv[1]):
    for i in files:
        if imghdr.what(a+"/"+i):
            pictures.append(a+"/"+i)

print(random.choice(pictures))
