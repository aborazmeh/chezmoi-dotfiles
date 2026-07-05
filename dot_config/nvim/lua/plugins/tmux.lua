return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
    "TmuxNavigatorProcessList",
  },
  keys = {
    { "<M-h>", "<cmd>TmuxNavigateLeft<cr>" },
    { "<M-j>", "<cmd>TmuxNavigateDown<cr>" },
    { "<M-k>", "<cmd>TmuxNavigateUp<cr>" },
    { "<M-l>", "<cmd>TmuxNavigateRight<cr>" },

    { "<M-Left>", "<cmd>TmuxNavigateLeft<cr>" },
    { "<M-Down>", "<cmd>TmuxNavigateDown<cr>" },
    { "<M-Up>", "<cmd>TmuxNavigateUp<cr>" },
    { "<M-Right>", "<cmd>TmuxNavigateRight<cr>" },

    { "<M-[>", "<cmd>TmuxNavigatePrevious<cr>" },
  },
}
