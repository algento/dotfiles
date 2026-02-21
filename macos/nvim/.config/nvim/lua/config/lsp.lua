local keymap = vim.keymap

--  This function gets run when an LSP attaches to a particular buffer.
--    That is to say, every time a new file is opened that is associated with
--    an lsp, this function will be executed to configure the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("sejong-lsp-attach", { clear = true }),

  callback = function(event)
    -- NOTE: Create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    -- NOTE: To jump back, press <C-t>.
    map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    -- map("gd", require("fzf-lua").lsp_definitions, "[G]oto [D]efinition")

    -- WARN: this is Goto Declaration. For example, in C this would take you to the header.
    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

    -- NOTE: the definition of its *type*, not where it was *defined*.
    map("<leader>D", require("fzf-lua").lsp_typedefs, "Type [D]efinition")

    -- NOTE: Fuzzy find all the symbols in your current document.
    map("<leader>ds", require("fzf-lua").lsp_document_symbols, "[D]ocument [S]ymbols")

    -- NOTE: Fuzzy find all the symbols in your current workspace.
    map("<leader>ws", require("fzf-lua").lsp_live_workspace_symbols, "[W]orkspace [S]ymbols")

    map("gr", require("fzf-lua").lsp_references, "[G]oto [R]eferences")
    map("gI", require("fzf-lua").lsp_implementations, "[G]oto [I]mplementation")
    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

    map("<leader>sD", require("fzf-lua").diagnostics_document, "[S]how document [D]iagnostic")
    map("<leader>sd", vim.diagnostic.open_float, "[S]how line [D]iagnostics")

    map("[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, "Go to previous diagnostics")

    map("]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, "Go to next diagnostics")

    map("K", vim.lsp.buf.hover, "Show document under cursor")

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup("sejong-lsp-highlight", { clear = false })
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
        group = vim.api.nvim_create_augroup("sejong-lsp-detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = "sejong-lsp-highlight", buffer = event2.buf })
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
      map("<leader>ch", "<cmd>LspClangdSwitchSourceHeader<cr>", "Switch Source/Header")
    end
  end,
})

-- vim.lsp.inlay_hint.enable(true)

-- show diagnostics message on screen, See :help vim.diagnostic.Opts
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
