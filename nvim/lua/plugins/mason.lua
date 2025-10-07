return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "rust-analyzer",
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
        "debugpy",
      },
    },
  },
}
