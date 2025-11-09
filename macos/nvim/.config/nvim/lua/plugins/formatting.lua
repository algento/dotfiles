return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      notify_on_error = true,
      formatters_by_ft = {
        -- Conform will run multiple formatters sequentially
        -- python = { "isort", "black" },
        -- You can customize some of the format options for the filetype (:help conform.format)
        -- rust = { "rustfmt", lsp_format = "fallback" },
        -- Conform will run the first available formatter
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
        -- You can customize some of the format options for the filetype (:help conform.format)

        lua = { "stylua" },
        -- Web
        html = { "prettierd", "djlint" },
        htmldjango = { "djlint" },
        jinja = { "djlint" },
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        css = { "prettierd" },

        -- Markup
        yaml = { "prettierd" },
        json = { "prettierd" },

        -- Markdown
        -- markdown = { "prettierd", "markdownlint-cli2", "markdown-toc" },
        markdown = { "prettierd" },

        -- C/C++
        c = { "clang-format" },
        cpp = { "clang-format" },
        cmake = { "cmake_format" },
        -- Python
        python = { "ruff_format", "ruff_organize_imports", "ruff_fix" },
        -- Rust
        rust = { "rustfmt" },
      },
      formatters = {
        djlint = { prepend_args = { "--profile=jinja" } },
        -- cmake_format = { args = { "--space=4" } },
      },
      format_on_save = {
        -- These options will be passed to conform.format()
        -- async = false,
        timeout_ms = 500,
        lsp_format = "fallback",
      },
      keys = {
        {
          "<leader>cf",
          function()
            require("conform").format({ async = false, timeout_ms = 500, lsp_format = "fallback" })
          end,
          mode = "",
          desc = "[C]ode [F]ormat",
        },
      },
    },
  },
}
