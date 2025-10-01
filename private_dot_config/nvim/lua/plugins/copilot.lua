return {
	"zbirenbaum/copilot.lua",
	lazy = true,
	cmd = "Copilot",
	dependencies = {
		{
			"zbirenbaum/copilot-cmp",
			config = function()
				require("copilot_cmp").setup()
			end,
		},
	},
	opts = {
		copilot_model = "claude-sonnet-4",
		panel = { enabled = false },
		suggestion = {
			enabled = false,
			trigger_on_accept = false,
			keymap = {
				accept = "<C-l>",
				dismiss = "<C-e>",
			},
		},
	},
}
