return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "gofmt" },
				python = { "black", "isort" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				-- yaml = { "yamlfix" },
				markdown = { "markdownlint" },
				rust = { "rustfmt" },
				bash = { "shfmt" },
				sh = { "shfmt" },
				bibtex = { "bibtex-tidy" },
				bib = { "bibtex-tidy" },
				tex = { "tex-fmt" },
				latex = { "tex-fmt" },
				["_"] = { "trim_whitespace" },
			},
			default_format_opts = {
				lsp_formsat = "fallback",
			},
			log_level = vim.log.levels.ERROR,
			-- Conform will notify you when a formatter errors
			notify_on_error = true,
			formatters = {
				["bibtex-tidy"] = {
					command = "bibtex-tidy",
					args = { "--merge", "--duplicates", "--escape", "--trailing-commas", "--encode-urls" },
				},
			},
		})
	end,
	-- format keybind on <leader>f
	-- lua require("conform").format()
	vim.keymap.set("n", "<leader>f", function()
		require("conform").format()
	end, { desc = "Format LaTeX" }),
}
