local theme = {}

-- Function to read the entire contents of a file
local function readFile(filename)
    local file = io.open(filename, "r") -- Open the file in read mode
    if not file then
      return false
    end
    local content = file:read("*all") -- Read the entire file content
    file:close() -- Close the file
    return content
end

-- Function to split a string by newline characters
local function splitLines(content)
    local lines = {}
    for line in content:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end
    return lines
end

function theme.getTheme(defaultTheme, config)
  local home = os.getenv("HOME") or os.getenv("USERPROFILE")
  local filename = home .. "/.cache/wal/colors" -- Replace with your text file path
  local content = readFile(filename)
  if not content then
    return defaultTheme
  end

  local colors = splitLines(content)

  local color_scheme = {
    background = colors[1],
    foreground = colors[16],
    cursor_bg = colors[16],
    cursor_fg = colors[1],
    cursor_border = colors[2],
    selection_fg = colors[1],
    selection_bg = colors[4],
    scrollbar_thumb = colors[1],
    split = colors[10],  -- The color of the split lines between panes

    ansi = {
      'black',
      'maroon',
      'green',
      'olive',
      'navy',
      'purple',
      'teal',
      'silver',
    },
    brights = {
      'grey',
      'red',
      'lime',
      'yellow',
      'blue',
      'fuchsia',
      'aqua',
      'white',
    },

    -- Arbitrary colors of the palette in the range from 16 to 255
    indexed = { [136] = '#af8700' },

    -- Since: 20220319-142410-0fcdea07
    -- When the IME, a dead key or a leader key are being processed and are effectively
    -- holding input pending the result of input composition, change the cursor
    -- to this color to give a visual cue about the compose state.
    compose_cursor = 'orange',

    -- Colors for copy_mode and quick_select
    -- available since: 20220807-113146-c2fee766
    -- In copy_mode, the color of the active text is:
    -- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
    -- 2. selection_* otherwise
    copy_mode_active_highlight_bg = { Color = '#000000' },
    -- use `AnsiColor` to specify one of the ansi color palette values
    -- (index 0-15) using one of the names "Black", "Maroon", "Green",
    --  "Olive", "Navy", "Purple", "Teal", "Silver", "Grey", "Red", "Lime",
    -- "Yellow", "Blue", "Fuchsia", "Aqua" or "White".
    copy_mode_active_highlight_fg = { AnsiColor = 'Black' },
    copy_mode_inactive_highlight_bg = { Color = '#52ad70' },
    copy_mode_inactive_highlight_fg = { AnsiColor = 'White' },

    quick_select_label_bg = { Color = 'peru' },
    quick_select_label_fg = { Color = '#ffffff' },
    quick_select_match_bg = { AnsiColor = 'Navy' },
    quick_select_match_fg = { Color = '#ffffff' },
  }

  config.color_schemes = {
    ['Wal'] = color_scheme
  }

  return 'Wal'
end

return theme
