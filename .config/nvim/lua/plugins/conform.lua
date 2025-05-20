return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "gofmt" },
				python = { "black", "isort" },
				javascript = { "deno_fmt" },
				typescript = { "deno_fmt" },
				javascriptreact = { "deno_fmt" },
				typescriptreact = { "deno_fmt" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "deno_fmt" },
				-- yaml = { "yamlfix" },
				markdown = { "deno_fmt" },
				rust = { "rustfmt" },
				bash = { "shfmt" },
				sh = { "shfmt" },
                bibtex = { "bibtex-tidy" },
                bib = { "bibtex-tidy" },
                tex = { "latexindent" },
                latex = { "latexindent" },
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
