vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set backspace=indent,eol,start")
vim.opt.langmenu = "en_US"
vim.cmd("language en_US")

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

-- show diagnostics message on screen
vim.diagnostic.config({
  underline = false,
  virtual_text = {
    spacing = 2,
    prefix = "●",
  },
  update_in_insert = false,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = " ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
  float = {
    show_header = true,
    source = true,
    focus = false,
    width = 60,
  },
})
