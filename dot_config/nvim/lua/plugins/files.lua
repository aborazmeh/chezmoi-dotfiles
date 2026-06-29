return {
  "dmtrKovalenko/fff.nvim",
  build = function()
    -- downloads a prebuilt binary or falls back to cargo build
    require("fff.download").download_or_build_binary()
  end,
  -- for nixos:
  -- build = "nix run .#release",
  opts = {
    debug = {
      enabled = true,
      show_scores = true,
    },
  },
  lazy = false, -- the plugin lazy-initialises itself
  keys = function()
    local find = function(keys, func, args, desc)
      return {
        keys,
        function()
          (require("fff")[func] or require("fff").find_files)(args)
        end,
        desc = desc or "FFFind files",
      }
    end

    return {
      find("<leader>ff"),
      find("<leader><leader>"),
      find("ff"),
      find("fg", "live_grep", nil, "LiFFFe grep"),
      find("fz", "live_grep", { grep = { modes = { "fuzzy", "plain" } } }, "Live fffuzy grep"),
      find("fc", "live_grep", { query = vim.fn.expand("<cword>") }, "Search current word"),
    }
  end,
}
