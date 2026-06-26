-- TODO: let lyrics, wiki and anyother script write temp files & let thems clean very old ones every run
local functions = require("abz.functions")
local beautiful = require("beautiful")
xclip = {}
notification = {}

-- {{{ Notifications
function xclip:show(args)
  nottitle = args['title']
  nottext = args['text']
  if not nottext then return end
  noticon = args['icon']
  nottimeout = args['timeout']
  xclip_notify = naughty.notify({
    title = nottitle,
    text = nottext,
    icon = noticon,
    timeout = nottimeout,
    position = "top_right"
  })
end

function xclip:hide()
  if notification ~= nil then
    naughty.destroy(notification)
    notification = nil
  end
end
-- }}}

clip = awful.util.pread("xclip -o")

function xclip:update()
  clip = awful.util.pread("xclip -o")
  return clip
end

-- {{ Calculator
function xclip:calc()
  xclip:update()
  xclip:show({
    title = "Calculator",
    text = calc(clip),
    icon = beautiful.prompt_calc,
    timeout = 20,
    icon_size = 16
  })
end
-- }}


-- {{ Wiki Summarization
function xclip:wiki_summarize()
  xclip:update()
  asyncshell.request("python ~/.config/scripts/wiki.py \"" .. clip .. "\"",
  function(output)
    local ws = output:read("*a")
    local wiki_icon = "/tmp/mywiki/"
    xclip:notify_show({ title = clip,  text = ws, icon = "/tmp/mywiki/" .. clip .. ".jpg", timeout = 20 , icon_size = 16 })
  end)
end
-- }}


function xclip:websearch(engine)
  xclip:update()
  websearch(engine, clip)
end


-- {{ xclip Google Translation:
function xclip:gtrans()
  xclip:update()
  if clip then
    asyncshell.request("python ~/.config/scripts/trans.py ar \"" .. clip .."\"",
    function(output)
      ws = output:read("*a")
      if ws then
        naughty.notify({
          title = "Google Translation",
          text = ws,
          icon = beautiful.prompt_trans,
          timeout = 20
        })
      end
    end
    )
  end
end
-- }}

-- {{ Forvo Pronunciation
function xclip:forvo()
  if not clip:match("^%w+$") then return end
  ---- >? (text): List pronunciation languages

  --asyncshell.request("python ~/.config/scripts/forvo.py -L -w " .. word,
  --function(output)
  --local ws = output:read("*a")
  --abzprompt:notify_show({ title = "Forvo Word Pronunciation\nLanguages List", text = ws, icon = beautiful.prompt_trans, timeout = 10 })
  --end)

  ---- >>(lang) (text): Pronunciation
  --elseif ( p:match("^>>(...?)%s(.+)")) then
  --local lang, word = p:match("^>>(...?)%s(.+)")

  --asyncshell.request("python ~/.config/scripts/forvo.py -w " .. word .. " -l " .. lang,
  --function(output)
  --abzprompt:notify_show({ title = "Forvo Word Pronunciation", text = word, icon = beautiful.prompt_trans, timeout = 10 })
  --end)

  asyncshell.request("python ~/.config/scripts/forvo.py -w " .. clip,
  function(output)
    ws = output:read("*a")
    xclip:notify_show({ title = "Word Pronunciation", text = ws, icon = beautiful.prompt_trans, timeout = 10 })
  end)
end
-- }}
