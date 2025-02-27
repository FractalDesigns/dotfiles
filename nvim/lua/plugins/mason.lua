return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "rust-analyzer",
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
      },
    },
  },
}
