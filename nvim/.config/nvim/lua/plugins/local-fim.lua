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
		profile = "qwen2.5-coder",
		profiles = {
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
		},
	},
	config = function(_, opts)
		local fim = require("local-fim")
		fim.setup(opts)
		require("local-fim.server").ensure(fim.config)
	end,
}
