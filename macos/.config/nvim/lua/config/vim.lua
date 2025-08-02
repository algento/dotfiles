vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set backspace=indent,eol,start")

-- setting language options
vim.opt.langmenu = "en_US"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
-- vim.cmd("language en_US")

-- setting search option
vim.cmd("set ignorecase")
vim.cmd("set smartcase")

-- show relative line numbers
vim.wo.number = true
vim.opt.swapfile = false
vim.opt.relativenumber = true
-- vim.cmd("set relativenumber")
-- vim.cmd("set number")

-- vim g setup
vim.g.mapleader = " "
vim.g.background = "light"

-- Navigate vim panes better
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")
vim.keymap.set("v", "<leader>y", '"*y')
vim.keymap.set("n", "<leader>cp", ':let @*+=expand("%:p")<CR>')
vim.keymap.set("n", "<D-s>", "<Esc>:w<CR>")

vim.filetype.add({
  extension = {
    htmldjango = "jinja", -- 또는 "htmldjango" (둘 다 가능)
  },
  pattern = {
    ["%.html%.jinja2?"] = "jinja",
    ["%.html%.j2"] = "jinja",
  },
})
