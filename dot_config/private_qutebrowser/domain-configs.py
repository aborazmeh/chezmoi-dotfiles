import os

# Allow locally loaded documents to access remote URLs.
config.set(
    "content.local_content_can_access_remote_urls",
    True,
    os.path.expanduser("file://~/.local/share/qutebrowser/userscripts/*"),
)

# Allow locally loaded documents to access other local URLs.
config.set(
    "content.local_content_can_access_file_urls",
    False,
    os.path.expanduser("file://~/.local/share/qutebrowser/userscripts/*"),
)

# * Register Protocol Handler
# config.set('content.register_protocol_handler', True, '*://calendar.google.com')
# config.set('content.register_protocol_handler', False, '*://outlook.office365.com')
# config.set('content.register_protocol_handler', True, '*://teams.microsoft.com')

# * Media Capture
# config.set('content.desktop_capture', True, '*://app.wire.com')
# config.set('content.media.audio_capture', True, '*://app.wire.com')
# config.set('content.media.video_capture', True, '*://app.wire.com')
# config.set('content.media.audio_video_capture', True, '*://app.wire.com')
# config.set('content.desktop_capture', True, '*://teams.microsoft.com')
# config.set('content.media.audio_capture', True, '*://teams.microsoft.com')
# config.set('content.media.video_capture', True, '*://teams.microsoft.com')
# config.set('content.media.audio_video_capture', True, '*://teams.microsoft.com')

# * Notifications
# config.set('content.notifications.show_origin', False, '*://app.wire.com')

# * Cookies
# config.set('content.cookies.accept', 'all', '*://teams.microsoft.com')

# * Javascript
config.set("content.javascript.enabled", True, "chrome-devtools://*")
config.set("content.javascript.enabled", True, "devtools://*")
config.set("content.javascript.enabled", True, "chrome://*/*")
config.set("content.javascript.enabled", True, "qute://*/*")

# * Images
config.set("content.images", True, "chrome-devtools://*")
config.set("content.images", True, "devtools://*")

# * Language
config.set("content.headers.accept_language", "en", "https://twitter.com/*")
# config.set('content.headers.accept_language', '', 'https://matchmaker.krunker.io/*')

# * User-Agent
config.set(
    "content.headers.user_agent",
    "Mozilla/5.0 ({os_info}) AppleWebKit/{webkit_version} (KHTML, like Gecko) {upstream_browser_key}/{upstream_browser_version} Safari/{webkit_version}",
    "https://web.whatsapp.com/",
)
config.set(
    "content.headers.user_agent",
    "Mozilla/5.0 ({os_info}; rv:90.0) Gecko/20100101 Firefox/90.0",
    "https://accounts.google.com/*",
)

# * User Stylesheets
# config.set('content.user_stylesheets', ['user_stylesheets/goodreads.css'], 'https://goodreads.com/*')

# * Keybindings
