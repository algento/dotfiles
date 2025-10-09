return {
  "mfussenegger/nvim-lint",
  event = {
    "BufReadPre",
    "BufNewFile",
  },
  opts = {
    linters_by_ft = {
      text = { "vale" },
      python = { "ruff", "mypy" },
      cpp = { "clang-tidy", "cpplint" },
      cmake = { "cmakelint" },
      html = { "djlint" },
      htmldjango = { "djlint" },
      css = {},
      markdown = { "markdownlint-cli2" },
      json = {},
      yaml = {},
    },
  },
  config = function()
    local lint = require("lint")
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    -- vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })
    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}
