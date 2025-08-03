-- # setting tap ----------------------------------------------------#
vim.opt.expandtab = true -- convert tabs to space
vim.opt.shiftwidth = 2 -- amount to indent width
vim.opt.tabstop = 2 -- how many spaces are shown per Tab
vim.opt.softtabstop = 2 -- hhow many spaces are applied when pressing tab
vim.opt.smarttab = true

-- # setting indent ----------------------------------------------------#
vim.opt.smartindent = true
vim.opt.autoindent = true -- allow backspace on indent, end of line or insert mode start position
vim.opt.breakindent = true -- Enable break indent

-- # setting editor ----------------------------------------------------#
-- Always show relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Show line under cursor
vim.opt.cursorline = true

-- Store undos between sessions
vim.opt.undofile = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { trail = "·", nbsp = "␣" }

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 5

-- allow backspace on indent, end of line or insert mode start position
vim.opt.backspace = "indent,eol,start"

-- turn off swapfile
vim.opt.swapfile = false

vim.opt.autochdir = false

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

--[[ 
vim.filetype.add({
  extension = {
    htmldjango = "jinja", -- 또는 "htmldjango" (둘 다 가능)
  },
  pattern = {
    ["%.html%.jinja2?"] = "jinja",
    ["%.html%.j2"] = "jinja",
  },
}) ]]
