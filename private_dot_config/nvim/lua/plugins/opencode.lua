return {
	"NickvanDyke/opencode.nvim",
	---@type opencode.Opts
	opts = {
		prompt = {
			commit = {
				description = "Create a commit message",
				prompt = "@staged\n\nCreate a commit message for that. Only return the message as it should appear in COMMIT_EDITMSG",
			},
		},
		contexts = {
			["@staged"] = {
				description = "Staged Hunks",
				value = function()
					local handle = io.popen("git --no-pager diff --cached")
					if not handle then
						return nil
					end
					local result = handle:read("*a")
					handle:close()
					if result and result ~= "" then
						return result
					end
					return nil
				end,
			},
		},
		input = {
			prompt = "OC",
		},
	},
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
	},
}
