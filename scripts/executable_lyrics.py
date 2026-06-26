#!/usr/bin/env python

import sys
import os
import getopt
import urllib3
import html2text
from bs4 import BeautifulSoup
import wikipedia
from PIL import Image

# TODO: fetch the album art from last.fm/ Amazon or anywhere else.
# Fetching lyrics from the Internet... The following site may contain lyrics for this song:
# https://askyourright.wordpress.com/2013/07/14/%D9%84%D8%A3%D8%AC%D9%84-%D8%B9%D9%8A%D9%88%D9%86%D9%83-%D9%8A%D8%A7-%D8%AD%D9%85%D8%B5-%D9%84%D9%84%D8
# %A8%D8%B7%D9%84-%D8%B9%D8%A8%D8%AF-%D8%A7%D9%84%D8%A8%D8%A7%D8%B3%D8%B7-%D8%A7%D9%84%D8%B3%D8%A7/

opts, args = getopt.getopt(sys.argv[1:], "a:dt:di")

title, artist, lyrics = '', '', ''

for o, a in opts:
    if o in ("-t", "--title="):
        title = a.replace(" ", "+")
    elif o in ("-a", "--artist"):
        artist = a.replace(" ", "+")

urls = {'lyricswiki': 'http://lyrics.wikia.com/api.php?action=lyrics&fmt=xml&func=getSong&artist=' + artist + '&song=' + title,
        'azlyrics': 'https://www.google.com/search?q=' + artist + title + '+azlyrics.com&btnI=I%27m+Feeling+Lucky',
        'sing365': 'https://www.google.com/search?q=' + artist + title + '+sing365.com&btnI=I%27m+Feeling+Lucky',
        'metrolyrics': 'https://www.google.com/search?q=' + artist + title + '+metrolyrics.com&btnI=I%27m+Feeling+Lucky',
        'justsomelyrics': 'https://www.google.com/search?q=' + artist + title + '+justsomelyrics.com&btnI=I%27m+Feeling+Lucky',
        'rapgenius': 'https://www.google.com/search?q=' + artist + title + '+justsomelyrics.com&btnI=I%27m+Feeling+Lucky',
        }

artist = artist.lower()
if artist and not title:
    if not os.path.exists(("/tmp/mylyrics")):
        os.mkdir("/tmp/mylyrics")

    if not os.path.isfile("/tmp/mylyrics/"+artist+".txt"):
        artistfile = open("/tmp/mylyrics/"+artist+".txt", "w")
        artistfile.write(wikipedia.summary(artist, 2))
        artistfile.close()

    artistfile = open("/tmp/mylyrics/"+artist+".txt", "r")
    print(artistfile.read())
    artistfile.close()


    # Get the picture
    if not os.path.isfile("/tmp/mylyrics/"+artist+".jpg"):
        url = wikipedia.page(artist).url
        http = urllib3.PoolManager(timeout=3.0)
        respond = http.request('GET', url)
        tree = BeautifulSoup(respond.data)
        respond.release_conn()

        infobox = tree.select('table.infobox.vcard a.image img')
        img_url = infobox[0]['src'].replace("//", "http://")
        respond = http.request('GET', img_url)

        img = open("/tmp/mylyrics/" + artist + ".jpg", 'wb')
        img.write(respond.data)

        respond.release_conn()

        # Resize the image
        image_file = "/tmp/mylyrics/" + artist + ".jpg"
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

title = title.lower()
if title and not os.path.isfile("/tmp/mylyrics/"+artist+","+title+".txt"):
    for i in urls:
        if i == "lyricswiki":
            http = urllib3.PoolManager(timeout=3.0)
            respond = http.request('GET', urls[i])
            tree = BeautifulSoup(respond.data)
            respond.release_conn()

            if tree.find("lyrics").text.lower() == 'not found':
                continue
            else:
                url = tree.find("url").text
                respond = http.request('GET', url)
                tree = BeautifulSoup(respond.data)
                respond.release_conn()
                lyrics = tree.find_all('div', class_='lyricbox')
        else:
            pass

    lyrics = str(lyrics[0])
    lyrics = html2text.html2text(lyrics)

    lyricsfile = open("/tmp/mylyrics/"+artist+","+title+".txt", "w")
    lyricsfile.write(lyrics)
    lyricsfile.close()

elif title:
    lyricsfile = open("/tmp/mylyrics/"+artist+","+title+".txt", "r")
    print(lyricsfile.read())
    lyricsfile.close()
