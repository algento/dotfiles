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
          "lua_ls",
          "prettierd",
          -- python
          "pylsp", -- "basedpyright",
          "debugpy",
          "mypy",
          "ruff", -- "black",
          -- c/c++
          "clangd",
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
          "emmet_ls", -- "jinja_lsp",
        },
      })

      -- Setup CMP
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        cmp_nvim_lsp.default_capabilities()
      )
      -- Setup LSP
      local lspconfig = require("lspconfig")
      local util = require("lspconfig.util")

      --vim.lsp.config["lua_ls"] = {
      --	capabilities = capabilities,
      --}
      --vim.lsp.enable("lua_ls")

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
      })

      lspconfig.pylsp.setup({
        capabilities = capabilities,
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
      })

      -- lspconfig.basedpyright.setup({
      -- 	-- Config options: https://github.com/DetachHead/basedpyright/blob/main/docs/settings.md
      -- 	capabilities = capabilities,
      -- 	-- on_attach = function(client, bufnr)
      -- 	--   vim.keymap.set("n", "<leader>co", "<CMD>PyrightOrganizeImports<CR>", {})
      -- 	-- end,
      -- 	settings = {
      -- 		basedpyright = {
      -- 			disableOrganizeImports = true, -- Using Ruff's import organizer
      -- 			disableLanguageServices = false,
      -- 			analysis = {
      -- 				ignore = { "*" }, -- Ignore all files for analysis to exclusively use Ruff for linting
      -- 				typeCheckingMode = "off",
      -- 				diagnosticMode = "openFilesOnly", -- Only analyze open files
      -- 				useLibraryCodeForTypes = true,
      -- 				autoImportCompletions = true, -- whether pyright offers auto-import completions
      -- 			},
      -- 		},
      -- 		python = {
      -- 			analysis = {},
      -- 		},
      -- 	},
      -- })

      lspconfig.ruff.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          if client.name == "ruff" then
            -- Disable hover in favor of Pyright.
            client.server_capabilities.hoverProvider = false
            -- client.server_capabilities.diagnosticProvider = false
          end
        end,
        -- settings = {
        --   lint = {
        --     enable = false,
        --   },
        -- },
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
      })

      lspconfig.clangd.setup({
        capabilities = capabilities,
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
        root_dir = function(fname)
          return util.root_pattern(
            "Makefile",
            "configure.ac",
            "configure.in",
            "config.h.in",
            "meson.build",
            "meson_options.txt",
            "build.ninja"
          )(fname) or util.root_pattern("compile_commands.json", "compile_flags.txt")(fname) or util.find_git_ancestor(
            fname
          )
        end,
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
          --"--query-driver=/usr/bin/gcc,/usr/bin/g++,/Library/Developer/CommandLineTools/usr/bin/c++",
          --"--query-driver=/usr/local/bin/gcc-15, /usr/local/bin/c++-15, /usr/bin/clang",
          --"--compile-commands-dir=build",
        },
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
      })

      lspconfig.neocmake.setup({
        capabilities = capabilities,
      })

      lspconfig.marksman.setup({
        capabilities = capabilities,
      })

      lspconfig.html.setup({
        capabilities = capabilities,
        filetypes = {
          "html",
          "jinja",
          "htmldjango",
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
        },
      })

      lspconfig.cssls.setup({
        capabilities = capabilities,
        filetypes = {
          "css",
          "scss",
          "sass",
        },
      })

      lspconfig.emmet_ls.setup({
        capabilities = capabilities,
        filetypes = {
          "html",
          "htmldjango",
          "css",
          "jinja",
        },
      })
      -- lspconfig.jinja_lsp.setup({
      -- 	capabilities = capabilities,
      -- 	filetypes = {
      -- 		"jinja",
      -- 		"html.jinja",
      -- 		"htmldjango",
      -- 	},
      --   cmd = {
      --     "jinja-lsp",
      --   }
      -- })

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
