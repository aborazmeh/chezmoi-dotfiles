-- TODO interactive downloading with subdl (choose found subtitles)
package.path = package.path .. ';' .. mp.find_config_file('scripts') .. '/?.lua'
require('uosc/lib/std')
local languages = require('autosub/languages')
local home = os.getenv("HOME") or os.getenv("USERPROFILE")

-- local options = require 'mp.options'

-- TODO move to autosub.conf
options = {
  subliminal_path = home .. '/.local/bin/subliminal',
  subdl_path = '/usr/bin/subdl',
  preferred_app = 'subdl',
  languages = 'ar,en,tr',
  auto = true,   -- Automatically download subtitles, no hotkeys required
  debug = true, -- Use `--debug` in subliminal command for debug output
  force = false,  -- Force download; will overwrite existing subtitle files
  utf8 = false,   -- Save all subtitle files as UTF-8
}

--=============================================================================
-->>  PROVIDER LOGINS:
--=============================================================================
--      These are completely optional and not required
--      for the functioning of the script!
--      If you use any of these services, simply uncomment it
--      and replace 'USERNAME' and 'PASSWORD' with your own:
local logins = {
--      { '--addic7ed', 'USERNAME', 'PASSWORD' },
--      { '--legendastv', 'USERNAME', 'PASSWORD' },
--      { '--opensubtitles', 'USERNAME', 'PASSWORD' },
--      { '--subscenter', 'USERNAME', 'PASSWORD' },
}
--=============================================================================
-->>  ADDITIONAL OPTIONS:
--=============================================================================
local excludes = {
  -- Movies with a path containing any of these strings/paths
  -- will be excluded from auto-downloading subtitles.
  -- Full paths are also allowed, e.g.:
  -- '/home/david/Videos',
  -- 'no-subs-dl',
}
--! FIXME
local includes = {
  -- If anything is defined here, only the movies with a path
  -- containing any of these strings/paths will auto-download subtitles.
  -- Full paths are also allowed, e.g.:
  -- home .. '/Videos/Movies',
}
--=============================================================================
local utils = require 'mp.utils'

local downloaded_sub_set = false

