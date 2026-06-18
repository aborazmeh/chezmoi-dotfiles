
import json
import os
import sys
from xml.dom.expatbuilder import FragmentBuilderNS
import dbus
import html
import argparse
import time
import urllib.parse
from mutagen.mp3 import MP3
from mutagen.id3 import ID3
import magic
import re
import subprocess
import xmltodict


class Mprisplayer:
  """Class representing an MPRIS2 compatible media player"""

  mpris_base = 'org.mpris.MediaPlayer2'
  player_interface = mpris_base + '.Player'
  tracklist_interface = mpris_base + '.TrackList'
  playlists_interface = mpris_base + '.Playlists'
  # see http://dbus.freedesktop.org/doc/dbus-specification.html#standard-interfaces-properties # noqa
  properties_interface = 'org.freedesktop.DBus.Properties'

  def __init__(self, playername):
    """Initialize an Mprisplayer object for the specified player name"""
    bus = dbus.SessionBus()
    self.name = playername
    self.proxy = bus.get_object(self.name, '/org/mpris/MediaPlayer2')
    self.player = dbus.Interface(
      self.proxy, dbus_interface=self.player_interface)
    # tracklist is an optional interface, may be None depending on player
    self.tracklist = dbus.Interface(
      self.proxy, dbus_interface=self.tracklist_interface)
    # playlists is an optional interface, may be None depending on player
    self.playlists = dbus.Interface(
      self.proxy, dbus_interface=self.playlists_interface)
    self.properties = dbus.Interface(
      self.proxy, dbus_interface=self.properties_interface)
    # check if optional interfaces are available
    try:
      self.get_playlists_property('PlaylistCount')
    except dbus.exceptions.DBusException:
      self.playlists = None
    try:
      self.get_tracklist_property('CanEditTracks')
    except dbus.exceptions.DBusException:
      self.tracklist = None

  def base_properties(self):
    """Get all basic player properties"""
    return self.properties.GetAll(self.mpris_base)

  def player_properties(self):
    """Get all player properties"""
    return self.properties.GetAll(self.player_interface)

  def get_player_property(self, name):
    """Get the player property described by name"""
    return self.properties.Get(self.player_interface, name)

  def get_playlists_property(self, name):
    """Get the playlists property described by name"""
    return self.properties.Get(self.playlists_interface, name)

  def get_tracklist_property(self, name):
    """Get the tracklist property described by name"""
    return self.properties.Get(self.tracklist_interface, name)


def playerList():
  players = []
  bus = dbus.SessionBus()
  for s in bus.list_names():
    if s.startswith(Mprisplayer.mpris_base):
      players.append(s)
  return players


def _open_player(players, select):
  player = None
  try:
    no = int(select)
    player = Mprisplayer(players[no])
  except IndexError:
    print(f'MPRIS2 player no. {no} not found.')
  except ValueError:
    # no number provided, try name matching
    for s in players:
      if s.endswith(select):
        player = Mprisplayer(s)
    if player is None:
      print(f'MPRIS2 player "{select}" not found.')
  return player

# prioritize playing mpv, playing any other player, paused mpv, paused other players, then stopped mpv and other players
def getPlayer(players):
  def sortPlayers(e):
    status = e[1]['status']
    isMpv = e[0].name == 'org.mpris.MediaPlayer2.mpv'

    if status == 'Playing':
      return (1, isMpv)
    elif status == 'Paused':
      return (0, isMpv)
    else:
      return (-1, isMpv)

  plst = []
  for p in players:
    player = _open_player(players, p)

    if player:
      plst.append((player, getData(player)))

  return sorted(plst, reverse=True, key=sortPlayers).pop(0)[0]

def isMedia(fname):
  try:
    mime = magic.detect_from_filename(fname)
    return bool(re.search(r'^audio/.*|^video/.*', mime.mime_type)) or bool(re.search(r'^Audio file.*', mime.name))
  except:
    return False

