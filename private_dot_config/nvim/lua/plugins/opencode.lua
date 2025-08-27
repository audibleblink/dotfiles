return {
	"NickvanDyke/opencode.nvim",
	---@type opencode.Opts
	opts = {},
	keys = {
		{
			"<leader>oa",
			function()
				require("opencode").ask()
			end,
			desc = "Ask opencode",
		},
		{
			"<leader>oa",
			function()
				require("opencode").ask("@selection: ")
			end,
			desc = "Ask opencode about selection",
			mode = "v",
		},
		{
			"<leader>on",
			function()
				require("opencode").command("session_new")
			end,
			desc = "New session",
		},
		{
			"<leader>oy",
			function()
				require("opencode").command("messages_copy")
			end,
			desc = "Copy last message",
		},
		{
			"<leader>op",
			function()
				require("opencode").select_prompt()
			end,
			desc = "Select prompt",
			mode = { "n", "v" },
		},
		-- Example: keymap for custom prompt
		{
			"<leader>oc",
			function()
				require("opencode").prompt("without extra info, only output a commitizen message based on @selection")
			end,
			desc = "Make a commit message",
			mode = { "v" },
		},
	},
}
