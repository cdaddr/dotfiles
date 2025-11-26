return {
	"milanglacier/minuet-ai.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		provider = "openai_fim_compatible",
		n_completions = 1,
		context_window = 2048,
		throttle = 500,
		virtualtext = {
			auto_trigger_ft = {
				"python",
				"lua",
				"javascript",
				"typescript",
        "svelte",
				"go",
				"rust",
				"c",
				"cpp",
				"java",
				"ruby",
				"sh",
			},
			keymap = {
				accept_line = "<D-l>",
        accept = "<C-'>",
				next = "<C-.>",
				prev = "<C-,>",
				dismiss = "<C-e>",
			},
		},
		provider_options = {
			openai_fim_compatible = {
				api_key = function()
					return "ollama"
				end,
				name = "Ollama",
				end_point = "http://localhost:11434/v1/completions",
				model = "qwen2.5-coder:1.5b",
				optional = {
					max_tokens = 128,
					temperature = 0.2,
					top_p = 0.9,
				},
			},
		},
	},
}
