--
--    Neovim editor - simple no plugin configuration
--    For full documentation and other stuff visit https://neovim.io/
--


vim.api.nvim_command('filetype plugin indent on')
vim.opt.termguicolors = false
vim.opt.background = 'dark'

pcall(vim.cmd, 'syntax on')
pcall(vim.cmd, 'colorscheme pablo')

vim.opt.hidden = true
vim.opt.timeoutlen = 2000
vim.opt.updatetime = 2000
vim.opt.scrolloff = 8
vim.opt.number = true
vim.opt.numberwidth = 2
vim.opt.relativenumber = true
vim.opt.signcolumn = 'no'
vim.opt.cursorline = false
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.cindent = true
vim.opt.autoindent = true
vim.opt.wrap = false
vim.opt.textwidth = 200
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 0
vim.opt.list = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.mouse = "a"
vim.opt.laststatus = 0
vim.opt.showtabline = 0

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = '/tmp/'
vim.opt.history = 50

vim.g.mapleader = '<space>'
vim.g.maplocalleader = ','
