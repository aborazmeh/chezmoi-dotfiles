import re

# * Helper Functions
def bind(key, command, mode):  # noqa: E302
  """Bind key to command in mode."""
  # TODO set force; doesn't exist yet
  config.bind(key, command, mode=mode)

def nmap(key, command):
  """Bind key to command in normal mode."""
  bind(key, command, 'normal')

def imap(key, command):
  """Bind key to command in insert mode."""
  bind(key, command, 'insert')

def cmap(key, command):
  """Bind key to command in command mode."""
  bind(key, command, 'command')

# def cimap(key, command):
#   """Bind key to command in command mode and insert mode."""
#   cmap(key, command)
#   imap(key, command)

def tmap(key, command):
  """Bind key to command in caret mode."""
  bind(key, command, 'caret')

def pmap(key, command):
  """Bind key to command in passthrough mode."""
  bind(key, command, 'passthrough')

def unmap(key, mode):
  """Unbind key in mode."""
  config.unbind(key, mode=mode)

def nunmap(key):
  """Unbind key in normal mode."""
  unmap(key, mode='normal')

# * Key Bindings
# ** Navigation
nmap('J', 'scroll-page 0 0.5')
nmap('K', 'scroll-page 0 -0.5')

# ** Toggle darkmode
nmap(',n', 'spawn --userscript darkmode')

# ** Reload Configuration
nmap(',.', 'config-source')

# ** Reader Mode
nmap(',r', 'spawn --userscript readability')

# ** RTL toggle
imap(',R', 'jseval document.activeElement.dir = document.activeElement.dir === "rtl" ? "ltr" : "rtl"')
nmap(',R', 'jseval document.querySelector("html").dir = document.querySelector("html").dir === "rtl" ? "ltr" : "rtl"')

# ** Miscellaneous Swaps
# swap ; and :
nmap(';', 'cmd-set-text :')
nunmap(':')
hints_dict = dict()  # pylint: disable = C0103
for k, v in c.bindings.default['normal'].items():
    if k.startswith(';'):
        hints_dict[re.sub(r'^;(.*)', r':\1', k)] = v
c.bindings.commands['normal'].update(hints_dict)

# lose scroll left
nmap('h', 'back')
nmap('l', 'forward')

# lose scroll right
# nmap('l', 'tab-focus last')

nmap('b', 'cmd-set-text --space :buffer')

# ** Colemak Swaps/
# https://github.com/qutebrowser/qutebrowser/issues/2668#issuecomment-309098314
# nmap('n', 'scroll-page 0 0.2')
# nmap('e', 'scroll-page 0 -0.2')
# nmap('N', 'tab-prev')
# # no default binding
# nmap('E', 'tab-next')

# add back search
# nmap('k', 'search-next')
# nmap('K', 'search-prev')

# tmap('n', 'move-to-next-line')
# tmap('e', 'move-to-prev-line')
# tmap('i', 'move-to-next-char')
# # add back e functionality
# tmap('j', 'move-to-end-of-word')

# tmap('N', 'scroll down')
# tmap('E', 'scroll up')
# tmap('I', 'scroll right')

# ** Hinting
# I think I like this better than going to first input
nmap('gi', 'hint inputs')
# TODO ts for download hinting instead of :d
# TODO ti for image hinting in background (rebind :inspector)

# ** Miscellaneous
nmap('gn', 'navigate previous')
nmap('ge', 'navigate next')

nmap('tm', 'messages --tab')
nmap('th', 'help --tab')
nmap('tr', 'stop')

# @: - run last ex command
nmap('t;','cmd-set-text : ;; completion-item-focus --history prev ;; '
      + 'command-accept')

# ** Tabs and Windows
nmap('o', 'cmd-set-text -s :open')
nmap('O', 'cmd-set-text -s :open --tab')

nmap('D', 'close')

nmap('<Ctrl-j>', 'tab-next')
nmap('<Ctrl-k>', 'tab-prev')
nmap('<Ctrl-Shift-k>', 'tab-move -')
nmap('<Ctrl-Shift-j>', 'tab-move +')

# open homepage in new tab
nmap('tt', 'open --tab')

# lose tab-only and download-clear
nmap('c', 'cmd-set-text :open --related {url:pretty}')
nmap('C', 'cmd-set-text :open --tab --related {url:pretty}')

# open new private window
nmap('tp', 'open -p')

# tn and te for tab moving
nmap('tn', 'tab-move -')
nmap('te', 'tab-move +')

# ** TODO Tabgroups
# - title should be displayed somewhere
# - create new group (vn)
# - move tab to different group (vM; vm - without switching)
# - switch to different group (vv completion)
# - keys for specific tap groups (e.g. wr,  prog, main, mango)
# - rename tab group (vr)
# - delete tab group (vd)

