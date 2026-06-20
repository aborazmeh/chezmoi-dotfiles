local utils = require 'mp.utils'

local home = os.getenv("HOME") or os.getenv("USERPROFILE")

local options = {
  nerd = true
}

function log(string, secs)
  secs = secs or 2.5  -- secs defaults to 2.5 when secs parameter is absent
  mp.msg.warn(string)      -- This logs to the terminal
  mp.osd_message(string, secs) -- This logs to MPV screen
end

function get_info ()
  log('Getting movie information...', 10)
  _, filename = utils.split_path(mp.get_property('path'))

  local table = { args = { 'python' } }
  local a = table.args

  a[#a +1 ] = home .. '/.config/mpv/scripts/movie-info/movie-info.py'
  if options.nerd then
    a[#a + 1] = '--nerd'
  end
  a[#a + 1] = filename
  local result = utils.subprocess(table)
  if result.status == 0 then
    log(result.stdout, 10)
  else
    log("Failure in extracting movie info")
  end
end

function open_imdb_link()
  log('Opening IMDB Page...')
  _, filename = utils.split_path(mp.get_property('path'))

  local table = { args = { 'python' } }
  local a = table.args
  local url = nil

  a[#a +1 ] = home .. '/.config/mpv/scripts/movie-info/movie-info.py'
  a[#a + 1] = '--url'
  a[#a + 1] = filename
  local result = utils.subprocess(table)
  if result.status == 0 then
    url = result.stdout
  else
    log("Failure in opening IMDB page")
  end

  if url then
    local table = { args = { 'xdg-open' } }
    local a = table.args
    a[#a +1 ] = url
    utils.subprocess(table)
end
end

mp.add_key_binding('i', 'get_movie_info', get_info)
mp.add_key_binding('I', 'open_imdb_link', open_imdb_link)
