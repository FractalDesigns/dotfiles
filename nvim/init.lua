-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("config.user_commands")
require("config.just")

require("dap-python").setup("uv")