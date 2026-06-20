#!/usr/bin/env python
import re
import sys
import requests
import urllib.parse
import bs4
import os
import json
import argparse

json_filename = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'movie-info.json')

headers = {
  # 'Accept-Language': 'tr-TR,tr;q=0.9,en-US;q=0.8,en;q=0.7,ar-SY;q=0.6,ar;q=0.5,fr-FR;q=0.4,fr;q=0.3,fa-IR;q=0.2,fa;q=0.1',
  'Sec-Ch-Ua': '"Google Chrome";v="111", "Not(A:Brand";v="8", "Chromium";v="111"',
  'Sec-Fetch-Site': 'same-origin',
  'Sec-Fetch-Mode': 'navigate',
  'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36',
  'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
  'Sec-Fetch-User': '?1',
  'Accept-Encoding': 'gzip, deflate, br',
  'Sec-Ch-Ua-Mobile': '?0',
  'Sec-Ch-Ua-Platform': "Linux",
  'Upgrade-Insecure-Requests': '1',
}

session = requests.session()

def find_on_imdb(title):
  try:
    return find_movie_cinemagoer(title)
  except:
    return find_movie_html(title)


def find_movie_html(name):
  url = 'https://www.imdb.com/find/?s=all&q=' + urllib.parse.quote_plus(name)
  res = session.get(url, headers=headers)
  html = bs4.BeautifulSoup(res.text, features='html.parser')
  ul = html.find('ul', class_='ipc-metadata-list')
  a = ul.find('a')
  return get_info_html('https://www.imdb.com' + a.attrs['href'])

def find_movie_cinemagoer(name):
  from imdb import Cinemagoer

  ia = Cinemagoer()
  movies = ia.search_movie(name)

  if not len(movies):
    raise BaseException()

  movie = ia.get_movie(movies[0].movieID, info=['main', 'plot'])

  return {
    'id': movie.get('imdbID'),
    'title': movie.get('title'),
    'year': movie.get('year'),
    'length': movie.get('runtimes')[0],
    'genres': ", ".join(movie.get('genres')),
    'rating': movie.get('rating'),
    'director': ', '.join([str(x) for x in movie.get('director')]),
    'writer': ', '.join([str(x) for x in movie.get('writer')]),
    'stars': ', '.join([str(x) for x in movie.get('cast')][:4]),
    'synopsis': movie.get('plot outline')
  }

def get_info_html(url):
  res = session.get(url, headers=headers)
  html = bs4.BeautifulSoup(res.text, features='html.parser')

  title, year, genres, length, pg, directors, writers, stars, synopsis, rating = (None for x in range(10))
  title = html.find('h1').text

  yrl_ul = html.select_one('h1 + div > ul')
  if yrl_ul:
    year = yrl_ul.select_one('li:nth-child(1) > span').text
    pg = yrl_ul.select_one('li:nth-child(2) > span').text
    length = yrl_ul.select_one('li:nth-child(3)').text

  genres = [x.text for x in html.select('.ipc-chip-list__scroller a')]

  return {
    'title': title,
    'year': year,
    'pg': pg,
    'length': length,
    'genres': ", ".join(genres),
  }

def find_in_json(name):
  try:
    with open(json_filename, 'r') as fp:
      movies = json.load(fp)
      return movies.get(name)
  except:
    return False

def output(name, info, nerd=False):
  update_json(name, info)
  
  icons = {
    'director': '󰿎',
    'writer': '󰼭',
    'starring': '',
    'tags': '',
    'script-text': '󰯂',
  }

  nerd_icon = lambda x, y: icons.get(x) + '  ' if nerd and x.lower() in icons else y

  text = f"{info.get('title')} ({info.get('year')})  {info.get('rating')}/10 ★\n"
  text += nerd_icon('tags', '') + info.get('genres') + '\n'
  text += '----\n'
  text += nerd_icon('director', 'Director: ') + info.get('director') + '\n'
  text += nerd_icon('writer', 'Writer: ') + info.get('writer') + '\n'
  text += nerd_icon('starring', 'Starring: ') + info.get('stars') + '\n'
  text += '----\n'
  text += nerd_icon('script-text', '') + info.get('synopsis') + '\n'
  print(text)

def update_json(name, info):
  try:
    with open(json_filename, 'r') as fp:
      movies = json.load(fp)
  except:
    movies = {}

  with open(json_filename, 'w') as fp:
    movies[name] = info
    json.dump(movies, fp)

def clean_title(filename):
  title = '.'.join(filename.split('.')[:-1])
  title = re.sub(r'x26[45]|((720|1080|2160)p|hsbs)|4k|\d+bit|(bluray|brrip|webrip)|(repack|extended|unrated)|aac[\d.]+|(yify|\[.*?\])', '', title.replace('.', ' '), flags=re.I).strip()
  return title

def get_url(title):
  with open(json_filename, 'r') as fp:
    movies = json.load(fp)
    return 'https://www.imdb.com/title/tt' + movies.get(title).get('id')

if __name__ == '__main__':
  parser=argparse.ArgumentParser()
  parser.add_argument('title')
  parser.add_argument('--nerd', action='store_true')
  parser.add_argument('--url', action='store_true')
  if len(sys.argv)==1:
    parser.print_help(sys.stderr)
    sys.exit(1)

  args = parser.parse_args()

  title = clean_title(args.title)

  if args.url:
    try:
      print(get_url(title))
    except:
      find_on_imdb(title)
      print(get_url(title))

  else:
    output(title, find_in_json(title) or find_on_imdb(title), nerd=args.nerd)
