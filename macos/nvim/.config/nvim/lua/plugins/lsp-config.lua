return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "lua_ls",
        "bashls",
        "pylsp", -- "basedpyright",
        "ruff",
        "marksman",
        "clangd",
        "neocmake",
        "html",
        "cssls",
        "djlsp",
        "copilot",
      },
      automatic_installation = false,
    },
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = {
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        },
      },
      "neovim/nvim-lspconfig",
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        -- lua
        "stylua",
        -- shell
        "shfmt",
        -- python
        "debugpy",
        "mypy",
        -- "black",
        -- c/c++
        "clang-format",
        "codelldb",
        "cmakelang",
        "cmakelint",
        -- markdown
        "markdownlint-cli2",
        "markdown-toc",
        -- web
        "djlint",
        "emmet_ls", -- "jinja_lsp",
        "prettierd", -- prettier
        -- docker
        "hadolint",
      },
    },
    dependencies = {
      "williamboman/mason.nvim",
    },
  },
  -- For vim development
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      --[[ library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      }, ]]
    },
  },
}
