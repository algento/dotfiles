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

--# Snacks.nvim 모듈용 단축키 설정
vim.keymap.set("n", "<leader>ft", function()
  Snacks.terminal.toggle()
end, { desc = "Toggle Float Terminal" })

vim.keymap.set("n", "<leader>sf", function()
  Snacks.scratch()
end, { desc = "Toggle Scratch Pad" })

vim.keymap.set("n", "<leader>S", function()
  Snacks.scratch.select()
end, { desc = "Select Scratch Pad" })


