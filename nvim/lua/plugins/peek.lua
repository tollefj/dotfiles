return {
	{
		"toppair/peek.nvim",
		event = { "VeryLazy" },
		build = "deno task --quiet build:fast",
		config = function()
			require("peek").setup({
				filetype = { "markdown", "conf" },
				auto_load = true, -- whether to automatically load preview when
				-- entering another markdown buffer
				close_on_bdelete = true, -- close preview window on buffer delete

				syntax = true, -- enable syntax highlighting, affects performance

				theme = "dark", -- 'dark' or 'light'

				update_on_change = true,

                -- call original browser inside WSL
                -- path: /mnt/c/Program Files/BraveSoftware/Brave-Browser/Application/brave.exe
				app = {
                    "/mnt/c/Program Files/BraveSoftware/Brave-Browser/Application/brave.exe", "--new-window"
                }, -- 'webview', 'browser', string or a table of strings
				-- explained below

				filetype = { "markdown" }, -- list of filetypes to recognize as markdown

				-- relevant if update_on_change is true
				throttle_at = 200000, -- start throttling when file exceeds this
				-- amount of bytes in size
				throttle_time = "auto", -- minimum amount of time in milliseconds
			})
			vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
			vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
		end,
	},
	-- set keybinds to open and close markdown
	vim.keymap.set("n", "<leader>m", function()
		require("peek").open()
	end, { desc = "Peek Open" }),
	vim.keymap.set("n", "<leader>c", function()
		require("peek").close()
	end, { desc = "Peek Close" }),
}
