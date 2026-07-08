return {
	{
		"lervag/vimtex",
		lazy = false, -- vimtex is a core plugin, load it on startup
		config = function()
			vim.g.vimtex_view_method = "zathura" -- (e.g., 'skim', 'sumatrapdf', 'okular')
			-- vim.g.vimtex_quickfix_mode = 0 -- Optional: Configure how errors are shown (0: separate buffer, 1: quickfix)
			-- Add other vimtex configurations here as needed
		end,
	},
}
