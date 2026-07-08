local toggle_key = '<C-/>'
return {
	{
		"coder/claudecode.nvim",
		dependencies = { "folke/snacks.nvim" },
		keys = {
			{ "<leader>a", nil, desc = "Claude Code" },
			{ "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
			{ toggle_key, "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude", mode = { "n", "x" } },
			{ "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
			{ "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
			{ "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
			{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
			{ "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
			{
				"<leader>as",
				"<cmd>ClaudeCodeTreeAdd<cr>",
				desc = "Add file",
				ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
			},
			-- Diff management
			{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
			{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
		},
		opts = {
			port_range = { min = 10000, max = 65535 },
			auto_start = true,
			log_level = "info", -- "trace", "debug", "info", "warn", "error"
			terminal_cmd = nil, -- Custom terminal command (default: "claude")
			-- For local installations: "~/.claude/local/claude"
			-- For native binary: use output from 'which claude'

			-- Send/Focus Behavior
			-- When true, successful sends will focus the Claude terminal if already connected
			focus_after_send = false,

			-- Selection Tracking
			track_selection = true,
			visual_demotion_delay_ms = 50,

			-- Terminal Configuration
			terminal = {
				---@module "snacks"
				---@type snacks.win.Config|{}
				snacks_win_opts = {
					position = "float",
					width = 0.9,
					height = 0.9,
					keys = {
						claude_hide = {
							toggle_key,
							function(self)
								self:hide()
							end,
							mode = "t",
							desc = "Hide",
						},
					},
				},
			},
			-- Diff Integration
			diff_opts = {
				auto_close_on_accept = true,
				vertical_split = true,
				open_in_current_tab = true,
				keep_terminal_focus = false, -- If true, moves focus back to terminal after diff opens
			},
		},
	},
}
