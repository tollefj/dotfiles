-- Load core modules that are used across the configuration
local g = vim.g
local opt = vim.opt
local keymap = vim.keymap
local api = vim.api
local cmd = vim.cmd

-- Set leader keys
g.mapleader = " "
g.maplocalleader = ","

-- Set colorscheme
-- good ones: retrobox, slate, sorbet, darkblue
cmd.colorscheme("darkblue")
-- transparency if fancy
api.nvim_set_hl(0, "Normal", { bg = "none" })
api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

-- easy size increment/decrement vertical split with  keybinds <leader>> and <leader><
keymap.set("n", "<leader>0", "6<C-w>>", { desc = "Increase vertical split" })
keymap.set("n", "<leader>9", "6<C-w><", { desc = "Decrease vertical split" })

-- Sensible options
opt.ignorecase = true -- Ignore case when searching
opt.smartcase = true -- But not when searching with uppercase letters
opt.mouse = "a" -- Enable mouse support
opt.splitbelow = true -- Horizontal splits open below
opt.splitright = true -- Vertical splits open to the right
opt.clipboard = "unnamedplus" -- Use system clipboard
opt.nu = true -- Show line numbers
opt.relativenumber = true -- Show relative line numbers
opt.tabstop = 2 -- Tab width
opt.softtabstop = 2 -- Soft tab width
opt.shiftwidth = 2 -- Shift width
opt.expandtab = true -- Use spaces instead of tabs
opt.smartindent = true -- Smart indentation
opt.wrap = true -- Wrap lines
opt.swapfile = false -- Disable swapfile
opt.backup = false -- Disable backup
opt.undodir = os.getenv("HOME") .. "/.vim/undodir" -- Persistent undo
opt.undofile = true
opt.hlsearch = false -- Disable highlight search
opt.incsearch = true -- Enable incremental search
opt.termguicolors = true -- Enable true color support
opt.scrolloff = 5 -- Keep 10 lines visible above/below cursor
opt.sidescrolloff = 5
opt.isfname:append("@-@") -- Allow @ in filenames
opt.updatetime = 1000 -- Reduce update time
opt.signcolumn = "yes" -- Always show the signcolumn
opt.colorcolumn = "" -- Disable vertical line


-- cursorline as number:
opt.cursorline = true -- Enable cursor line
opt.cursorlineopt = "number" -- Show cursor line only on the number column
-- opt.guicursor = "" -- Set guicursor
-- opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr-o:hor20" -- Set cursor shape for different modes

-- Keymaps
local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	keymap.set(mode, lhs, rhs, options)
end

-- General keymaps
map("n", "<leader>w", function()
	vim.wo.wrap = not vim.wo.wrap
end, { desc = "Toggle wrap" })
map("n", "<leader>up", function()
	cmd("Lazy update")
end, { desc = "Update plugins" })
map("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle NeoTree" })
map("n", "<C-N>", "<cmd>Neotree toggle<CR>", { desc = "Toggle NeoTree" })
map("n", "<C-J>", "<C-W><C-J>", { desc = "Window down" })
map("n", "<C-K>", "<C-W><C-K>", { desc = "Window up" })
map("n", "<C-L>", "<C-W><C-L>", { desc = "Window right" })
map("n", "<C-H>", "<C-W><C-H>", { desc = "Window left" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })
map("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
map("n", "n", "nzzzv", { desc = "Next search result and center" })
map("n", "N", "Nzzzv", { desc = "Previous search result and center" })
map("n", "<leader>zig", "<cmd>LspRestart<cr>", { desc = "Restart LSP server" })
map("x", "<leader>p", [["_dP]], { desc = "Paste over selection without copying" })
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })
map("i", "<C-c>", "<Esc>", { desc = "Escape insert mode" })
map("n", "Q", "<nop>", { desc = "Disable Ex mode" })
map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "Tmux sessionizer" })
map("n", "<leader>f", function()
	require("conform").format({ bufnr = 0 })
end, { desc = "Format buffer" })
map("n", "<C-ø>", "<cmd>cnext<CR>zz", { desc = "Next quickfix item" })
map("n", "<C-æ>", "<cmd>cprev<CR>zz", { desc = "Previous quickfix item" })
map("n", "<leader>ø", "<cmd>lnext<CR>zz", { desc = "Next location list item" })
map("n", "<leader>æ", "<cmd>lprev<CR>zz", { desc = "Previous location list item" })
map(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Search and replace current word" }
)
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { desc = "Make current file executable" })
map("n", "<C-,>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<C-.>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>tn", ":tabnew<CR>", { desc = "New tab" })
map("n", "<leader>tx", ":tabclose<CR>", { desc = "Close tab" })
map("n", "<leader>b", "<cmd>Telescope bibtex<CR>", { desc = "Telescope BibTeX" })
map("n", "gd", vim.lsp.buf.definition, { desc = "LSP Go to Definition" })

-- Autocmds
local augroup = api.nvim_create_augroup("MyAutocmds", { clear = true })

-- Run shell script on <leader>r
api.nvim_create_autocmd("FileType", {
	pattern = "sh",
	group = augroup,
	callback = function()
		map("n", "<leader>r", function()
			local file = api.nvim_buf_get_name(0)
			cmd("!" .. file)
		end, { buffer = true, desc = "Run shell script" })
	end,
})

-- Return to last edit position when opening files
api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	callback = function()
		local mark = api.nvim_buf_get_mark(0, '"')
		local lcount = api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Custom functions
-- Open file in finder
map("n", "<leader>O", function()
	local file = vim.fn.expand("%:p")
	cmd("!" .. "open " .. file)
end, { desc = "Open file in finder" })

-- Copy full file path
map("n", "<leader>pa", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("file:", path)
end, { desc = "Copy full file path" })

-- Load plugins
require("config.lazy")
