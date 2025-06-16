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
				enabled = true,
				auto_trigger = false,
				hide_during_completion = true,
				debounce = 75,
				trigger_on_accept = true,
				keymap = {
					accept = "<C-l>",
					accept_word = false,
					accept_line = false,
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
			},
			auth_provider_url = nil, -- URL to authentication provider, if not "https://github.com/"
			workspace_folders = {},
		},
	},

	{
		"CopilotC-Nvim/CopilotChat.nvim",
		lazy = true,
		keys = {
			{ "<Leader>cc", ":CopilotChatToggle<CR>", desc = "Toggle CopilotChat" },
			{ "<Leader>cp", ":CopilotChatPrompts<CR>", desc = "Toggle CopilotChat Prompts" },
		},
		cmd = "CopilotChatToggle",
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			prompts = {
				Commit = {
					prompt = "Write a commit message for these changes. Keep the title under 80 characters. Everything but the title should be indented by 2 spaces and wrapped at 80 characters. ",
					system_prompt = "you only reply with descriptive commitizen-compliant commit messages as a code block",
					description = "Create a detailed commit message",
					context = "git:staged",
				},
			},
		},
	},
}
