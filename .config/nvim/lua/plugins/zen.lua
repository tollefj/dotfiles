return {
	"folke/zen-mode.nvim",
	config = function()
		vim.keymap.set("n", "<leader>zz", function()
			require("zen-mode").setup({ window = { width = 100 } })
			require("zen-mode").toggle()
			vim.wo.number = true
			vim.wo.rnu = true
      vim.opt.signcolumn = "yes" -- Always show the signcolumn
		end)

		vim.keymap.set("n", "<leader>zZ", function()
			require("zen-mode").setup({ window = { width = 80, height = 40 } })
			require("zen-mode").toggle()
			vim.wo.number = false
			vim.wo.rnu = false
      vim.opt.signcolumn = "no" -- Always show the signcolumn
		end)
	end,
	opts = {
		window = {
			backdrop = 1, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
			-- height and width can be:
			-- * an absolute number of cells when > 1
			-- * a percentage of the width / height of the editor when <= 1
			-- * a function that returns the width or the height
			-- by default, no options are changed for the Zen window
			-- uncomment any of the options below, or add other vim.wo options you want to apply
			options = {
				signcolumn = "no", -- disable signcolumn
				number = false, -- disable number column
				relativenumber = false, -- disable relative numbers
				cursorline = false, -- disable cursorline
				cursorcolumn = false, -- disable cursor column
				foldcolumn = "0", -- disable fold column
				list = false, -- disable whitespace characters
			},
		},
		plugins = {
			-- disable some global vim options (vim.o...)
			-- comment the lines to not apply the options
			options = {
				enabled = true,
				ruler = false, -- disables the ruler text in the cmd line area
				showcmd = false, -- disables the command in the last line of the screen
				-- you may turn on/off statusline in zen mode by setting 'laststatus'
				-- statusline will be shown only if 'laststatus' == 3
				laststatus = 0, -- turn off the statusline in zen mode
			},
			gitsigns = { enabled = false }, -- disables git signs
			tmux = { enabled = false }, -- disables the tmux statusline
			todo = { enabled = true }, -- if set to "true", todo-comments.nvim highlights will be disabled
		},
	},
}