-- Download subtitle using subliminal
function download_subs_subliminal(language)
  -- Build the `subliminal` command, starting with the executable:
  local table = { args = { options.subliminal_path } }
  local a = table.args

  for _, login in ipairs(logins) do
    a[#a + 1] = login[1]
    a[#a + 1] = login[2]
    a[#a + 1] = login[3]
  end
  if options.debug then
    -- To see `--debug` output start MPV from the terminal!
    a[#a + 1] = '--debug'
  end

  a[#a + 1] = 'download'
  if options.force then
    a[#a + 1] = '-f'
  end
  if options.utf8 then
    a[#a + 1] = '-e'
    a[#a + 1] = 'utf-8'
  end

  a[#a + 1] = '-l'
  a[#a + 1] = language
  a[#a + 1] = '-d'
  a[#a + 1] = directory
  a[#a + 1] = filename --> Subliminal command ends with the movie filename.

  local result = utils.subprocess(table)

  if string.find(result.stdout, 'Downloaded 1 subtitle') then
    return true
  else
    return false
  end
end

-- Download subtitle using subdl
function download_subs_subdl(lang)
  -- Build the `subliminal` command, starting with the executable:
  local table = { args = { options.subdl_path } }
  local a = table.args


  -- for _, login in ipairs(logins) do
  --   a[#a + 1] = login[1]
  --   a[#a + 1] = login[2]
  --   a[#a + 1] = login[3]
  -- end

  a[#a + 1] = '--lang'
  a[#a + 1] = lang

  if options.utf8 then
    a[#a + 1] = '--utf8'
  end

  a[#a + 1] = '--output'
  a[#a + 1] = '{m}.{L}.{S}'
  a[#a + 1] = filename --> Subliminal command ends with the movie filename.

  local result = utils.subprocess(table)

  if result.status == 1 then
    return false
  else
    return true
  end
end

-- Download function: download the best subtitles in most preferred language
function download_subs(lang)
  local language = languages[lang]
  if language == nil then
    log('No Language found\n')
    return false
  end

  log('Searching ' .. language.name .. ' subtitles ...', 30)

  local result
  if options.preferred_app == 'subliminal' then
    result = download_subs_subliminal(lang)
  elseif options.preferred_app == 'subdl' then
    result = download_subs_subdl(language.iso)
  end

  local return_value = false
  if result then
    return_value = true
    -- only activate the first downloaded subtitle
    if not downloaded_sub_set then
      mp.set_property('slang', lang)
      downloaded_sub_set = true
    end
    -- Subtitles are downloaded successfully, so rescan to activate them:
    mp.commandv('rescan_external_files')
    log(language.name .. ' subtitles ready!')
  else
    log('No ' .. language.name.. ' subtitles found\n')
  end

  return return_value
end

function download_all_languages(force)
  force = force or 1
  local subs_found = false
  for _, lang in ipairs(split(options.languages, ' *, *')) do
    if should_download_subs_in(lang) or force == 1 then
      -- if download_subs(language) then return end -- Download successful!
      subs_found = download_subs(lang)
    else
      subs_found = true
    -- else return end -- No need to download!
    end
  end
  if not subs_found then
    log('No subtitles were found')
  end
end

-- Control function: only download if necessary
function control_downloads()
  -- Make MPV accept external subtitle files with language specifier:
  mp.set_property('sub-auto', 'fuzzy')
  -- Set subtitle language preference:
  -- mp.set_property('slang', languages[1][2])
  mp.msg.warn('Reactivate external subtitle files:')
  mp.commandv('rescan_external_files')
  directory, filename = utils.split_path(mp.get_property('path'))

  if not autosub_allowed() then
    return
  end

  sub_tracks = {}
  for _, track in ipairs(mp.get_property_native('track-list')) do
    if track['type'] == 'sub' then
      sub_tracks[#sub_tracks + 1] = track
    end
  end
  if options.debug then -- Log subtitle properties to terminal:
    for _, track in ipairs(sub_tracks) do
      mp.msg.warn('Subtitle track', track['id'], ':\n{')
      for k, v in pairs(track) do
        --! FIXME
        -- if type(v) == 'string' then v = ''' .. v .. ''' end
        -- mp.msg.warn('  '' .. k .. '':', v)
      end
      mp.msg.warn('}\n')
    end
  end

  download_all_languages(0)
end

-- Check if subtitles should be auto-downloaded:
function autosub_allowed()
  local duration = tonumber(mp.get_property('duration'))
  local active_format = mp.get_property('file-format')

  if not options.auto then
    mp.msg.warn('Automatic downloading disabled!')
    return false
  elseif duration < 900 then
    mp.msg.warn('Video is less than 15 minutes\n' ..
            '=> NOT auto-downloading subtitles')
    return false
  elseif directory:find('^http') then
    mp.msg.warn('Automatic subtitle downloading is disabled for web streaming')
    return false
  elseif active_format:find('^cue') then
    mp.msg.warn('Automatic subtitle downloading is disabled for cue files')
    return false
  else
    local not_allowed = {'aiff', 'ape', 'flac', 'mp3', 'ogg', 'wav', 'wv', 'tta'}

    for _, file_format in pairs(not_allowed) do
      if file_format == active_format then
        mp.msg.warn('Automatic subtitle downloading is disabled for audio files')
        return false
      end
    end

    for _, exclude in pairs(excludes) do
      local escaped_exclude = exclude:gsub('%W','%%%0')
      local excluded = directory:find(escaped_exclude)

      if excluded then
        mp.msg.warn('This path is excluded from auto-downloading subs')
        return false
      end
    end

    for i, include in ipairs(includes) do
      local escaped_include = include:gsub('%W','%%%0')
      local included = directory:find(escaped_include)

      if included then break
      elseif i == #includes then
        mp.msg.warn('This path is not included for auto-downloading subs')
        return false
      end
    end
  end

  return true
end

-- Check if subtitles should be downloaded in this language:
function should_download_subs_in(lang)
  local language = languages[lang]
  for i, track in ipairs(sub_tracks) do
    local subtitles = track['external'] and
      'subtitle file' or 'embedded subtitles'

    if not track['lang'] and (track['external'] or not track['title'])
      and i == #sub_tracks then
      local status = track['selected'] and ' active' or ' present'
      log('Unknown ' .. subtitles .. status)
      mp.msg.warn('=> NOT downloading new subtitles')
      return false -- Don't download if 'lang' key is absent
    elseif track['lang'] == lang or track['lang'] == language.iso or
      (track['title'] and track['title']:lower():find(language.iso)) then
      -- if not track['selected'] and not downloaded_sub_set then
      --   mp.set_property('sid', track['id'])
      --   log('Enabled ' .. language.name .. ' ' .. subtitles .. '!')
      --   downloaded_sub_set = true
      -- else
      --   log(language.name .. ' ' .. subtitles .. ' active')
      -- end
      mp.msg.warn('=> NOT downloading new subtitles')
      return false -- The right subtitles are already present
    end
  end
  mp.msg.warn('No ' .. language.name .. ' subtitles were detected\n' ..
        '=> Proceeding to download:')
  return true
end

-- Log function: log to both terminal and MPV OSD (On-Screen Display)
function log(string, secs)
  secs = secs or 2.5  -- secs defaults to 2.5 when secs parameter is absent
  mp.msg.warn(string)      -- This logs to the terminal
  mp.osd_message(string, secs) -- This logs to MPV screen
end

-- TODO use a menu like in autosubsync.lua
mp.add_key_binding('b', 'download_subs', download_all_languages)
mp.register_event('file-loaded', control_downloads)
