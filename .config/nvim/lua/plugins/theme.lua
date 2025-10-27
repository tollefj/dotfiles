return {
	"sainnhe/everforest",
	priority = 1000,
	config = function()
		vim.g.everforest_background = "hard"
		vim.g.everforest_better_performance = 1
		vim.g.everforest_enable_italic = 0

		local function update_theme()
			if vim.o.background == "light" then
				vim.o.background = "light"
			else
				vim.o.background = "dark"
			end
			vim.cmd.colorscheme("everforest")
		end

		vim.api.nvim_create_autocmd("OptionSet", {
			pattern = "background",
			callback = update_theme,
		})

		update_theme()
	end,
}
