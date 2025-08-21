return {
	{
		"github/copilot.vim",
		lazy = false,
		config = function()
			vim.g.copilot_no_tab_map = false
			vim.g.copilot_assume_mapped = false

			-- vim.keymap.set("i", "<C-w>", 'copilot#Accept("<CR>")', { expr = true, silent = true })
			vim.keymap.set("i", "<C-K>", "copilot#Dismiss()", { expr = true, silent = true })
		end,
	},
}
