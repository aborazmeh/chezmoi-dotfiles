return {
  {
    "mcookly/bidi.nvim",
    opts = {
      create_user_commands = true, -- Generate user commands to enable and disable bidi-mode
      default_base_direction = "LR", -- Options: 'LR' and 'RL'
      intuitive_delete = true, -- Swap <DEL> and <BS> when using a keymap contra base direction
    },
  },
  { "OXY2DEV/markview.nvim", lazy = false },
  {
    "preservim/vim-pencil",
  },
  {
    "nvim-mini/mini.pairs",
    opts = {
      modes = { insert = true, command = false, terminal = false },
      mappings = {
        ["«"] = { action = "open", pair = "«»", neigh_pattern = "[^\\]." },
        ["»"] = { action = "close", pair = "«»", neigh_pattern = "[^\\]." },
      },
    },
  },
  {
    "folke/twilight.nvim",
    opts = {
      dimming = {
        alpha = 0.25, -- amount of dimming
        -- we try to get the foreground from the highlight groups or fallback color
        color = { "Normal", "#ffffff" },
        term_bg = "#000000", -- if guibg=NONE, this will be used to calculate text color
        inactive = false, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
      },
      context = 10, -- amount of lines we will try to show around the current line
      treesitter = true, -- use treesitter when available for the filetype
      -- treesitter is used to automatically expand the visible text,
      -- but you can further control the types of nodes that should always be fully expanded
      expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
        "function",
        "method",
        "table",
        "if_statement",
      },
      exclude = {}, -- exclude these filetypes
    },
  },
  {
    "pocco81/true-zen.nvim",
    opts = {
      modes = { -- configurations per mode
        ataraxis = {
          shade = "dark", -- if `dark` then dim the padding windows, otherwise if it's `light` it'll brighten said windows
          backdrop = 0, -- percentage by which padding windows should be dimmed/brightened. Must be a number between 0 and 1. Set to 0 to keep the same background color
          minimum_writing_area = { -- minimum size of main window
            width = 70,
            height = 44,
          },
          quit_untoggles = true, -- type :q or :qa to quit Ataraxis mode
          padding = { -- padding windows
            left = 52,
            right = 52,
            top = 0,
            bottom = 0,
          },
          callbacks = { -- run functions when opening/closing Ataraxis mode
            open_pre = nil,
            open_pos = nil,
            close_pre = nil,
            close_pos = nil,
          },
        },
        minimalist = {
          ignored_buf_types = { "nofile" }, -- save current options from any window except ones displaying these kinds of buffers
          options = { -- options to be disabled when entering Minimalist mode
            number = false,
            relativenumber = false,
            showtabline = 0,
            signcolumn = "no",
            statusline = "",
            cmdheight = 1,
            laststatus = 0,
            showcmd = false,
            showmode = false,
            ruler = false,
            numberwidth = 1,
          },
          callbacks = { -- run functions when opening/closing Minimalist mode
            open_pre = nil,
            open_pos = nil,
            close_pre = nil,
            close_pos = nil,
          },
        },
        narrow = {
          --- change the style of the fold lines. Set it to:
          --- `informative`: to get nice pre-baked folds
          --- `invisible`: hide them
          --- function() end: pass a custom func with your fold lines. See :h foldtext
          folds_style = "informative",
          run_ataraxis = true, -- display narrowed text in a Ataraxis session
          callbacks = { -- run functions when opening/closing Narrow mode
            open_pre = nil,
            open_pos = nil,
            close_pre = nil,
            close_pos = nil,
          },
        },
        focus = {
          callbacks = { -- run functions when opening/closing Focus mode
            open_pre = nil,
            open_pos = nil,
            close_pre = nil,
            close_pos = nil,
          },
        },
      },
      integrations = {
        tmux = false, -- hide tmux status bar in (minimalist, ataraxis)
        kitty = { -- increment font size in Kitty. Note: you must set `allow_remote_control socket-only` and `listen_on unix:/tmp/kitty` in your personal config (ataraxis)
          enabled = false,
          font = "+3",
        },
        twilight = false, -- enable twilight (ataraxis)
        lualine = false, -- hide nvim-lualine (ataraxis)
      },
    },
  },
}
