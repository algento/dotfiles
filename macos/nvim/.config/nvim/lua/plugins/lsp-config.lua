return {
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
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        -- LSP Servers
        "lua-language-server",
        "bash-language-server",
        "python-lsp-server",
        "ruff",
        "clangd",
        "neocmakelsp",
        "html-lsp",
        "css-lsp",
        "django-template-lsp",
        "copilot-language-server",
        "marksman",

        -- Formatters / Linters / Tools
        "stylua",
        "shfmt",
        "debugpy",
        "mypy",
        "clang-format",
        "codelldb",
        "cmakelang",
        "cmakelint",
        "markdownlint-cli2",
        "markdown-toc",
        "djlint",
        "emmet-ls",
        "prettierd",
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
    opts = {},
  },
}
