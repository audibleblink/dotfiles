return {
	"olimorris/codecompanion.nvim",
	keys = {
		{ "<Leader>ai", ":CodeCompanionChat Toggle<CR>", desc = "Toggle CodeCompanion" },
		{ "<Leader>ax", ":CodeCompanionActions<CR>", desc = "CodeCompanion Actions" },
	},
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
				anthropic = "anthropic",
				azure_openai = "azure_openai",
				copilot = "copilot",
				opts = {
					allow_insecure = false,
					show_defaults = false,
					show_model_choices = true,
					proxy = nil,
					-- proto://host:port
				},
			},
		},

		strategies = {
			chat = {
				adapter = "claude_code",
				model = "claude-sonnet-4-5-20250929",
				roles = {
					llm = function(adapter)
						return "Agent (" .. adapter.formatted_name .. ")"
					end,
					user = vim.loop.os_get_passwd().username,
				},
			},
		},

		opts = {
			log_level = "DEBUG", -- or "TRACE"
		},
	},
}
