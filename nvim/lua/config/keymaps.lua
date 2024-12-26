-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- vim.keymap.set("n", "<leader>fj", function()
--   local just = require("plugins.just")
--   print(just.just_recipes())
-- end, { desc = "Find Just recipes" })

-- require("plugins.just").setup()
--

vim.keymap.set("n", "<A-i>", '<CMD>lua require("FTerm").toggle()<CR>')
vim.keymap.set("t", "<A-i>", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')
local fterm = require("plugins.fterm")
