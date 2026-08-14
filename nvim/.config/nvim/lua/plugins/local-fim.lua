-- Local FIM completion (Qwen3.5-4B via llama-server). Published standalone at
-- https://github.com/tollefj/local-fim.nvim; lazy clones it and puts its lua/ on
-- runtimepath so require("local-fim") and :checkhealth local-fim resolve. Loaded
-- on VimEnter so it can offer to start the llama-server when you open nvim
-- without it running.
return {
	"tollefj/local-fim.nvim",
	event = "VimEnter",
	opts = {
		endpoint = "http://127.0.0.1:8012",
		profile = "qwen3.5-4b",
		-- The plugin ships no built-in profiles (lua/local-fim/profiles.lua is
		-- just the mechanics) -- these are the full model configs, mirrored in
		-- the plugin repo's README/tests/fim/profiles.lua, with model_dir
		-- pointed at this machine's actual ~/LLM/models/<Name>/ layout
		-- (profiles.lua's default model_dir assumes a flat ~/LLM instead).
		profiles = {
			-- Qwen2.5-Coder 3B, infill mode (llama-server assembles the prompt
			-- from the GGUF's own FIM metadata).
			["qwen2.5-coder"] = {
				mode = "infill",
				top_p = 0.9,
				stop = { "<|endoftext|>", "<|fim_pad|>", "<|file_sep|>", "<|repo_name|>" },
				server = {
					hf = "ggml-org/Qwen2.5-Coder-3B-Q8_0-GGUF",
					gguf = "qwen2.5-coder-3b-q8_0.gguf",
					source = "local",
					model_dir = "~/LLM/models/Qwen2.5-coder-FIM",
					ctx = 8192,
				},
			},
			-- Qwen3.5-4B, same Qwen FIM tokenizer family (infill mode). Local-only
			-- GGUF (no known hf repo). Its own eos is "<|im_end|>" rather than a
			-- FIM-family token, and it loops on already-emitted lines under
			-- greedy decoding without DRY sampling to break the cycle -- the
			-- default dry_sequence_breakers ("\n", ":", "\"", "*") reset the
			-- match mid-line for code like `print("done")`, so it's narrowed to
			-- just newline here.
			["qwen3.5-4b"] = {
				mode = "infill",
				top_p = 0.9,
				stop = { "<|endoftext|>", "<|fim_pad|>", "<|file_sep|>", "<|repo_name|>", "<|im_end|>" },
				dry_multiplier = 0.8,
				dry_allowed_length = 1,
				dry_penalty_last_n = 256,
				dry_sequence_breakers = { "\n" },
				server = {
					gguf = "Qwen3.5-4B-Q6_K.gguf",
					source = "local",
					model_dir = "~/LLM/models/Qwen3.5-4B-FIM",
					ctx = 8192,
				},
			},
		},
	},
	config = function(_, opts)
		local fim = require("local-fim")
		fim.setup(opts)
		require("local-fim.server").ensure(fim.config)
	end,
}
