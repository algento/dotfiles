-- <leader>:Space setting
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set("i", "<Space>", "<Space>", { noremap = true, silent = true })

--# Navigate vim panes better ---------------------------------------#
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

--# Copy and Save ---------------------------------------#
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")
vim.keymap.set("v", "<leader>y", '"*y')
-- vim.keymap.set("n", "<leader>cp", ':let @*=expand("%:p")<CR>')
vim.keymap.set("n", "<D-s>", "<Esc>:w<CR>")

--# LSP keymaps ---------------------------------------#
vim.keymap.set("n", "<leader>df", function()
  vim.diagnostic.open_float()
end, { desc = "Open [D]iagnostics in [F]loat" })

vim.keymap.set("n", "<leader>cf", function()
  require("conform").format({
    lsp_format = "fallback",
  })
end, { desc = "Format current file" })

-- vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Lsp hover" })
-- vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
-- vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
-- vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, {})
-- vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
-- vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
-- vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
