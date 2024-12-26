vim.api.nvim_create_user_command("ManLs", function()
  require("FTerm").run("man ls")
end, { bang = true })

-- vim.api.nvim_create_user_command('YarnBuild', function()
--     require('FTerm').run({'yarn', 'build'})
-- end, { bang = true })
--
