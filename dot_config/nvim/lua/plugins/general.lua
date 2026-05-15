return {
  {
    "chrisgrieser/nvim-rip-substitute",
    keys = {
      {
        "g/",
        function()
          require("rip-substitute").sub()
        end,
        mode = { "n", "x" },
        desc = "rip substitute",
      },
    },
  },
  {
    "lambdalisue/vim-suda",
    keys = {
      {
        "<M-s>",
        function()
          vim.cmd("SudaWrite")
        end,
        mode = { "n" },
        desc = "save file with sudo",
      },
    },
  },
}
