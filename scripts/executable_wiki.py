#!/usr/bin/env python

import sys
import os
import urllib3
import html2text
from bs4 import BeautifulSoup
import wikipedia
from PIL import Image

print(wikipedia.summary(sys.argv[1], 4))

# Get the picture
if not os.path.exists("/tmp/mywiki"):
    os.mkdir("/tmp/mywiki")

if not os.path.isfile("/tmp/mywiki/" + sys.argv[1].lower() + ".jpg") or os.stat("/tmp/mywiki/" + sys.argv[1].lower() + ".jpg").st_size <= 0:
    url = wikipedia.page(sys.argv[1]).url
    http = urllib3.PoolManager()
    respond = http.request('GET', url)
    tree = BeautifulSoup(respond.data)
    respond.release_conn()

    infobox = tree.select('table.infobox.vcard a.image img')
    img_url = infobox[0]['src'].replace("//", "http://")
    respond = http.request('GET', img_url)

    img = open("/tmp/mywiki/" + sys.argv[1].lower() + ".jpg", 'wb')
    img.write(respond.data)

    respond.release_conn()

    # Resize the image
    image_file = "/tmp/mywiki/" + sys.argv[1].lower() + ".jpg"
    img_org = Image.open(image_file)
    width_max = 75
    height_max = 100
    width_org, height_org = img_org.size
    width_frac = width_org / width_max
    height_frac = height_org / height_max
    factor=1
    if width_frac > 1 or height_frac > 1:
        if width_frac > height_frac:
            factor = width_max / width_org
        else:
            factor = height_max / height_org
    width = int(width_org * factor)
    height = int(height_org * factor)
    img_anti = img_org.resize((width, height), Image.ANTIALIAS)
    img_anti.save(image_file)
