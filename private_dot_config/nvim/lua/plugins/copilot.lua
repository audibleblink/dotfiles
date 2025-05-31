return {
	{
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
				-- enabled = true,
				auto_trigger = true,
			},
			auth_provider_url = nil, -- URL to authentication provider, if not "https://github.com/"
			workspace_folders = {},
		},
		{
			"CopilotC-Nvim/CopilotChat.nvim",
			lazy = true,
			cmd = "CopilotChatToggle",
			build = "make tiktoken", -- Only on MacOS or Linux
			opts = {
				-- See Configuration section for options
			},
			-- See Commands section for default commands if you want to lazy load on them
		},
	},
}
