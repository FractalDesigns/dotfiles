-- lazy.nvim
--
return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    picker = {
      sources = {
        explorer = {
          hidden = true,
          layout = {
            layout = {
              position = "right"
            }
          },
        },
        buffers = {
          hidden = true,
        },
      },
    },
  },
}
