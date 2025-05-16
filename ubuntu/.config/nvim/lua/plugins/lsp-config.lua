return {
  {
    "williamboman/mason.nvim",
    lazy = true,
    opts = {
      ensure_installed = {
        "clangd",
        "codelldb",
        "debugpy",
        "mypy",
        "ruff",
        "prettier",
        "pyright",
      },
    },
    config = function(_, opts)
      require("mason").setup({ opts = opts })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
    opts = {
      auto_install = true,
    },
    config = function(_, opts)
      require("mason-lspconfig").setup({
        opts = opts
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    lazy = true,
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")
      local util = require("lspconfig.util")

      --vim.lsp.config["lua_ls"] = {
      --	capabilities = capabilities,
      --}
      --vim.lsp.enable("lua_ls")

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
      })

      lspconfig.pyright.setup({
        capabilities = capabilities,
        settings = {
          pyright = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
          },
          python = {
            analysis = {
              --[[Ignore all files for analysis to exclusively use Ruff
			            for linting--]]
              ignore = { "*" },
            },
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

      lspconfig.cmake.setup({
        capabilities = capabilities,
      })

      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
      vim.keymap.set({ "n" }, "<leader>ca", vim.lsp.buf.code_action, {})
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
