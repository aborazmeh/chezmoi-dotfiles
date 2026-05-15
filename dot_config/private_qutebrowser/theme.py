import os, json, dracula

HOME = os.path.expanduser("~")


def set_theme():
    # A list of user stylesheet filenames to use.
    # FIXME use domain specific stylesheets when it's supported
    c.content.user_stylesheets = [
        "user_stylesheets/user.css",
        "user_stylesheets/goodreads.css",
        "user_stylesheets/wikipedia.css",
    ]
    try:
        with open(f"{HOME}/.cache/wal/colors.json", "r") as fp:
            theme = json.load(fp)
            set_colors(theme)
            set_background(
                theme["wallpaper"],
                theme["special"]["foreground"],
                theme["special"]["background"],
            )
    except BaseException as ex:
        dracula.blood(c, {"spacing": {"vertical": 6, "horizontal": 8}})


def set_fonts():
    monospace = '11pt "FiraCode"'
    c.fonts.default_family = '"FiraCode"'
    c.fonts.default_size = "11pt"
    c.fonts.completion.entry = monospace
    c.fonts.completion.entry = '11pt "FiraCode"'
    c.fonts.debug_console = monospace
    # c.fonts.prompts = 'default_size sans-serif'
    c.fonts.prompts = monospace
    c.fonts.statusbar = monospace
    c.fonts.completion.category = f"bold {monospace}"
    c.fonts.downloads = monospace
    c.fonts.keyhint = monospace
    c.fonts.messages.error = monospace
    c.fonts.messages.info = monospace
    c.fonts.messages.warning = monospace
    c.fonts.hints = "bold 13px 'DejaVu Sans Mono'"


def set_background(filename, foreground, background):
    with open(f"{HOME}/.config/qutebrowser/start.html", "r") as start:
        content = start.read() % (filename, background, foreground)
    with open(f"{HOME}/.config/qutebrowser/blank.html", "w") as blank:
        blank.write(content)
    # ** Home/Start Page
    c.url.default_page = f"file://{HOME}/.config/qutebrowser/blank.html"
    c.url.start_pages = f"file://{HOME}/.config/qutebrowser/blank.html"


def set_colors(theme):
    c.colors.completion.category.bg = theme["special"]["background"]
    c.colors.completion.category.border.bottom = theme["special"]["background"]
    c.colors.completion.category.border.top = theme["special"]["background"]
    c.colors.completion.category.fg = theme["special"]["foreground"]
    c.colors.completion.even.bg = theme["special"]["background"]
    c.colors.completion.odd.bg = theme["special"]["background"]
    c.colors.completion.fg = theme["special"]["foreground"]
    c.colors.completion.item.selected.bg = theme["colors"]["color5"]
    c.colors.completion.item.selected.border.bottom = theme["special"]["background"]
    c.colors.completion.item.selected.border.top = theme["special"]["background"]
    c.colors.completion.item.selected.fg = theme["special"]["foreground"]
    c.colors.completion.match.fg = theme["colors"]["color3"]
    c.colors.completion.scrollbar.bg = theme["special"]["background"]
    c.colors.completion.scrollbar.fg = theme["special"]["foreground"]
    c.colors.downloads.bar.bg = theme["special"]["background"]
    c.colors.downloads.error.bg = theme["colors"]["color5"]
    c.colors.downloads.error.fg = theme["special"]["foreground"]
    c.colors.downloads.stop.bg = theme["colors"]["color6"]
    c.colors.downloads.system.bg = "none"
    c.colors.hints.bg = theme["colors"]["color3"]
    c.colors.hints.fg = theme["special"]["background"]
    c.colors.hints.match.fg = theme["colors"]["color4"]
    c.colors.keyhint.bg = theme["special"]["background"]
    c.colors.keyhint.fg = theme["special"]["foreground"]
    c.colors.keyhint.suffix.fg = theme["colors"]["color3"]
    c.colors.messages.error.bg = "#dc143c"
    c.colors.messages.error.border = "#bb0000"
    c.colors.messages.error.fg = "white"
    c.colors.messages.info.bg = "black"
    c.colors.messages.info.border = "#333333"
    c.colors.messages.info.fg = "white"
    c.colors.messages.warning.bg = "darkorange"
    c.colors.messages.warning.border = "#d47300"
    c.colors.messages.warning.fg = "black"
    c.colors.prompts.bg = theme["special"]["background"]
    c.colors.prompts.border = "1px solid " + theme["special"]["background"]
    c.colors.prompts.fg = theme["special"]["foreground"]
    c.colors.prompts.selected.bg = theme["colors"]["color5"]
    c.colors.statusbar.caret.bg = theme["colors"]["color6"]
    c.colors.statusbar.caret.fg = theme["special"]["cursor"]
    c.colors.statusbar.caret.selection.bg = theme["colors"]["color6"]
    c.colors.statusbar.caret.selection.fg = theme["special"]["foreground"]
    c.colors.statusbar.command.bg = theme["special"]["background"]
    c.colors.statusbar.command.fg = theme["special"]["foreground"]
    c.colors.statusbar.command.private.bg = theme["special"]["background"]
    c.colors.statusbar.command.private.fg = theme["special"]["foreground"]
    c.colors.statusbar.insert.bg = theme["colors"]["color2"]
    c.colors.statusbar.insert.fg = theme["special"]["background"]
    c.colors.statusbar.normal.bg = theme["special"]["background"]
    c.colors.statusbar.normal.fg = theme["special"]["foreground"]
    c.colors.statusbar.passthrough.bg = theme["colors"]["color4"]
    c.colors.statusbar.passthrough.fg = theme["special"]["foreground"]
    c.colors.statusbar.private.bg = theme["special"]["background"]
    c.colors.statusbar.private.fg = theme["special"]["foreground"]
    c.colors.statusbar.progress.bg = theme["special"]["foreground"]
    c.colors.statusbar.url.error.fg = theme["colors"]["color5"]
    c.colors.statusbar.url.fg = theme["special"]["foreground"]
    c.colors.statusbar.url.hover.fg = theme["colors"]["color4"]
    c.colors.statusbar.url.success.http.fg = theme["special"]["foreground"]
    c.colors.statusbar.url.success.https.fg = theme["colors"]["color2"]
    c.colors.statusbar.url.warn.fg = theme["colors"]["color1"]
    c.colors.tabs.bar.bg = theme["special"]["background"]
    c.colors.tabs.even.bg = theme["special"]["background"]
    c.colors.tabs.even.fg = theme["special"]["foreground"]
    c.colors.tabs.indicator.error = theme["colors"]["color5"]
    # c.colors.tabs.indicator.start = colors['colors']['color5']
    # c.colors.tabs.indicator.stop = colors['colors']['color1']
    c.colors.tabs.indicator.system = "none"
    c.colors.tabs.odd.bg = theme["special"]["background"]
    c.colors.tabs.odd.fg = theme["special"]["foreground"]
    c.colors.tabs.selected.even.bg = theme["colors"]["color4"]
    c.colors.tabs.selected.even.fg = theme["special"]["foreground"]
    c.colors.tabs.selected.odd.bg = theme["colors"]["color4"]
    c.colors.tabs.selected.odd.fg = theme["special"]["foreground"]
    c.colors.webpage.bg = theme["special"]["background"]


