vim.opt.guicursor = ""

-- pdf
vim.g.vimtex_view_method = 'zathura'

-- shared clipboard (macos)
vim.opt.clipboard = "unnamedplus"

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

-- Disable swapfile and backup
vim.opt.swapfile = false
vim.opt.backup = false
-- Set up persistent undo history in a dedicated directory
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Disable highlight search and enable incremental search
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Enable true color support
vim.opt.termguicolors = true

-- Keep 8 lines visible above/below cursor while scrolling
vim.opt.scrolloff = 8
-- Always show the signcolumn (used for git signs, diagnostics etc)
vim.opt.signcolumn = "yes"
-- Allow @ in filenames
vim.opt.isfname:append("@-@")

-- Reduce update time for better user experience
-- time in milliseconds
-- default: 4000
vim.opt.updatetime = 750

-- Show a vertical line at column 80
vim.opt.colorcolumn = "80"