def getFileAttributes(fname, files):
  try:
    file_extension = os.path.splitext(fname)[1]
    if file_extension.lower() == '.mp3':
      audio = MP3(fname)
      duration = audio.info.length
    else:
      result = subprocess.run(["ffprobe", "-v", "error", "-show_entries",
                            "format=duration", "-of",
                            "default=noprint_wrappers=1:nokey=1", fname],
      stdout=subprocess.PIPE,
      stderr=subprocess.STDOUT)
      duration = float(result.stdout)
  except:
    duration = 0

  try:
    id3 = ID3(fname)
    trackId = int(id3.get('TRCK'))
  except:
    trackId = files.index(fname) + 1

  return {
    'duration': duration,
    'trackId': trackId
  }

def getAttributes(dirname, currentFile):
  if not os.path.isdir(dirname):
    return
  durationFile = os.path.join(dirname, 'duration.json')
  allFiles = sorted([os.path.join(dirname, f) for f in os.listdir(dirname)])
  try:
    indexOfCurrent = allFiles.index(os.path.join(dirname, currentFile))
  except:
    indexOfCurrent = 0
  files = allFiles[indexOfCurrent:]
  filesList = {}

  try:
    with open(durationFile, 'r') as fp:
      obj = json.load(fp)
      if obj['files'] != allFiles or not obj.get('filesList'):
        raise
      return obj
  except:
    duration = 0
    for file in [f for f in files if isMedia(f)]:
      filesList[file] = getFileAttributes(file, files)
      if file in files:
        duration += filesList[file].get('duration')

    obj = {
      'files': allFiles,
      'filesList': filesList,
      'duration': duration
    }
    with open(durationFile, 'w') as fp:
      json.dump(obj, fp, ensure_ascii=True, indent=True)
  return obj


if __name__ == "__main__":
  from collections import deque

  players = playerList()

  parser = argparse.ArgumentParser(description="Manage an MPRIS2 "
                                    "compatible music player")
  parser.add_argument('-f', '--frontend',
                    help='Output frontend',
                    nargs="?", default="sway",
                    choices=('i3block', 'sway', 'hyprland', 'polybar'))
  parser.add_argument("command",
                      help='player command to execute, default: "status"',
                      nargs="?", default="status",
                      choices=('status', 'toggle', 'stop', 'next', 'prev', 'list', 'seek-', 'seek+', 'volume-', 'volume+', 'mute', 'bookmark'))
  player = players[0] if len(players) else None
  player_arg = parser.add_argument(
      '-p', '--player', default=player,
      help='Access the specified player, either by number as provided '
      'by the "players" command, or by name. Names are matched from the '
      f'end, so the last part is enough. default: {player}')
  parser.add_argument("-v", "--verbose", action="store_true",
                      help='enable extra output, useful for debugging')

  # # enable bash completion if argcomplete is available
  # try:
  #   import argcomplete
  #   from argcomplete.completers import ChoicesCompleter
  #   player_arg.completer = ChoicesCompleter(players)
  #   argcomplete.autocomplete(parser)
  # except ImportError:
  #   pass

  args = parser.parse_args()
  
  let file = File::open

  # if the command is "list", list available players and exit
  if args.command == "list":
    for i, s in enumerate(players):
      print(f'{i}: {s}')
      if args.verbose:
        player = _open_player(players, s)
        print(f'  playlists support:\t{bool(player.playlists)}')
        print(f'  tracklist support:\t{bool(player.tracklist)}')
        prop = player.base_properties()
        for s in prop.keys():
          print(f'  {s}\t= {prop.get(s)}')
    exit(0)

  # try to access the player via dbus
  player = getPlayer(players)
  if not player:
    exit(1)

  if os.path.isfile(os.path.expanduser('~/.silent_mode')) and player:
    player.player.Stop()
    exit()

  if args.verbose:
    print("selected player", player.name)
    print(f'  playlists support:\t{bool(player.playlists)}')
    print(f'  tracklist support:\t{bool(player.tracklist)}')
    prop = player.base_properties()
    for s in prop.keys():
      print(f'  {s}\t= {prop.get(s)}')
    print("player properties:")
    prop = player.player_properties()
    for k, v in prop.items():
      if k == 'Metadata':
        print('  current track metadata:')
        for mk, mv in v.items():
          print(f'    {mk}\t= {mv}')
      else:
        print(f'  {k}\t= {v}')

  # regular commands: run and exit


  elif args.command == 'bookmark':
    addBookmark(playerData)
