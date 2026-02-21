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
    -- Brief aside: **What is LSP?**
    --
    -- LSP is an initialism you've probably heard, but might not understand what it is.
    --
    -- LSP stands for Language Server Protocol. It's a protocol that helps editors
    -- and language tooling communicate in a standardized fashion.
    --
    -- In general, you have a "server" which is some tool built to understand a particular
    -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
    -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
    -- processes that communicate with some "client" - in this case, Neovim!
    --
    -- LSP provides Neovim with features like:
    --  - Go to definition
    --  - Find references
    --  - Autocompletion
    --  - Symbol Search
    --  - and more!
    --
    -- Thus, Language Servers are external tools that must be installed separately from
    -- Neovim. This is where `mason` and related plugins come into play.
    --
    -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
    -- and elegantly composed help section, `:help lsp-vs-treesitter`
    "neovim/nvim-lspconfig",
    dependencies = {
      -- automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before it's dependencies
      -- NOTE: `opts={}`== `require('mason').setup({})`
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      -- Useful status updates for LSP.
      -- { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
      -- Ensure the servers and tools are installed
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- lua
          "stylua",
          "lua_ls",
          -- shell
          "bashls",
          "shfmt",
          -- python
          "pylsp", -- "basedpyright",
          "debugpy",
          "mypy",
          "ruff", -- "black",
          -- c/c++
          "clangd",
          "clang-format",
          "neocmake",
          "codelldb",
          "cmakelang",
          "cmakelint",
          -- markdown
          "marksman",
          "markdownlint-cli2",
          "markdown-toc",
          -- web
          "html",
          "cssls",
          "djlint",
          "emmet_ls", -- "jinja_lsp",
          "prettierd",
          "django-template-lsp",
          -- docker
          "hadolint",
        },
      })

      -- Setup CMP
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- local blink_capabilities = require("blink.cmp").get_lsp_capabilities()
      -- capabilities = vim.tbl_deep_extend("force", capabilities, blink_capabilities)

      if package.loaded["blink.cmp"] then
        capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
      end
      -- # Setup LSP
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local util = require("lspconfig.util")
      local servers = {
        lua_ls = {
          -- root_dir = function(fname)
          --   return util.root_pattern("init.lua")(fname) -- init.lua 있는 폴더를 루트로
          --     or util.find_git_ancestor(fname) -- 없으면 git root
          --     or util.path.dirname(fname)
          -- end,
        },
        marksman = {},
        html = {},
        cssls = {},
        emmet_ls = {},
        djlsp = {},

        -- Python
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                pyflakes = { enabled = false },
                pycodestyle = { enabled = false },
                autopep8 = { enabled = false },
                yapf = { enabled = false },
                mccabe = { enabled = false },
                pylsp_mypy = { enabled = false },
                pylsp_black = { enabled = false },
                pylsp_isort = { enabled = false },
              },
            },
          },
        },

        ruff = {
          on_attach = function(client, bufnr)
            if client.name == "ruff" then
              -- Disable hover in favor of Pyright.
              client.server_capabilities.signatureHelpProvider = false
              client.server_capabilities.hoverProvider = false
              -- client.server_capabilities.diagnosticProvider = false
            end
          end,
        },

        -- C/C++
        neocmake = {},
        clangd = {
          cmd = {
            "/opt/homebrew/opt/llvm/bin/clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
            "--compile-commands-dir=build",
            "--suggest-missing-includes",
            "--completion-style=detailed",
            "--include-ineligible-results",
            "--clang-tidy-checks=performance-*,bugprone-*",
            -- "/opt/homebrew/opt/llvm/bin/clangd",
            -- "--log=verbose",
            -- "--background-index",
            -- "--clang-tidy",
            -- "--header-insertion=iwyu",
            -- "--function-arg-placeholders",
            -- "--fallback-style=llvm",
            --"--query-driver=/usr/bin/gcc,/usr/bin/g++,/usr/local/gcc-15,/usr/bin/clang,/Library/Developer/CommandLineTools/usr/bin/c++",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
        },
      }

      require("mason-lspconfig").setup({
        -- explicitly set to an empty table (done via mason-tool-installer)
        ensure_installed = {},
        automatic_installation = false,
      })
      local function chain_on_attach(a, b)
        if a == nil then
          return b
        end
        if b == nil then
          return a
        end
        return function(client, bufnr)
          a(client, bufnr)
          b(client, bufnr)
        end
      end

      -- 공통 on_attach가 필요하면 여기 정의 (LspAttach만 쓰면 없어도 됨)
      local function common_on_attach(_, _) end

      for name, opts in pairs(servers) do
        local server_opts = vim.tbl_deep_extend("force", {}, opts)

        -- capabilities 병합
        server_opts.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server_opts.capabilities or {})

        -- on_attach 체이닝(선택)
        server_opts.on_attach = chain_on_attach(common_on_attach, server_opts.on_attach)

        -- Neovim 0.11+ 네이티브 등록
        vim.lsp.config(name, server_opts)
      end
    end,
  },
}
