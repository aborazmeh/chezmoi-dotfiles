-- TODO: hide the other notifications before start a new one
local beautiful = require("beautiful")
local awful = require("awful")
local naughty = require("naughty")
local prompt = require("abz.abzprompt.prompt")
local widget = require("abz.abzprompt.widget")
local completion = require("abz.completion")
local lfs = require("lfs")
local asyncshell = require("asyncshell")
local functions = require("abz.functions")

local abzprompt = {}

local abzprompt_notify= {}
function abzprompt:notify_show(args)
  --abzprompt:notify_hide()

  nottitle = args['title']
  nottext = args['text']
  noticon = args['icon']
  nottimeout = args['timeout']
  abzprompt_notify = naughty.notify({
    title = nottitle,
    text = nottext,
    icon = noticon,
    timeout = nottimeout,
    position = "top_right"
  })
end

function abzprompt:notify_hide()
  if abzprompt_notify ~= nil then
    naughty.destory(abzprompt_notify)
    abzprompt_notify = nil
  end
end

function abzprompt_init()
end

function abzprompt_exe (p)

  -- reveals the environment variables
  for i in p:gmatch("%$([^ ]-)%s") do
    p = p:gsub("$" .. i, os.getenv(i))
  end
  for i in p:gmatch("%$([^ ]+)$") do
    p = p:gsub("$" .. i, os.getenv(i))
  end

  -- if the first character is a digit then calculate it
  if (p:match("^%d")) then
    p = p:gsub(" ", "")  -- removing whitespaces
    local result = calc(p)
    copytoclipboard(result)
    abzprompt:notify_show({ title = "Calculator", text = p .. "=" .. result, icon = beautiful.prompt_calc, timeout = 10 })

    -- @@: Wikipedia summarize
  elseif (p:match("^@@.+")) then
    local keyword = p:match("^@@%s?(.+)")
    asyncshell.request("python ~/.config/scripts/wiki.py \"" .. keyword .. "\"",
    function(output)
      local ws = output:read("*a")
      abzprompt:notify_show({ title = keyword,  text = ws, icon = "/tmp/mywiki/" .. keyword .. ".jpg", timeout = 20 , icon_size = 16 })
    end)


    -- @: Search the web
  elseif (p:match("^@")) then
    local mysearchengines = {
      google = "http://www.google.com/search?q=",
      bing = "http://www.bing.com/search?q=",
      yahoo = "http://search.yahoo.com/search?p=",
      duckduckgo = "http://duckduckgo.com/?q=",
      ask = "http://www.ask.com/web?q=",
      wikipedia = "http://wikipedia.org/wiki/Special:Search?search=",
      wolframalpha = "http://www.wolframalpha.com/input/?i=",
      youtube = "http://www.youtube.com/results?search_query=",
      archlinuxwiki = "http://wiki.archlinux.org/index.php?search=",

      default = "http://www.google.com/search?q="
    }
    -- Get the sengine and skeyword or else get the skeyword alone and go to default
    sengine, skeyword = p:match("@!?(%w+)%s(.+)") or "", p:match("@!?%s(.+)")
    if ( sengine == "g" or sengine == "google" ) then sengine = "google"
    elseif ( sengine == "b" or sengine == "bing" ) then sengine = "bing"
    elseif ( sengine == "y" or sengine == "yahoo" ) then sengine = "yahoo"
    elseif ( sengine == "d" or sengine == "ddg" or sengine == "duckduckgo" or p:match("^@!") ) then skeyword = "!" .. sengine .. "+" .. skeyword sengine = "duckduckgo"
    elseif ( sengine == "a" or sengine == "ask" ) then sengine = "ask"
    elseif ( sengine == "w" or sengine == "wiki" or sengine == "wikipedia" ) then sengine = "wikipedia"
    elseif ( sengine == "wlf" or sengine == "wolframalpha" ) then sengine = "wolframalpha"
    elseif ( sengine == "yt" or sengine == "youtube" ) then sengine = "youtube"
    elseif ( sengine == "arch" or sengine == "archwiki" or sengine == "archlinuxwiki" ) then sengine = "archlinuxwiki"
    else
      sengine = "default"
    end
    skeyword = skeyword:gsub(" ", "+")  -- replace whitespaces with pluses for the url
    websearch(sengine, skeyword)

    -- Open URLs
  elseif ( p:match("^(%a+):/+") or p:match("^www.") ) then    -- open URLs
    open_url(p)

    -- >? (text): List pronunciation languages
  elseif ( p:match("^>%?%s(.+)") ) then
    local word = p:match("^>%?%s(.+)")

    asyncshell.request("python ~/.config/scripts/forvo.py -L -w " .. word,
    function(output)
      local ws = output:read("*a")
      abzprompt:notify_show({ title = "Forvo Word Pronunciation\nLanguages List", text = ws, icon = beautiful.prompt_trans, timeout = 10 })
    end)

    -- >>(lang) (text): Pronunciation
  elseif ( p:match("^>>(...?)%s(.+)")) then
    local lang, word = p:match("^>>(...?)%s(.+)")

    asyncshell.request("python ~/.config/scripts/forvo.py -w " .. word .. " -l " .. lang,
    function(output)
      abzprompt:notify_show({ title = "Forvo Word Pronunciation", text = word, icon = beautiful.prompt_trans, timeout = 10 })
    end)

    -- >> (text): Pronunciation
  elseif ( p:match("^>>%s(.+)")) then
    local word = p:match("^>>%s(.+)")

    asyncshell.request("python ~/.config/scripts/forvo.py -w " .. word,
    function(output)
      abzprompt:notify_show({ title = "Forvo Word Pronunciation", text = word, icon = beautiful.prompt_trans, timeout = 10 })
    end)

    -- (lang)>(lang) (text): Translation
  elseif ( p:match("^.?.?.?>(...?) (.+)") ) then
    local frlang, tolang, trans = p:match("(.?.?.?)>(...?) (.+)")

    asyncshell.request("python ~/.config/scripts/trans.py " .. frlang .. " " .. tolang .. " \"" .. trans .. "\"",
    function(output)
      local ws = output:read("*a")
      abzprompt:notify_show({ title = "Google Translation", text = ws, icon = beautiful.prompt_trans, timeout = 20 })
      copytoclipboard(ws:match("Translation: (.+)"))
    end)

    -- > (text): Translate to Arabic
  elseif ( p:match("^> (.+)") ) then
    local trans = p:match("> (.+)")
    local tolang = "ar"

    asyncshell.request("python ~/.config/scripts/trans.py " .. " " .. tolang .. " \"" .. trans .. "\"",
    function(output)
      local ws = output:read("*a")
      abzprompt:notify_show({ title = "Google Translation", text = ws, icon = beautiful.prompt_trans, timeout = 20 })
      copytoclipboard(ws:match("Translation: (.+)"))
    end)

    -- Run shell commands
  elseif ( p:match("^`.+`")  or p:match("$(.+)") or p:match("$%((.+)%)") ) then
    local command = p:match("^`(.+)`") or p:match("$%((.+)%)") or p:match("$(.+)")
    asyncshell.request(command,
    function(output)
      local ws = output:read("*a")
      -- Don't show the empty strings
      if ws == "" then return end
      abzprompt:notify_show({ title = "Shell Output", text = ws, icon = beautiful.prompt_terminal, timeout = 20 })
    end)

    -- Open directories
  elseif ( p:match("^/.+") or p:match("^~")) then
    p = p:gsub("~", os.getenv("HOME"))
    if (lfs.attributes(p,"mode") == "directory") then
      awful.util.spawn("nautilus " .. p)
    end

  elseif ( p:match("^!(.+)") ) then   -- !: run as root
    command = p:gsub("!(.+)", "%1")
    awful.util.spawn("gksudo " .. command)

  else 
    awful.util.spawn(p)
  end
end


function abzprompt_completion(command, cur_pos, ncomp)
end

function abzprompt_changed(command, cur_pos, ncomp, shell)
  if abzprompt_completion_onthefly == true then
    abzprompt_completion()
  end
end


function abzprompt_args(args)
  if args then return args
  else return { prompt = " $" } end
end

function abzprompt_keypressed(mod, key, command)
  -- Change language layout
  if mod[altkey] and key == "Shift_L" then
    kbdcfg.switch()
  elseif mod[altkey] and key == "Shift_R" then
    kbdcfg.exswitch()
  end

  -- Change tags
  for i = 1, 9 do
    if mod[modkey] and key == tostring(i) then
      local screen = mouse.screen
      local tag = awful.tag.gettags(screen)[i]
      if tag then
        awful.tag.viewonly(tag)
      end
      return 0
    end
  end

  -- Show menu
  if key == "Menu" then
    --mypromptbox[mouse.screen].widget.run:set_text("sldf;j")
    insertmenu = {
      { "é" , }
    }
    promptmenu = awful.menu.new({ items = { { "awesome", insertmenu, },
    { "open terminal", terminal }
  }
})
  promptmenu:toggle()
  end
end
