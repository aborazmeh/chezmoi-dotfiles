#!/usr/bin/env python3

# based on /usr/share/doc/newsboat/contrib/exportOPMLWithTags.py
# this script exports the urls file to OPML, including sections. for that, all feeds must be under a section

# usage: ./urls-to-opml.py urls

import csv
import os
import re
import sqlite3
import sys
from xml.dom import minidom
from xml.etree import ElementTree as ET


def read_feed_title(line: list[str]) -> str | None:
    if m := re.match(r"https?://(?:www\.)?reddit.com/r/(.+?)/\.rss", line[0]):
        return f"Reddit: r/{m.group(1)}"

    return next(
        (x.removeprefix("~") for x in line[1:] if x.startswith("~")),
        None,
    )


def read_feeds() -> list[dict]:
    if len(sys.argv) < 2:
        print("not input file, using urls instead")
        filename = "urls"
    else:
        filename = sys.argv[1]

    if not os.path.isfile(filename):
        raise Exception(f"{filename} not found")

    feeds = []
    with open(filename) as f:
        reader = csv.reader(f, delimiter=" ")
        section = None

        for line in list(reader):
            if not len(line) or line[0].startswith("#"):
                # print(f"ignoring this line:\n{' '.join(line)}", file=sys.stderr)
                continue

            if not line[0].startswith("http"):
                section = " ".join(line)
                continue
            else:
                if not section:
                    raise Exception(f"no section for feed {line[0]}")

                feeds.append(
                    {
                        "section": section,
                        "url": line[0],
                        # title is the tag which starts with tilda
                        "title": read_feed_title(line),
                        "tags": [x for x in line[1:] if not x.startswith("~")],
                    }
                )
    return feeds


def get_titles_from_cachedb() -> list:
    try:
        cache_path = f"{os.environ['HOME']}/.local/share/newsboat/cache.db"
        if not os.path.exists(cache_path):
            cache_path = f"{os.environ['HOME']}/.newsboat/cache.db"

        with sqlite3.connect(cache_path) as conn:
            conn.row_factory = sqlite3.Row
            c = conn.cursor()
            c.execute("select rssurl,title from rss_feed")
            return c.fetchall()
    except sqlite3.OperationalError:
        return []


def get_feed_title(feed: dict) -> str:
    if feed.get("title"):
        return feed["title"]

    # look for the title among the cached ones
    for row in get_titles_from_cachedb():
        if row["rssurl"] == feed["url"]:
            return row["title"]

    # that is, this feed's title isn't in ~/.newsboat/cache.db
    try:
        # TODO
        import feedparser

        print(f"getting title from {feed['url']}", file=sys.stderr)
        return feedparser.parse(feed["url"])["feed"]["title"]
    except (ModuleNotFoundError, KeyError):
        # can't get title neither from cache.db nor the xml of the feed,
        # so left title blank
        return ""


def write_opml(root: ET.Element) -> None:
    try:
        with open("urls.opml", "w") as fp:
            fp.write(minidom.parseString(ET.tostring(root)).toprettyxml(indent="  "))
        print("urls.opml was written successfully")
    except Exception as ex:
        raise Exception(f"Error while writing urls.opml: {ex}")


if __name__ == "__main__":
    try:
        feeds = read_feeds()

        root = ET.Element("opml", version="2.0")
        head = ET.SubElement(root, "head")
        body = ET.SubElement(root, "body")

        for feed in feeds:
            if not len(body):  # body has no children
                tag = ET.SubElement(body, "outline", type="rss", title=feed["section"])
            elif feed["section"] not in [
                o.attrib["title"] for o in body.findall("outline")
            ]:
                # that is, this tag doesn't exist yet
                tag = ET.SubElement(body, "outline", type="rss", title=feed["section"])

            for tag in body.findall("outline"):
                if tag.attrib["title"] == feed["section"]:
                    # that is, this is the tag we are looking for
                    xml_feed = ET.SubElement(
                        tag, "outline", type="rss", xmlUrl=feed["url"]
                    )
                    xml_feed.set("title", get_feed_title(feed))
                    xml_feed.set("tags", ",".join(feed["tags"]))
        write_opml(root)

    except Exception as e:
        print(e)
