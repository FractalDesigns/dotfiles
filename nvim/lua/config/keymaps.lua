-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<A-i>", '<CMD>lua require("FTerm").toggle()<CR>')
vim.keymap.set("t", "<A-i>", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')
-- open gitlab pipeline in browser
vim.keymap.set(
  "n",
  "<leader>gw",
  ":!glab ci view --web<CR>",
  { noremap = true, silent = true, desc = "View Gitlab CI in web" }
)
vim.keymap.set(
  "n",
  "<leader>gha",
  ":!gh run view --web (gh run list --branch (git rev-parse --abbrev-ref HEAD) --limit 1 --json databaseId --jq '.[0].databaseId')<CR>",
  { noremap = true, silent = true, desc = "Open github action pipeline in web browser" }
)
