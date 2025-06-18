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
				enabled = false,
				trigger_on_accept = false,
				keymap = {
					accept = "<C-l>",
					dismiss = "<C-e>",
				},
			},
		},
	},

	{
		"CopilotC-Nvim/CopilotChat.nvim",
		lazy = true,
		keys = {
			{ "<Leader>cc", ":CopilotChatToggle<CR>", desc = "Toggle CopilotChat" },
			{ "<Leader>cp", ":CopilotChatPrompts<CR>", desc = "Toggle CopilotChat Prompts" },
			{ "<Leader>ce", mode = { "n", "x" }, ":CopilotChatExplain<CR>", desc = "Show Explanation" },
			{ "<Leader>co", mode = { "x" }, ":CopilotChatCommit<CR>", desc = "Show commit message pane" },
			{ "<Leader>cf", mode = { "x" }, ":CopilotChatFix<CR>", desc = "Fix Selected" },
		},
		cmd = "CopilotChatToggle",
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			question_header = "󱍄 me", -- Header to use for user questions
			answer_header = "  copilot",
			separator = "━━━━━━━━━━━━━━━━━━━━━━━━━━━",
			window = {
				-- layout = "float",
				-- width = 0.7,
				width = 0.4,
				relative = "editor",
				title = "Copilot",
				footer = "q to close chat | <C-e> for new chat",
				height = 0.6,
				row = 0,
				border = "rounded", -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
			},

			mappings = {
				complete = {
					insert = "<C-l>",
				},
				reset = {
					normal = "<C-e>",
					insert = "<C-e>",
				},
			},
			prompts = {
				Commit = {
					prompt = [[ 
					  Write a commit message for these changes. 
					  Keep the title under 72 characters. 
					  -- Bullet points should be indented by 2 spaces and wrapped at 80 characters.
					  -- Append 2 newlines at the end of the commit message
					]],
					system_prompt = "Reply with descriptive commitizen-compliant commit messages in a code block",
					description = "Create a detailed commit message",
					context = "git:staged",
				},
			},
		},
	},
}
