return {
	"folke/tokyonight.nvim",
	priority = 1000,
	config = function()
		require("tokyonight").setup({
			style = "storm",
		})

		local function update_theme()
			if vim.o.background == "light" then
				vim.cmd.colorscheme("tokyonight-day")
			else
				vim.cmd.colorscheme("tokyonight-storm")
			end
		end

		vim.api.nvim_create_autocmd("OptionSet", {
			pattern = "background",
			callback = update_theme,
		})

		update_theme()
	end,
}
