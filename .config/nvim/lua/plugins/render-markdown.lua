return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	ft = { "markdown" },
	keys = {
		{ "<leader>m", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle markdown render" },
	},
	opts = {},
}
