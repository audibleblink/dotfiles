return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	dependencies = {
		{
			"zbirenbaum/copilot-cmp",
			config = function ()
				require("copilot_cmp").setup()
			end
		},
	},
	opts = {
		panel = { enabled = false, },
		suggestion = { 
			-- enabled = true, 
			auto_trigger = true,
		},
		auth_provider_url = nil, -- URL to authentication provider, if not "https://github.com/"
		workspace_folders = {},
		copilot_model = "claude-sonnet-4",
	}
}
