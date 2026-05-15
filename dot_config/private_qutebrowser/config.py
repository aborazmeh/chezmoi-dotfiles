"""Qutebrowser configuration"""
# based on https://github.com/noctuid/dotfiles/blob/master/browsing/.config/qutebrowser/config.py
# * Pylint
# prevent pylint warnings and fix completion for c/config
# line too long
# pylint: disable = C0301
# E501 - line too long
# F401 - module imported but unused
# F821 - undefined name
# E0602 - undefined variable
# C0103 - invalid constant name

# * Notes

# :config-diff
# :open qute://configdiff
# o qute://configdiff
# c.qt.workarounds.remove_service_workers = True

# ** Probably Will Be Useful
# - click-element
# - ;; for command chaining
# - content.user_stylesheets

# ** TODO Add/Look Into
# HiDPI:
#   - scrollbar is massive with QT_AUTO_SCREEN_SCALE_FACTOR=1
#   - the default zoom is often delayed for a bit
# - difference between url and url:pretty/pretty-url
# - make sanitize command ('history-clear ;; download-clear'; TODO
#   clear-cookies)
# - password management
#   https://github.com/qutebrowser/qutebrowser/issues/180
#   https://github.com/qutebrowser/qutebrowser/issues/3350
# - require permissions per page to use flash
# - spell checking (https://github.com/qutebrowser/qutebrowser/issues/700)
# - change background/active tab colors
# - loading bar under tabs (like firefox)
# - maybe equivalent of readability bookmarklet
# - try webrtc and fingerprint test sites
# - strictfocus equivalent
# - maybe use buku for adding bookmarks (and bind a key to query in terminal or
#   something); or org https://orgmode.org/worg/org-contrib/org-protocol.html;
#   http://www.diegoberrocal.com/blog/2015/08/19/org-protocol/
# - zn/e instead of oi for consistency; zoom reset; text vs full zoom
# - count for tw
# - way to get feed info like with pentadactyl's :pageinfo
# - commit quickmarks if havent; gmail quickmark
# - key to get rid of highlights (or automatic)
# - locally disable javascript (e.g. message about adblock)

# ** Nice Things About Qutebrowser
# - more sophisticated completion than pentadactyl (e.g. " " like ".*")
# - very fast/responsive (though I've had session files even for small sessions
#   that made it unusable; TODO look into replicating this)
# - navigation wizardry with :navigate (prev|next|up)

# ** Missing Functionality/ Wishlist
# *** Necessary for Everyday Usage
# - Better cursor behavior in insert mode (this is cause of constant annoyance
#   for me; https://github.com/qutebrowser/qutebrowser/issues/2668;
#   https://github.com/qutebrowser/qutebrowser/pull/3834;
#   https://github.com/qutebrowser/qutebrowser/pull/3906)
# - custom command instead of file browser or post download auto-command
#   (currently have to manually run :download-open; TODO make issue)
# - single key quickmarks (real quickmarks;
#   https://github.com/qutebrowser/qutebrowser/issues/711; also
#   https://github.com/qutebrowser/qutebrowser/issues/882)
# - per-domain keybindings
#   (https://github.com/qutebrowser/qutebrowser/issues/3636)
# - better greasemonkey support
#   (https://github.com/qutebrowser/qutebrowser/issues/3238)

# *** Major
# - plugin support (https://github.com/qutebrowser/qutebrowser/issues/30)
#   - security: secure pasword fill plugin, decentraleyes, cookie auto delete
#     (dedicated issue:
#     https://github.com/qutebrowser/qutebrowser/issues/1660), privacy badger
#     (a ghosterey/disconnect/privacy badger equivalent), agent
#     spoofing/browser fingerprint minimization, etc.
#   - related issues to above:
#     https://github.com/qutebrowser/qutebrowser/issues/2160
#     https://github.com/qutebrowser/qutebrowser/issues/2235
#     https://github.com/qutebrowser/qutebrowser/issues/1659
#   - hover zoom/imagus equivalent (if userscript doesn't work)
#   - DownThemAll equivalent (particularly in conjunction with comic/gallery
#     userscript)
#   - RES equivalent (at least some of the features would be nice)
#   - "automatically spawn mpv on video pages"
# - HTTPS everywhere (https://github.com/qutebrowser/qutebrowser/issues/335)
# - tabgroups (https://github.com/qutebrowser/qutebrowser/issues/49)
# - autocmds/setlocal (https://github.com/qutebrowser/qutebrowser/issues/35)
# - undo completion/history
#   (https://github.com/qutebrowser/qutebrowser/issues/32; also see
#   https://github.com/qutebrowser/qutebrowser/issues/1031)
# - same-window, tab-unique inspector instead of separate windows
#   (https://github.com/qutebrowser/qutebrowser/issues/1400)

