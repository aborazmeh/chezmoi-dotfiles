---------------------------
-- Default awesome theme --
---------------------------

theme = {}

theme.confdir       = os.getenv("HOME") .. "/.config/awesome/theme"
print(theme.confdir)

theme.font          = "sans 8"

theme.wallpaper = theme.confdir .. "/background.png"
theme.flags = theme.confdir .. "/icons/flags"

theme.bg_normal     = "#222222"
theme.bg_focus      = "#535d6c"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.border_width  = 1
theme.border_normal = "#000000"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Display the taglist squares
theme.taglist_squares_sel   = theme.confdir .. "/taglist/squaref.png"
theme.taglist_squares_unsel = theme.confdir .. "/taglist/square.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = theme.confdir .. "/submenu.png"
theme.menu_height = 15
theme.menu_width  = 100

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = theme.confdir .. "/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = theme.confdir .. "/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = theme.confdir .. "/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = theme.confdir .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = theme.confdir .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = theme.confdir .. "/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = theme.confdir .. "/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = theme.confdir .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = theme.confdir .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = theme.confdir .. "/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = theme.confdir .. "/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = theme.confdir .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = theme.confdir .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = theme.confdir .. "/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = theme.confdir .. "/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = theme.confdir .. "/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = theme.confdir .. "/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = theme.confdir .. "/titlebar/maximized_focus_active.png"


-- You can use your own layout icons like this:
theme.layout_fairh = theme.confdir .. "/layouts/fairh.png"
theme.layout_fairv = theme.confdir .. "/layouts/fairv.png"
theme.layout_floating  = theme.confdir .. "/layouts/floating.png"
theme.layout_magnifier = theme.confdir .. "/layouts/magnifier.png"
theme.layout_max = theme.confdir .. "/layouts/max.png"
theme.layout_fullscreen = theme.confdir .. "/layouts/fullscreen.png"
theme.layout_tilebottom = theme.confdir .. "/layouts/tilebottom.png"
theme.layout_tileleft   = theme.confdir .. "/layouts/tileleft.png"
theme.layout_tile = theme.confdir .. "/layouts/tile.png"
theme.layout_tiletop = theme.confdir .. "/layouts/tiletop.png"
theme.layout_spiral  = theme.confdir .. "/layouts/spiral.png"
theme.layout_dwindle = theme.confdir .. "/layouts/dwindle.png"

-- {{{ Separators
theme.arrl = theme.confdir .. "/separators/arrl.png"
theme.arrl_dl = theme.confdir .. "/separators/arrl_dl.png"
theme.arrl_ld = theme.confdir .. "/separators/arrl_ld.png"
theme.arrl_sf = theme.confdir .. "/separators/arrl_sf.png"
theme.arrl_dl_sf = theme.confdir .. "/separators/arrl_dl_sf.png"
theme.arrl_ld_sf = theme.confdir .. "/separators/arrl_ld_sf.png"
theme.arrr = theme.confdir .. "/separators/arrr.png"
theme.arrr_dl = theme.confdir .. "/separators/arrr_dl.png"
theme.arrr_ld = theme.confdir .. "/separators/arrr_ld.png"
theme.arrr_sf = theme.confdir .. "/separators/arrr_sf.png"
theme.arrr_dl_sf = theme.confdir .. "/separators/arrr_dl_sf.png"
theme.arrr_ld_sf = theme.confdir .. "/separators/arrr_ld_sf.png"
-- }}}

-- {{{ Tags icons
theme.tags_globe = theme.confdir .. "/icons/tags/glob-small-green.png"
-- }}}

-- {{{ Prompt icons
theme.prompt_calc = theme.confdir .. "/icons/calc.png"
theme.prompt_trans = theme.confdir .. "/icons/trans.png"
theme.prompt_terminal = theme.confdir .. "/icons/terminal.png"
theme.prompt_wiki = theme.confdir .. "/icons/wiki.png"
-- }}}

-- {{{ Menus icons
theme.prompt_menu_insert_symbol = theme.confdir .. "/icons/omega.png"
-- }}}
-- {{{ Widgets icons
theme.widget_netdown = theme.confdir .. "/icons/net_down.png"
theme.widget_netup = theme.confdir .. "/icons/net_up.png"
theme.widget_vol = theme.confdir .. "/icons/vol.png"
theme.widget_vol_low = theme.confdir .. "/icons/vol_low.png"
theme.widget_vol_no = theme.confdir .. "/icons/vol_no.png"
theme.widget_vol_mute = theme.confdir .. "/icons/vol_mute.png"
theme.widget_cpu = theme.confdir .. "/icons/cpu.png"
theme.widget_temp = theme.confdir .. "/icons/temp.png"
theme.widget_mem = theme.confdir .. "/icons/mem.png"
theme.widget_fs = theme.confdir .. "/icons/fs.png"
theme.widget_mail = theme.confdir .. "/icons/mail.png"
theme.widget_usb = theme.confdir .. "/icons/usb.png"
theme.widget_bat = theme.confdir .. "/icons/bat.png"
theme.widget_bat_low = theme.confdir .. "/icons/bat_low.png"
theme.widget_bat_no = theme.confdir .. "/icons/bat_no.png"
theme.widget_bat_ac = theme.confdir .. "/icons/ac.png"
theme.widget_note_on = theme.confdir .. "/icons/note_on.png"
theme.widget_mpd = theme.confdir .. "/icons/mpd.png"
theme.widget_prev = theme.confdir .. "/icons/prev.png"
theme.widget_next = theme.confdir .. "/icons/next.png"
theme.widget_ff = theme.confdir .. "/icons/ff.png"
theme.widget_bb = theme.confdir .. "/icons/bb.png"
theme.widget_stop = theme.confdir .. "/icons/stop.png"
theme.widget_pause = theme.confdir .. "/icons/pause.png"
theme.widget_play = theme.confdir .. "/icons/play.png"
theme.widget_facebook = theme.confdir .. "/icons/facebook.png"
theme.widget_twitter = theme.confdir .. "/icons/twitter.png"
theme.widget_rss = theme.confdir .. "/icons/rss.png"
theme.widget_podcast = theme.confdir .. "/icons/podcast.png"
theme.widget_todo = theme.confdir .. "/icons/todo.png"
-- }}}

theme.awesome_icon = "/usr/share/awesome/icons/awesome16.png"

-- Define the icon theme for application icons. If not set then the icons 
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
