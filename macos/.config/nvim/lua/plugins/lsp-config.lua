return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before it's dependencies
      -- NOTE: `opts={}`== `require('mason').setup({})`
      { "williamboman/mason.nvim", opts = {} },
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "hrsh7th/cmp-nvim-lsp",
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
        },
      })

      -- Setup CMP
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())

      -- Setup LSP
      local servers = {
        lua_ls = {},
        marksman = {},
        html = {},
        cssls = {},
        emmet_ls = {},

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

        --[[ -- Pyright, basedpyright
        pyright = {
          -- on_attach = function(client, bufnr)
          --   vim.keymap.set("n", "<leader>co", "<CMD>PyrightOrganizeImports<CR>", {})
          -- end,
          settings = {
            basedpyright = {
              disableOrganizeImports = true, -- Using Ruff's import organizer
              disableLanguageServices = false,
              analysis = {
                ignore = { "*" },                 -- Ignore all files for analysis to exclusively use Ruff for linting
                typeCheckingMode = "off",
                diagnosticMode = "openFilesOnly", -- Only analyze open files
                useLibraryCodeForTypes = true,
                autoImportCompletions = true,     -- whether pyright offers auto-import completions
              },
            },
            python = {
              analysis = {},
            },
          },
        }, ]]

        ruff = {
          on_attach = function(client, bufnr)
            if client.name == "ruff" then
              -- Disable hover in favor of Pyright.
              client.server_capabilities.hoverProvider = false
              -- client.server_capabilities.diagnosticProvider = false
            end
          end,
          commands = {
            -- ruff code action 추가
            -- Notes on code actions: https://github.com/astral-sh/ruff-lsp/issues/119#issuecomment-1595628355
            -- Get isort like behavior: https://github.com/astral-sh/ruff/issues/8926#issuecomment-1834048218
            RuffAutofix = {
              function()
                vim.lsp.buf.execute_command({
                  command = "ruff.applyAutofix",
                  arguments = {
                    { uri = vim.uri_from_bufnr(0) },
                  },
                })
              end,
              description = "Ruff: Fix all auto-fixable problems",
            },
            RuffOrganizeImports = {
              function()
                vim.lsp.buf.execute_command({
                  command = "ruff.applyOrganizeImports",
                  arguments = {
                    { uri = vim.uri_from_bufnr(0) },
                  },
                })
              end,
              description = "Ruff: Format imports",
            },
          },
        },

        -- C/C++
        neocmake = {},
        clangd = {
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
          on_attach = function(client, bufnr)
            client.server_capabilities.signatureHelperProvider = false
            require("clangd_extensions").setup()
          end,
          keys = {
            {
              "<leader>ch",
              "<cmd>ClangdSwitchSourceHeader<cr>",
              desc = "Switch Source/Header (C/C++)",
            },
          },
          cmd = {
            "clangd",
            "--log=verbose",
            "--background-index",
            "--clang-tidy",
            --"--clang-tidy-checks=performance-*,bugprone-*"
            "--suggest-missing-includes",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
            --"--query-driver=/usr/bin/gcc,/usr/bin/g++
            --,/usr/local/gcc-15,/usr/bin/clang, /Library/Developer/CommandLineTools/usr/bin/c++",
            --"--compile-commands-dir=build",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },
      }

      require("mason-lspconfig").setup({
        -- explicitly set to an empty table (done via mason-tool-installer)
        ensure_installed = {},
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })

      -- show diagnostics message on screen
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config({
        severity_sort = true,
        -- underline = false,
        underline = {
          severity = vim.diagnostic.severity.ERROR,
        },
        -- update_in_insert = false,
        virtual_text = {
          source = "if_many",
          spacing = 2,
          prefix = "●",
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
        float = {
          border = "rounded",
          source = "if_many", -- true
          -- show_header = true,
          -- focus = false,
          -- width = 60,
        },
      })
    end,
  },
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    opts = {
      ast = {
        role_icons = {
          type = "",
          declaration = "",
          expression = "",
          specifier = "",
          statement = "",
          ["template argument"] = "",
        },

        kind_icons = {
          Compound = "",
          Recovery = "",
          TranslationUnit = "",
          PackExpansion = "",
          TemplateTypeParm = "",
          TemplateTemplateParm = "",
          TemplateParamObject = "",
        },
        highlights = {
          detail = "Comment",
        },
      },
    },
  },
}
