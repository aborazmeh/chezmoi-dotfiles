-- supermenu:
-- |-calculator
-- |-date
--  |-to hijri
--  |-from hijri
-- |-port info
-- |-websearch
--  |-google
--  |-bing
--  |-yahoo
--  |-ask
--  |-duckduckgo
--  |-wolframalpha
--  |-wikipedia
--  |-imdb
--  |-google maps
--  |-bing maps
-- |-files
--  |-run (if chmox +x |? else depending on the extension)
--  |-info (+encoding, mimetype, extension)
--  |-open
--  |-upload
--   |-dropbox
--   |-box
--   |-4shared
--   |-mycloud
--   |-ftp
--  |-share
--   /*if video:*/
--   |-facebook
--   |-twitter
--   |-vimeo ...
--   /*elseif audio:*/
--   |-facebook ..
--   /*elseif image:*/
--   |-facebook
--   /*else no sharing*/
--  ?-encoding
--   ?-get encoding
--   ?-convert
-- |-shell
--  |-output
--  |-run in shell
-- |-url
--  |-shorten (bit.ly ...)
--  |-lengthening (if it's supported)
--  |-encoding
--  |-decoding (if possible)
-- |-host/ip (with port)
--  |-connect
--  |-whois
--  |-ping
--  |-tracerout
-- |-translation
--  |-google
--  |-bing
--  |-yandex
--  |-forvo
-- |-text
--  |-open in text editor
--  |-email
-- |-developers
--  |-HTML special codes
--  |-HTML colors
--  |-perl search
--  |-python search
--  |-ruby search
--  |-PHP search
--  |-lua search
-- |-ISBN
--  |-amazon search
-- |-blog
--  |-wordpress
-- |-share
--  |-facebook
--  |-gplus
--  |-twitter
--  |-delicious
--  |-reddit
--  |-linkedin
--  |-digg
--  |-stumbleupon
--  |-evernote
--  |-thumblr
--  |-wordpress
--  |-readitlater (Pocket)
--  |-yummly

local _xclip = require("abz.xclip")


-- SuperMenu
function supermenu_show()
  -- Clipped and validation variables
  local clipped = xclip:update()
  local calced = calc(clipped)

  supermenu_items = { }

  if calced then table.insert(supermenu_items, { "calculate", function() xclip:calc() end, }) end
  table.insert(supermenu_items, { "Wiki quick info", function() xclip:wiki_summarize() end, })

  file_items = { }
  --table.insert(websearch_items, { "Yandex Maps", function() xclip:websearch("yandex_maps") end, })
  table.insert(supermenu_items, { "File", file_items })

  websearch_items = {}
  table.insert(websearch_items, { "Google", function() xclip:websearch("google") end, })
  table.insert(websearch_items, { "Bing", function() xclip:websearch("bing") end, })
  table.insert(websearch_items, { "Yahoo", function() xclip:websearch("yahoo") end, })
  table.insert(websearch_items, { "Yandex", function() xclip:websearch("yandex") end, })
  table.insert(websearch_items, { "DuckDuckGo", function() xclip:websearch("duckduckgo") end, })
  table.insert(websearch_items, { "Wikipedia", function() xclip:websearch("wikipedia") end, })
  table.insert(websearch_items, { "Ask", function() xclip:websearch("ask") end, })
  table.insert(websearch_items, { "Youtube", function() xclip:websearch("youtube") end, })
  table.insert(websearch_items, { "Wolframalpha", function() xclip:websearch("wolframalpha") end, })
  table.insert(websearch_items, { "IMDB", function() xclip:websearch("imdb") end, })
  table.insert(websearch_items, { "Google Maps", function() xclip:websearch("google_maps") end, })
  table.insert(websearch_items, { "Bing Maps", function() xclip:websearch("bing_maps") end, })
  table.insert(websearch_items, { "Yandex Maps", function() xclip:websearch("yandex_maps") end, })
  table.insert(supermenu_items, { "Web Search", websearch_items })

  translation_items = {}
  table.insert(translation_items, { "Google", function() xclip:gtrans() end, })
  if clipped:match("^%w+$") then table.insert(translation_items, { "Pronounce", function() xclip:forvo() end, }) end
  table.insert(supermenu_items, { "Translate", translation_items })


  supermenu = awful.menu.new({ items = supermenu_items })
  supermenu:toggle()
end