# *** Minor
# - better ad-blocking (e.g. youtube not supported; other sites still have lots
#   of ads visible)
#   https://github.com/qutebrowser/qutebrowser/issues/29
# - way to reference ~ / $HOME in filename (TODO make issue)
# - simpler key syntax (c instead of Ctrl,  esc instead of Escape, etc.;
#   TODO make issue)
# - tree style tab view (https://github.com/qutebrowser/qutebrowser/issues/927)
# - rikaikun/rikaichan (seems unlikely)
# - unbind should work for default keybindings (TODO make issue)
# - better caret mode or way to open current page in editor (TODO make issue)
# - full jumplist (https://github.com/qutebrowser/qutebrowser/issues/2642)
# - more hinting modes (https://github.com/qutebrowser/qutebrowser/issues/521)
# - save editor buffer (https://github.com/qutebrowser/qutebrowser/issues/1596)
# - cookies-clear command (TODO make issue)
# - tab-focus jump within current 10 tabs range(or this possible with plugin
#   API; TODO make issue)
# - configurable completion
#   (https://github.com/qutebrowser/qutebrowser/issues/836)
# - support recursive command aliasing (alias an alias)
# - insert editing keys (e.g. rl-backward-kill-word doesn't work in insert but
#   can use fake-key as a workaround)
#   https://github.com/qutebrowser/qutebrowser/issues/68
# - show whether js is enabled
#   https://github.com/qutebrowser/qutebrowser/issues/1795
#   https://github.com/qutebrowser/qutebrowser/issues/1052
# - embedded editor/pterosaur equivalent
#   https://github.com/qutebrowser/qutebrowser/issues/827

# Documentation:
#   qute://help/configuring.html
#   qute://help/settings.html

# import setproctitle
# setproctitle.setproctitle('qutebrowser')
from qutebrowser.config.configfiles import ConfigAPI  # noqa: F401,E501 pylint: disable=unused-import
from qutebrowser.config.config import ConfigContainer  # noqa: F401,E501 pylint: disable=unused-import
config = config  # type: ConfigAPI # noqa: F821 pylint: disable=E0602,C0103
c = c  # type: ConfigContainer # noqa: F821 pylint: disable=E0602,C0103

# * Settings
# Change the argument to True to still load settings configured via autoconfig.yml
config.load_autoconfig(False)

# ** General
c.content.blocking.method = 'both'
# Automatically enter insert mode if an editable element is focused
# after loading the page.
c.input.insert_mode.auto_load = True
# Leave insert mode if a non-editable element is clicked.
c.input.insert_mode.auto_leave = True

# ** Language
c.content.default_encoding = 'utf-8'
# install via `/usr/share/qutebrowser/scripts/dictcli.py install {lang_code}`
c.spellcheck.languages = [
  'en-US',
  # 'ar',
  'tr-TR',
]
# Value to send in the `Accept-Language` header.
c.content.headers.accept_language = 'en-US,en,ar,tr;q=0.8,fi;q=0.6'