def load_user_stylesheets():
    USER_STYLESHEETS = ["user.css"]


set_theme()
set_fonts()
load_user_stylesheets()

# * Pywal
# colorsfile = os.path.expanduser('~/.cache/wal/qutebrowser_colors.py')
# if os.path.isfile(colorsfile):
#     config.source(colorsfile)

# # default but not transparent
# c.colors.hints.bg = \
#     'qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 rgba(255, 247, 133, 1), ' \
#     + 'stop:1 rgba(255, 197, 66, 1))'

# * Completion
# Move on to the next part when there's only one possible completion
# left.
# c.completion.quick = False

# * Format
# The format to use for the window title. The following placeholders are
# defined:
#   * `{perc}`: The percentage as a string like `[10%]`.
#   * `{perc_raw}`: The raw percentage, e.g. `10`
#   * `{title}`: The title of the current web page
#   * `{title_sep}`: The string ` - ` if a title is set, empty otherwise.
#   * `{id}`: The internal window ID of this window.
#   * `{scroll_pos}`: The page scroll position.
#   * `{host}`: The host of the current web page.
#   * `{backend}`: Either ''webkit'' or ''webengine''
#   * `{private}` : Indicates when private mode is enabled.
# c.window.title_format = '{private}{perc}{title}{title_sep}qutebrowser'


# When to show the autocompletion window.
# Valid values:
#   - always: Whenever a completion is available.
#   - auto: Whenever a completion is requested.
#   - never: Never.
# c.completion.show = 'auto'

# * Scrolling
# keep smooth scrolling off
c.scrolling.bar = "always"
# c.scrolling.bar = True

# Enable smooth scrolling for web pages. Note smooth scrolling does not
# work with the `:scroll-px` command.
# c.scrolling.smooth = False

# lower delay for keyhint dialog (comparable to which-key)
c.keyhint.delay = 250

c.tabs.show = "never"  # always, never, multiple, switching
c.tabs.padding = {"top": 2, "bottom": 2, "left": 0, "right": 4}

# c.colors.webpage.preferred_color_scheme = 'dark'
c.colors.webpage.darkmode.enabled = (
    True if os.path.isfile(f"{HOME}/.QUTE_DARKMODE") else False
)

# c.completion.shrink = True
# c.completion.use_best_match = True
# c.downloads.position = 'bottom'
# c.downloads.remove_finished = 10000
# c.statusbar.widgets = ['progress', 'keypress', 'url', 'history']
# c.tabs.position = 'left'
# c.tabs.title.format = '{index}: {audio}{current_title}'
# c.tabs.title.format_pinned = '{index}: {audio}{current_title}'

# The height of the completion, in px or as percentage of the window.
# c.completion.height = '20%'

# Padding around text for tabs
# c.tabs.padding = {
#     'left': 5,
#     'right': 5,
#     'top': 0,
#     'bottom': 1,
# }
