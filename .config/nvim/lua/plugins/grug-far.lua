return {
	"MagicDuck/grug-far.nvim",
	cmd = "GrugFar",
	opts = {
		keymaps = {
			replace = { n = "<leader>s" },
		},
	},
	keys = {
		{
			"<leader>sr",
			function()
				require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
			end,
			mode = "n",
			desc = "Search and replace (project)",
		},
		{
			"<leader>sr",
			function()
				require("grug-far").with_visual_selection()
			end,
			mode = "x",
			desc = "Search and replace (selection)",
		},
	},
}
