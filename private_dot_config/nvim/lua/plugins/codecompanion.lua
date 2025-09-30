return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {

		adapters = {
			acp = {
				opts = { show_defaults = false },
				claude_code = function()
					return require("codecompanion.adapters").extend("claude_code", {
						env = {
							CLAUDE_CODE_OAUTH_TOKEN = "cmd:op read op://Infra/claude-code/oauth --no-newline",
						},
					})
				end,
			},
			http = {
				opts = {
					-- allow_insecure = true,
					-- show_defaults = false,
					-- proxy = "socks5://127.0.0.1:9999",
				},
			},
		},

		strategies = {
			chat = {
				adapter = "claude_code",
				opts = { completion_provider = "cmp" },
				-- model = "claude-sonnet-4-20250514",
			},
		}, -- NOTE: The log_level is in `opts.opts`

		opts = {
			log_level = "DEBUG", -- or "TRACE"
		},
	},
}
