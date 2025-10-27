return {
	"stevearc/conform.nvim",
	-- Trigger loading on events or commands
	event = { "BufReadPre", "BufNewFile" },
	cmd = { "ConformInfo" },

	keys = {
		{
			-- Your original keymap for formatting the whole buffer, now in Normal mode.
			-- The description is updated for clarity.
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_fallback = "fallback" })
			end,
			mode = "n",
			desc = "Format Buffer",
		},
		{
			-- New keymap for formatting a selection with a specific formatter.
			-- This works in Visual mode.
			"<leader>ff",
			function()
				require("conform").format({
					formatters = { "latexindent" },
				})
			end,
			mode = "v",
			desc = "Format Selection as LaTeX",
		},
	},

	-- The 'opts' table is a cleaner way to pass your setup to conform.
	-- lazy.nvim will automatically call require("conform").setup(opts)
	opts = {
		notify_on_error = true,
		log_level = vim.log.levels.ERROR,

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
			markdown = { "markdownlint" },
			rust = { "rustfmt" },
			bash = { "shfmt" },
			sh = { "shfmt" },
			bibtex = { "bibtex-tidy" },
			bib = { "bibtex-tidy" },
			tex = { "latexindent" },
			latex = { "latexindent" },
			["_"] = { "trim_whitespace" },
		},

		formatters = {
			["bibtex-tidy"] = {
				command = "bibtex-tidy",
				args = { "--merge", "--duplicates", "--escape", "--trailing-commas", "--encode-urls" },
			},
		},
	},
}
