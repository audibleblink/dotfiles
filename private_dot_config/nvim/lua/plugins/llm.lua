return {
	{
		"julwrites/llm-nvim",
		cmd = "LLMToggle",
		keys = { { "<Leader>ai", "<cmd>LLMToggle<CR>", desc = "Toggle LLM AI" } },
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			model = "anthropic/claude-sonnet-4-0",
			system_prompt = "You are a helpful Neovim assistant.",
		},
		config = function(_, opts)
			local llm = require("llm")
			llm.setup(opts)

			vim.keymap.set("v", "<leader>lss", llm.prompt_with_selection, { desc = "LLM Selection" })
		end,
	},
}