# ** External File Handler
c.fileselect.handler = 'external'
# c.fileselect.single_file.command = ['foot', 'ranger', '--choosefiles', '{}']
# c.fileselect.multiple_files.command = ['foot', 'ranger', '--choosefiles', '{}']
# c.fileselect.single_file.command = ['kitty', 'sh', '-c', 'xplr > {}']
# c.fileselect.multiple_files.command = ['kitty', 'sh', '-c', 'xplr > {}']
c.fileselect.single_file.command = ['alacritty', '--class', 'ranger-choosefiles,ranger', '-e', 'ranger', '--choosefile', '{}']
c.fileselect.multiple_files.command = ['alacritty', '--class', 'ranger-choosefiles,ranger', '-e', 'ranger', '--choosefiles', '{}']

# ** Session
# always restore opened sites when opening qutebrowser
c.auto_save.session = True
c.session.lazy_restore = True

# ** Tabs
# open new tabs (middleclick/ctrl+click) in the background
c.tabs.background = True
# select previous tab instead of next tab when deleting current tab
c.tabs.select_on_remove = 'prev'    # prev / next / last
# open unrelated tabs after the current tab not last
c.tabs.new_position.unrelated = 'next'
c.tabs.min_width = 200
c.tabs.mousewheel_switching = True
# Width of the progress indicator (0 to disable).
# c.tabs.width.indicator = 0
c.tabs.title.format = '{index}{private}{title_sep}{current_title}'

# Behavior when the last tab is closed.
# Valid values:
#   - ignore: Don't do anything.
#   - blank: Load a blank page.
#   - startpage: Load the start page.
#   - default-page: Load the default page.
#   - close: Close the window.
c.tabs.last_close = 'startpage'

# ** Command Aliases
c.aliases = {
  **c.aliases,
  **{
    'h': 'help',
    'q': 'quit',
    'w': 'session-save',
    'wq': 'quit --save',
    'xa': 'quit --save',
    'mpv': 'spawn -d mpv --force-window=immediate {url}',
    # 'nicehash': 'spawn --userscript nicehash',
    # 'pass': 'spawn -d pass -c',
  }
}

# ** Appearance
config.source('theme.py')

# ** Editor
# c.editor.command = ['termite', '-e', "vim '{}'"]
# c.editor.command = ['kitty', 'kak', '-e', 'exec {line}g{column0}l', '{}']
# c.editor.command = ['code', '-n', '{file}', '-w']
# c.editor.command = ['gvim.bat', '-f', '{file}', '-c', 'normal {line}G{column0}l']
# c.editor.command = ['emacsclient', '-c', '-a', ' ', '+{line}:{column}', '{}']
c.editor.command = ['gedit', '{}']

# ** Hints
# don't require enter after hint keys
c.hints.auto_follow = 'always'
# c.hints.chars = 'asdfghjklie'
c.hints.chars = 'arstdhneiowfpluy'

# ** Downloads
c.downloads.location.directory = '~/Downloads'
c.downloads.location.prompt = False
# c.downloads.open_dispatcher = 'dl_move {}'

# Whether quitting the application requires a confirmation.
# Valid values:
#   - always: Always show a confirmation.
#   - multiple-tabs: Show a confirmation if multiple tabs are opened.
#   - downloads: Show a confirmation if downloads are running
#   - never: Never show a confirmation.
# c.confirm_quit = ['downloads']
# c.downloads.location.suggestion = 'both'

# ** Security
# defaults
c.content.cookies.accept = 'no-3rdparty'
c.content.geolocation = 'ask'
c.content.headers.do_not_track = True
c.content.headers.referer = 'same-domain'
c.content.media.audio_capture = 'ask'
c.content.media.video_capture = 'ask'
c.content.media.audio_video_capture = 'ask'
c.content.desktop_capture = 'ask'
# c.content.notifications = 'ask'   # FIXME
# c.content.ssl_strict = 'ask'   # FIXME
# c.content.javascript.can_access_clipboard = True
# c.content.webrtc_ip_handling_policy = 'default-public-interface-only'
# c.content.webrtc_ip_handling_policy = 'disable-non-proxied-udp'

# *** JavaScript.
c.content.javascript.enabled = True

# *** Images
# Load images automatically in web pages.
c.content.images = True

# *** User-Agent
c.content.headers.user_agent = 'Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/119.0'

