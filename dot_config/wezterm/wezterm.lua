local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local mux = wezterm.mux
local act = wezterm.action
local theme = require("theme")

config.enable_wayland = true
config.enable_scroll_bar = true

config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = false

config.hide_mouse_cursor_when_typing = false
config.use_dead_keys = false
config.scrollback_lines = 5000
config.adjust_window_size_when_changing_font_size = false

window_frame = {
  font = wezterm.font { family = 'Noto Sans', weight = 'Regular' },
}

config.font_shaper = "Harfbuzz"
config.font = wezterm.font('JetBrainsMono') -- Fira Code
config.font_size = 11
config.line_height = 1.2

-- getTheme args: a default theme name, and config variable
-- config.color_scheme = theme.getTheme('OneDark (base16)', config)
config.color_scheme = 'OneDark (base16)'


config.disable_default_key_bindings = false
-- config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 2000 }
config.keys = {
  -- { key = 'l', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(1) },
  -- { key = 'h', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
  -- { key = 'j', mods = 'CTRL', action = act.ActivatePaneDirection 'Down', },
  -- { key = 'k', mods = 'CTRL', action = act.ActivatePaneDirection 'Up', },
  -- { key = 'Enter', mods = 'CTRL', action = act.ActivateCopyMode },
  -- { key = 'R', mods = 'SHIFT|CTRL', action = act.ReloadConfiguration },
  -- { key = '+', mods = 'CTRL', action = act.IncreaseFontSize },
  -- { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
  -- { key = '0', mods = 'CTRL', action = act.ResetFontSize },
  -- { key = 'C', mods = 'SHIFT|CTRL', action = act.CopyTo 'Clipboard' },
  -- { key = 'N', mods = 'SHIFT|CTRL', action = act.SpawnWindow },
  -- { key = 'U', mods = 'SHIFT|CTRL', action = act.CharSelect{ copy_on_select = true, copy_to =  'ClipboardAndPrimarySelection' } },
  -- { key = 'v', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
  -- { key = 'PageUp', mods = 'CTRL', action = act.ActivateTabRelative(-1) },
  -- { key = 'PageDown', mods = 'CTRL', action = act.ActivateTabRelative(1) },
  -- { key = 'LeftArrow', mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection 'Left' },
  -- { key = 'RightArrow', mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection 'Right' },
  -- { key = 'UpArrow', mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection 'Up' },
  -- { key = 'DownArrow', mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection 'Down' },
  -- { key = 'f', mods = 'CTRL', action = act.SplitVertical { domain = 'CurrentPaneDomain' }, },
  -- { key = 'd', mods = 'CTRL', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' }, },
  -- { key = 'h', mods = 'CTRL', action = act.ActivatePaneDirection 'Left', },
  -- { key = 'l', mods = 'CTRL', action = act.ActivatePaneDirection 'Right', },
  -- { key = 't', mods = 'CTRL', action = act.SpawnTab 'CurrentPaneDomain' },
  -- { key = 'w', mods = 'CTRL', action = act.CloseCurrentTab{ confirm = false } },
  -- { key = 'x', mods = 'CTRL', action = act.CloseCurrentPane{ confirm = false } },
  -- { key = 'b', mods = 'LEADER|CTRL', action = act.SendString '\x02', },
  -- { key = 'Enter', mods = 'LEADER', action = act.ActivateCopyMode, },
  -- { key = 'p', mods = 'LEADER', action = act.PasteFrom 'PrimarySelection', },
  -- { key = 'k', mods = 'CTRL|ALT', action = act.Multiple,
  --   { act.ClearScrollback 'ScrollbackAndViewport', act.SendKey { key = 'L', mods = 'CTRL' }}
  -- },
  -- { key = 'r', mods = 'LEADER', action = act.ActivateKeyTable { name = 'resize_pane', one_shot = false, }, },
}
return config
