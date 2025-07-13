return {
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    opts = {},
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    -- For `nvim-treesitter` users.
    priority = 49,

    -- For blink.cmp's completion
    -- source
    -- dependencies = {
    --     "saghen/blink.cmp"
    -- },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "c",
        "cpp",
        "python",
        "ninja",
        "bash",
        "markdown",
        "markdown_inline",
        "latex",
        "html",
        "cmake",
      },
    },
    config = function(_, opts)
      local config = require("nvim-treesitter.configs")
      config.setup({
        --ensure_installed = {
        --  "lua",
        --},
        opts = opts,
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
}
