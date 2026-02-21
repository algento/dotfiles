return {
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
      { "williamboman/mason.nvim", opts = {} },
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

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp, this function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          -- map("gd", require("fzf-lua").lsp_definitions, "[G]oto [D]efinition")
          map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")

          -- Find references for the word under your cursor.
          map("gr", require("fzf-lua").lsp_references, "[G]oto [R]eferences")

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map("gI", require("fzf-lua").lsp_implementations, "[G]oto [I]mplementation")

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map("<leader>D", require("fzf-lua").lsp_typedefs, "Type [D]efinition")

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map("<leader>ds", require("fzf-lua").lsp_document_symbols, "[D]ocument [S]ymbols")

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map("<leader>ws", require("fzf-lua").lsp_live_workspace_symbols, "[W]orkspace [S]ymbols")

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map("<leader>cr", vim.lsp.buf.rename, "[R]e[n]ame")

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "[T]oggle Inlay [H]ints")
          end

          if client and client.name == "ruff" then -- ruff code action 추가
            -- Notes on code actions: https://github.com/astral-sh/ruff-lsp/issues/119#issuecomment-1595628355
            -- Get isort like behavior: https://github.com/astral-sh/ruff/issues/8926#issuecomment-1834048218
            -- 기존 'commands' 테이블 역할을 하는 유저 커맨드 등록
            vim.api.nvim_buf_create_user_command(event.buf, "RuffAutofix", function()
              vim.lsp.buf.code_action({
                context = { only = { "source.fixAll.ruff" } },
                apply = true,
              })
            end, { desc = "Ruff: Fix all auto-fixable problems" })

            vim.api.nvim_buf_create_user_command(event.buf, "RuffOrganizeImports", function()
              vim.lsp.buf.code_action({
                context = { only = { "source.organizeImports.ruff" } },
                apply = true,
              })
            end, { desc = "Ruff: Format imports" })

            -- Hover 중복 방지 (Pyright 등과 병행 시)
            client.server_capabilities.hoverProvider = false
          end
          -- Clangd 전용 키맵
          if client and client.name == "clangd" then
            map("<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", "Switch Source/Header")
          end
        end,
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

      -- show diagnostics message on screen
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config({
        severity_sort = true,
        underline = {
          severity = vim.diagnostic.severity.ERROR,
        },
        -- update_in_insert = false,
        virtual_text = {
          source = "always", -- "if_many"
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
          source = "always",
          -- show_header = true,
          -- focus = false,
          -- width = 60,
        },
      })
    end,
  },
}