# *** Proxy
# The proxy to use. In addition to the listed values, you can use a
# `socks://...` or `http://...` URL.
# Valid values:
#   - system: Use the system wide proxy.
#   - none: Don't use any proxy
c.content.proxy = 'none'

# *** Display PDFs within qutebrowser
c.content.pdfjs = True

# *** TODO
# content.plugins
# content.xss_auditing

# ** Input
# don't timeout for during partially entered command
c.input.partial_timeout = 0
# arrow key link element navigation; works okay on some pages
# unfortunately affects hnei too (move-to commands)
# c.input.spatial_navigation = True

# ** Search Keywords
c.url.searchengines = {
  'DEFAULT': 'https://duckduckgo.com/?kam=google-maps&kp=-2&q={}',
  'am': 'https://smile.amazon.com/s?k={}',
  'aw': 'https://wiki.archlinux.org/index.php?search={}',
  'az': 'https://search.azlyrics.com/search.php?q={}',
  'camel': 'https://camelcamelcamel.com/search?sq={}',
  'd': 'https://duckduckgo.com/?kam=google-maps&kp=-2&q={}',
  'dv': 'https://www.deviantart.com/?q={}',
  'fake': 'https://fakespot.com/analyze?url={}',
  'g': 'https://www.google.com/search?q={}',
  'gi': 'https://www.google.com/search?tbm=isch&q={}&tbs=imgo:1',
  'gn': 'https://news.google.com/search?q={}',
  'gh': 'https://github.com/search?q={}',
  'gr': 'https://www.goodreads.com/search?q={}',
  'hg': 'https://www.haskell.org/hoogle/?hoogle={}',
  'j': 'https://jisho.org/search/{}',
  'mal': 'https://myanimelist.net/search/all?q={}',
  'mus': 'https://www.allmusic.com/search/all/{}',
  'q': 'https://www.qwant.com/?q=%s{}=web',
  'r': 'https://www.reddit.com/r/{}/',
  'rt': 'https://www.rottentomatoes.com/search/?search={}',
  's': 'https://searx.be/?q={}',
  'sp': 'https://www.startpage.com/do/search?query={}&prfe=36c84513558a2d34bf0d89ea505333ad25eaad7546bb0b480adc2e9be9271a9b54b2adb3b1f304d3530bea21aa54bdf5',  # noqa: E501
  't': 'https://www.tumblr.com/search/{}',
  'ub': 'https://www.urbandictionary.com/define.php?term={}',
  # other useful yub nub commands: cnv, gim, tiny, ddg, torf, etc.
  # useful mostly for stuff that combines things like mash, split, weird
  # piping stuff, etc.
  'yub': 'https://yubnub.org/parser/parse?command={}',
  'y': 'https://www.youtube.com/results?search_query={}',
  'wayback':  'https://web.archive.org/web/*/{}',
  'w': 'https://en.wikipedia.org/wiki/{}',
  'yt': 'https://www.youtube.com/results?search_query={}',
  'zerochan':  'https://www.zerochan.net/{}',
}

# ** Bookmarklets/Custom Commands
# c.aliases['archive'] = 'open --tab https://web.archive.org/save/{url}'
# c.aliases['view-archive'] = 'open --tab https://web.archive.org/web/*/{url}'
# c.aliases['va'] = 'open --tab https://web.archive.org/web/*/{url}'
# c.aliases['view-google-cache'] = \
#     'open https://www.google.com/search?q=cache:{url}'
# c.aliases['vgc'] = 'open https://www.google.com/search?q=cache:{url}'

# ** Media
c.content.autoplay = False

# ** Zoom
# decrease for HiDPI (necessary with QT_AUTO_SCREEN_SCALE_FACTOR=1)
# if os.getenv('MONITOR_IS_HIDPI'):
#     c.zoom.default = 67
# c.zoom.default = '150%'

# * Key Bindings
config.source('key-bindings.py')

# * Per Domain
config.source('domain-configs.py')

# * TODO Greasemonkey
# supposed to work with qutebrowser
# - https://greasyfork.org/en/scripts/404-mouseover-popup-image-viewer is
# - try ccd0/4chan x
# - https://github.com/untamed0/Show-Just-Image-3
