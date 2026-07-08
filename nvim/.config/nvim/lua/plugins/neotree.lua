return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		lazy = false, -- neo-tree will lazily load itself
		opts = {
			filesystem = {
				filtered_items = {
					visible = true,
				},
			},
		},
		config = function()
			require("neo-tree").setup({
				-- Your custom configurations here
			})
		end,
	},
}
