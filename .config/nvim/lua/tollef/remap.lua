-- Set the leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = ","


vim.keymap.set('n', '<leader>w', function()
  vim.wo.wrap = not vim.wo.wrap
end)

-- run .sh files with <leader>r
vim.api.nvim_create_autocmd("FileType", {
  pattern = "sh",
  callback = function()
    vim.keymap.set("n", "<leader>r", function()
      local file = vim.fn.expand("%:p")
      vim.cmd("!" .. file)
    end, { buffer = true, desc = "Run shell script" })
  end,
})

-- <leader>o to open file in finder
vim.keymap.set("n", "<leader>O", function()
  local file = vim.fn.expand("%:p")
  vim.cmd("!" .. "open " .. file)
end, { desc = "Open file in finder" })

-- <leader>up to update plugins
vim.keymap.set("n", "<leader>up", function()
  vim.cmd("Lazy update")
end, { desc = "Update plugins" })


-- plugin-specific keymaps
-- ### NeoTree
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>")
vim.keymap.set("n", "<C-N>", "<cmd>Neotree toggle<CR>")

-- Window navigation mappings
vim.keymap.set("n", "<C-J>", "<C-W><C-J>")
vim.keymap.set("n", "<C-K>", "<C-W><C-K>")
vim.keymap.set("n", "<C-J>", "<C-W><C-L>")
vim.keymap.set("n", "<C-H>", "<C-W><C-H>")

-- Move selected lines up and down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Run Plenary test file
vim.api.nvim_set_keymap("n", "<leader>tf", "<Plug>PlenaryTestFile", { noremap = false, silent = false })

-- J-> Join lines and maintain cursor position
vim.keymap.set("n", "J", "mzJ`z")
-- Keep cursor in the middle when scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Keep search results centered
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")  -- Restart LSP server

-- Paste over selection without copying the replaced text
vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]]) 
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Delete without yanking
vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d")

-- Map Ctrl-c to Escape in insert mode
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Disable Ex mode and set up tmux integration
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Format current buffer
vim.keymap.set("n", "<leader>f", function()
    require("conform").format({ bufnr = 0 })
end)

-- Quickfix and location list navigation
vim.keymap.set("n", "<C-ø>", "<cmd>cnext<CR>zz")  -- Next item in quickfix list
vim.keymap.set("n", "<C-æ>", "<cmd>cprev<CR>zz") -- Previous item in quickfix list
vim.keymap.set("n", "<leader>ø", "<cmd>lnext<CR>zz") -- Next item in location list
vim.keymap.set("n", "<leader>æ", "<cmd>lprev<CR>zz") -- Previous item in location list

-- Search and replace current word
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]) -- usage: highlight word and press <leader>s and then enter replacement

-- Make current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Source current file
-- vim.keymap.set("n", "<leader><leader>", function()
--     vim.cmd("so")
-- end)