# ** Yanking and Pasting
# don't need primary or extra yanks
nmap('p', 'open -- {clipboard}')
nmap('P', 'open --tab -- {clipboard}')
nmap('y', 'yank')
nmap('Y', 'yank selection')

# ** Editor
imap('<Ctrl-i>', 'open-editor')
# open source in editor
nmap('gF', 'view-source --edit')

# ** Insert/RL
# imap('<Ctrl-w>', 'fake-key <Ctrl-backspace>')
imap('¸', 'fake-key <Ctrl-backspace>')
cmap('¸', 'fake-key --global <Ctrl-backspace>')

# nunmap('<Ctrl-w>')
# prevent c-w from closing tab
# del c.bindings.default['normal']['<Ctrl-W>']

# C-y for pasting
imap('<Ctrl-y>', 'fake-key <Ctrl-v>')
cmap('<Ctrl-y>', 'fake-key --global <Ctrl-v>')

# ** Passthrough
# nmap(',', 'enter-mode passthrough')
pmap('<Escape>', 'leave-mode')

# ** Undo
# no :undo completion currently
# nmap('U', 'cmd-set-text --space :undo')

# ** Quickmarks and Marks
# nunmap("'")
# real quickmarks
# nmap("'13", ':open --tab localhost:1313')
# nmap("'4", ':open --tab https://boards.4chan.org/g/')
# nmap("'8", ':open --tab https://8ch.net/tech/')
# nmap("'a", ':open --tab https://bbs.archlinux.org/')
# nmap("'A", ':open --tab https://github.com/bayandin/awesome-awesomeness')
# nmap("'b", ':open --tab https://www.dustloop.com/forums/index.php?/forum/63-blazblue/')
# nmap("'B", ':open --tab https://lispcookbook.github.io/cl-cookbook/')
# nmap("'c", ':open --tab https://camelcamelcamel.com/search?sq={url}')
# nmap("'C", ':open --tab https://forum.colemak.com/')
# nmap("'e", ':open --tab https://www.reddit.com/r/emacs/')
# nmap("'f", ':open --tab https://fakespot.com/analyze?url={url}')
# nmap("'g", ':open --tab https://www.github.com/')
# nmap("'G", ':open --tab https://www.geekhack.org/')
# nmap("'h", ':open --tab https://news.ycombinator.com/news')
# nmap("'i", ':open --tab https://imgur.com/')
# nmap("'l", ':open --tab https://lainchan.org/%CE%BB/index.html')
# nmap("'L", ':open --tab https://www.last.fm/')
# nmap("'m", ':open --tab https://myanimelist.net')
# nmap("'n", ':open --tab https://www.reddit.com/r/neovim')
# nmap("'p", ':open --tab https://www.privacyguides.org/en/tools/')
# nmap("'P", ':open --tab https://prism-break.org')
# nmap("'q", ':open --tab https://quora.com/')
# nmap("'r", ':open --tab https://reddit.com/')
# nmap("'R", ':open --tab https://redditbooru.com/')
# nmap("'s", ':open --tab https://myanimelist.net/anime/season')
# nmap("'S", ':open --tab https://myanimelist.net/clubs.php?cid=27907')
# nmap("'t", ':open --tab https://www.tumblr.com/dashboard/')
# nmap("'T", ':open --tab https://twitter.com/home/')
# nmap("'v", ':open --tab https://www.reddit.com/r/vim/')
# nmap("'w", ':open --tab https://web.archive.org/web/*/{url}')
# nmap("'W", ':open --tab https://github.com/bayandin/awesome-awesomeness')
# nmap("'y", ':open --tab https://youtube.com/')

# to get to login page (e.g. airport/hotel)
# ../../.local/share/qutebrowser/userscripts/open-default-gateway
# nmap("'z", ':spawn --userscript open-default-gateway')

# add back mark jumping
# nmap('"', 'enter-mode jump_mark')
# nmap('tl', 'jump-mark "\'"')

# ** Spawn/Shell
# *** Bookarking with Buku
# can add tags after
# nmap('m', 'cmd-set-text -s :spawn --detach buku --add "{url}"')

# *** Playing Videos with MPV
# "y" for youtube-dl
# nmap('ty', 'spawn --detach mpv "{url}"')

# ** Downloads
# TODO download video and audio
# # nmap -ex <leader>Y execute "silent !youtube-dl --restrict-filenames -o '~/move/%(title)s_%(width)sx%(height)s_%(upload_date)s.%(ext)s' " + buffer.URL + " &"
# # nmap -ex <leader>A execute "silent !youtube-dl --restrict-filenames --extract-audio -o '~/move/%(title)s_%(width)sx%(height)s_%(upload_date)s.%(ext)s' " + buffer.URL + " &"
# nmap('tw', 'download --dest ~/database/move/ ;; tab-close')
# nmap('tg', 'spawn --detach dlg "{url}"')
# nmap('td', 'download-open')
# nmap('tr', 'spawn --detach dl_move bulk_store')
# nmap('tc', 'download-clear')

