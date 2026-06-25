-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Writing keymaps
vim.api.nvim_create_autocmd("BufNew", {
    callback = function()
        local filetypes = { "markdown", "tex", "text", "rst" }
        for _, ft in ipairs(filetypes) do
            if vim.bo.filetype == ft then
                map("i", "<M-a>", "<cmd>:set arabic!<cr>", { desc = "Toggle Arabic mode", buffer = true })
                map("n", "<leader>a", ":set arabic!<cr>", { desc = "Toggle Arabic mode", buffer = true })
                map("n", "<leader>W", ":HemingwayToggle<cr>", { desc = "Toggle Hemingway mode", buffer = true })
                break
            end
        end
    end,
})

-- chezmoi
vim.keymap.set("n", "<leader>cz", function()
  require("chezmoi.pick").telescope()
end)

vim.keymap.set('n', '<leader>fc', function()
  require("chezmoi.pick").telescope(
    targets = vim.fn.stdpath("config"),
    args = {
      "--path-style",
      "absolute",
      "--include",
      "files",
      "--exclude",
      "externals",
    }
  )
end)
