-- # setting leader key-----------------------------------------------#
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- # setting tap ----------------------------------------------------#
vim.opt.expandtab = true -- convert tabs to space
vim.opt.shiftwidth = 2 -- amount to indent width
vim.opt.tabstop = 2 -- how many spaces are shown per Tab
vim.opt.softtabstop = 2 -- hhow many spaces are applied when pressing tab
vim.opt.smarttab = true
vim.opt.termguicolors = true

-- # reduce delasy and timeout ----------------------------------------------------#
vim.opt.iminsert = 0
vim.opt.imsearch = 0
vim.o.timeout = true
vim.o.timeoutlen = 400 -- 기본 1000ms
vim.o.ttimeout = true -- 키코딩 딜레이
vim.o.ttimeoutlen = 10

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
vim.opt.listchars = { lead = "·", trail = "·", nbsp = "␣" }

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 5

-- allow backspace on indent, end of line or insert mode start position
vim.opt.backspace = "indent,eol,start"

-- turn off swapfile
vim.opt.swapfile = false
vim.opt.autochdir = false

-- Neovim 0.12 내장 ui2 (메시지 및 명령줄 팝업) 활성화
-- Neovim 0.12 ui2의 Treesitter 버그(Invalid node type 'tab' 등)로 인해 임시 비활성화합니다.
-- pcall(function()
--   require('vim._core.ui2').enable({})
-- end)