# ** Zooming
nmap('zi', 'zoom-in')
nmap('zo', 'zoom-out')

# ** Inspector
nmap('ti', 'inspector')

# ** TODO
# bindings = {
#     ",d": "download-open",
#     ",m": "hint links spawn cglaunch mpv '{hint-url}'",
#     ",p": "spawn --userscript qute-pass --username-target secret --username-pattern 'user: (.+)' --dmenu-invocation 'dmenu -p credentials'",
#     ",P": "spawn --userscript qute-pass --username-target secret --username-pattern 'user: (.+)' --dmenu-invocation 'dmenu -p password' --password-only",
#     ",b": "config-cycle colors.webpage.bg '#1d2021' 'white'",
#     ";I": "hint images download",
#     "<Ctrl-Shift-J>": "tab-move +",
#     "<Ctrl-Shift-K>": "tab-move -",
#     "M": "nop",
#     "co": "nop",
#     "<Shift-Escape>": "fake-key <Escape>",
#     "o": "cmd-set-text -s :open -s",
#     "O": "cmd-set-text -s :open -t -s",
# }

# for key, bind in bindings.items():
#     nmap(key, bind)

nmap('M', 'hint links spawn mpv {hint-url}')
nmap("<f12>", "devtools")
nmap("<Ctrl-Shift-i>", "devtools")
# # Bindings to use dmenu rather than qutebrowser's builtin search.
# nmap('o', 'spawn --userscript dmenu-open')
# nmap('O', 'spawn --userscript dmenu-open --tab')

# Bindings for normal mode
# nmap('Z', 'hint links spawn st -e youtube-dl {hint-url}')
# nmap('t', 'cmd-set-text -s :open -t')
nmap('xb', 'config-cycle statusbar.show always never')
nmap('xt', 'config-cycle tabs.show multiple never')
nmap('xx', 'config-cycle statusbar.show always never;; config-cycle tabs.show multiple never')

# # Bindings for cycling through CSS stylesheets from Solarized Everything CSS:
# # https://github.com/alphapapa/solarized-everything-css
# nmap(',ap', 'config-cycle content.user_stylesheets ~/.config/qutebrowser/solarized-everything-css/css/apprentice/apprentice-all-sites.css ""')
# nmap(',dr', 'config-cycle content.user_stylesheets ~/.config/qutebrowser/solarized-everything-css/css/darculized/darculized-all-sites.css ""')
# nmap(',gr', 'config-cycle content.user_stylesheets ~/.config/qutebrowser/solarized-everything-css/css/gruvbox/gruvbox-all-sites.css ""')
# nmap(',sd', 'config-cycle content.user_stylesheets ~/.config/qutebrowser/solarized-everything-css/css/solarized-dark/solarized-dark-all-sites.css ""')
# nmap(',sl', 'config-cycle content.user_stylesheets ~/.config/qutebrowser/solarized-everything-css/css/solarized-light/solarized-light-all-sites.css ""')
# nmap("gi", "hint inputs")

# unmap("+")
# unmap("-")
# unmap("=")
# nmap("z+", "zoom-in")
# nmap("z-", "zoom-out")
# nmap("zz", "zoom")

# unmap("O")
# unmap("T")
# unmap("th")
# unmap("tl")
# nmap("O", "cmd-set-text :open {url:pretty}")
# nmap("T", "cmd-set-text :open -t {url:pretty}")
# nmap("t", "cmd-set-text -s :open -t")

# unmap("<ctrl+tab>")
# nmap("<ctrl+tab>", "tab-next")
# nmap("<ctrl+shift+tab>", "tab-prev")

# unmap("ZQ")
# unmap("ZZ")
# unmap("<ctrl+q>")
# nmap("<ctrl+q>", "wq")

# nmap("q", "quit")
# nmap('<Ctrl-=>', 'zoom-in')
# nmap('<Ctrl-->', 'zoom-out')
# ## I like to save web pages in MHTML format
# ## Thanks to the next key binding, I can use ,sm to do that
# nmap(',sm', 'cmd-set-text :download --mhtml')


# ## ,ya is my shortcut to “yank asciidoc-formatted link”
# nmap(',ya', 'yank inline {url:pretty}[{title}]')

# ## ,ym is my shortcut to “yank markdown-formatted link”
# ## ym (without a leading comma) also works because it is built-in
# nmap(',ym', 'yank inline [{title}]({url:pretty})')

# ## next is a note to self about how to bind JavaScript code to a key shortcut
# # nmap(',hw', "jseval alert('Hello World')")

# c.content.dns_prefetch = False

# nmap(',t', 'spawn -u "C:\\Users\\USERNAME\\Sync\\qb\\tumblelog-wrapper.cmd"')

