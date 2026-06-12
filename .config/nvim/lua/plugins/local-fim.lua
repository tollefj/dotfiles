-- Local FIM completion (Mellum via llama-server). Published standalone at
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
	},
	config = function(_, opts)
		local fim = require("local-fim")
		fim.setup(opts)
		require("local-fim.server").ensure(fim.config)
	end,
}
