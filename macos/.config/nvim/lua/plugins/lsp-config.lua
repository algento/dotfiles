return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua_ls",
        "clangd",
        "codelldb",
        "debugpy",
        "mypy",
        "ruff",
        "prettierd",
        "basedpyright",
        "cmakelang",
        "cmakelint",
        "neocmake",
        "marksman",
        "markdownlint-cli2",
      },
    },
    config = function(_, opts)
      require("mason").setup({ opts = opts })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      auto_install = true,
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "clangd",
          "basedpyright",
          "neocmake",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        cmp_nvim_lsp.default_capabilities()
      )
      local lspconfig = require("lspconfig")
      local util = require("lspconfig.util")

      --vim.lsp.config["lua_ls"] = {
      --	capabilities = capabilities,
      --}
      --vim.lsp.enable("lua_ls")

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
      })

      lspconfig.basedpyright.setup({
        capabilities = capabilities,
        settings = {
          basedpyright = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
            -- disableLanguageServices = false,
            analysis = {
              -- ignore = { "*" }, -- Ignore all files for analysis to exclusively use Ruff for linting
              -- typeCheckingMode = 'off',
              -- diagnosticMode = 'openFilesOnly', -- Only analyze open files
              -- useLibraryCodeForTypes = true,
              -- autoImportCompletions = true,     -- whether pyright offers auto-import completions
            },
          },
          python = {
            analysis = {},
          },
        },
      })

      lspconfig.ruff.setup({
        capabilities = capabilities,
        cmd_env = { RUFF_TRACE = "messages" },
        init_options = {
          settings = {
            logLevel = "error",
            args = {
              -- ruff args
            },
          },
        },
        -- ruff code action 추가
        commands = {
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
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
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

      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
      vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
      vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, {})
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
