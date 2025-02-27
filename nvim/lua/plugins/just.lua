local M = {}

-- Function to create a floating terminal
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
  vim.fn.termopen(cmd, {
    on_exit = function()
      vim.defer_fn(function()
        vim.api.nvim_win_close(win, true)
      end, 2000)
    end,
  })
  vim.cmd("startinsert")
end

-- Function to get recipes using just --summary
local function get_recipes()
  local handle = io.popen("just --summary")
  if not handle then
    return {}
  end

  local result = handle:read("*a")
  handle:close()

  -- Split the summary string into individual recipes
  local recipes = {}
  for recipe in result:gmatch("%S+") do
    table.insert(recipes, recipe)
  end
  return recipes
end

function M.select_and_run_recipe()
  local recipes = get_recipes()

  vim.ui.select(recipes, {
    prompt = "Select a recipe to run:",
  }, function(choice)
    if choice then
      create_floating_terminal("just " .. choice)
    end
  end)
end

function M.setup()
  vim.keymap.set("n", "<leader>j", M.select_and_run_recipe, {
    desc = "Select and run just recipe",
  })
end

M.setup()
return M
