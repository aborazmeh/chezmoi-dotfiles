accepted_files = {
  '3gp',
  'flac',
  'mp4',
  'avi',
  'mkv',
  'mp3',
  'aac',
  'm4a',
  'm4b',
  'm4v',
  'webm',
  'mov',
  'm3u',
  'iso',
  'vob',
  'flv',
  'f4v',
  'mpg',
  'mpeg',
  'ogg',
  'oga',
  'ogv',
  'wav',
  'wmv',
  'opus',
}

local function accepted_ext(val)
  for index, value in ipairs(accepted_files) do
    if val and string.lower(val) == value then
      return true
    end
  end
  return false
end

local function is_url(val)
  if val:match('https?://.+$') then
    return true
  end
  return false
end

function is_dir(path)
  local f = io.open(path, "r")
  local ok, err, code = f:read(1)
  f:close()
  return code == 21
end

if not os.getenv("PLAY_ALL") then
  mp.observe_property('playlist-count', 'number', function ()
    local playlist = mp.get_property_native('playlist')
    for i = #playlist, 1, -1 do
      local extension = playlist[i].filename:match("^.+%.(.+)$")
      if not is_url(playlist[i].filename) and not is_dir(playlist[i].filename)and not accepted_ext(extension) then
        mp.commandv('playlist-remove', i-1)
      end
    end
  end)
end
