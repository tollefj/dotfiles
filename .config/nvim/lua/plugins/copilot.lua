return {
	{
		"github/copilot.vim",
		enabled = false,
		lazy = false,
		config = function()
			vim.g.copilot_no_tab_map = true
			vim.g.copilot_assume_mapped = false

			vim.keymap.set("i", "<C-y>", 'copilot#Accept("\\<CR>")', {
				expr = true,
				replace_keycodes = false,
				silent = true,
			})
			vim.keymap.set("i", "<C-K>", "copilot#Dismiss()", { expr = true, silent = true })
		end,
	},
}
