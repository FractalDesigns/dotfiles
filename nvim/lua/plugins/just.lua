return {
  {
    "my-just-plugin",
    dir = ".",
    config = function()
      local M = {}
      local function create_floating_terminal(cmd)
        local buf = vim.api.nvim_create_buf(false, true)
        local width = math.floor(vim.o.columns * 0.8)
        local height = math.floor(vim.o.lines * 0.8)

        local opts = {
          relative = "editor",
          width = width,
          height = height,
          row = math.floor((vim.o.lines - height) / 2),
          col = math.floor((vim.o.columns - width) / 2),
          style = "minimal",
          border = "rounded",
        }

        local win = vim.api.nvim_open_win(buf, true, opts)

        -- Enable text selection and mouse control
        vim.opt_local.mouse = "a"
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"

        -- Start terminal with persistent buffer
        vim.fn.termopen(cmd, {
          on_exit = function()
            -- Optional: Add visual indication when process exits
            vim.api.nvim_buf_set_lines(buf, 0, 0, true, { "[Process exited] Press q to close" })
          end,
        })

        -- Key mappings for closing/navigation
        vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>q!<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<cmd>q!<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(buf, "t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })

        -- Auto-enter insert mode for new terminals
        vim.cmd("startinsert")

        -- Setup terminal buffer behaviors
        vim.api.nvim_create_autocmd("TermClose", {
          buffer = buf,
          callback = function()
            vim.schedule(function()
              -- Switch to normal mode when process ends
              vim.cmd("stopinsert")
            end)
          end,
        })
      end

      -- Get just recipes
      local function get_recipes()
        local handle = io.popen("just --summary 2>&1")
        if not handle then
          vim.notify("Failed to execute 'just' command", vim.log.levels.ERROR)
          return {}
        end

        local result = handle:read("*a")
        handle:close()

        if result:match("error") or result:match("not found") then
          vim.notify("Justfile not found: " .. result, vim.log.levels.WARN)
          return {}
        end

        local recipes = {}
        for recipe in result:gmatch("%S+") do
          table.insert(recipes, recipe)
        end
        return recipes
      end

      -- Main function to select and run recipe
      function M.select_and_run_recipe()
        local recipes = get_recipes()
        if #recipes == 0 then
          return
        end

        vim.ui.select(recipes, {
          prompt = "Select a recipe to run:",
        }, function(choice)
          if choice then
            create_floating_terminal("just " .. choice)
          end
        end)
      end

      -- Setup function
      function M.setup()
        vim.keymap.set("n", "<leader>j", M.select_and_run_recipe, {
          desc = "Select and run just recipe",
        })
      end

      M.setup()
    end,
  },
}
