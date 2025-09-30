return {
	"olimorris/codecompanion.nvim",

	init = function()
		vim.cmd([[cab cc CodeCompanion]])
		require("plugins.custom.spinner"):init()
	end,

	keys = {
		{ "<Leader>ai", mode = { "n", "x" }, ":CodeCompanionChat Toggle<CR>", desc = "Toggle CodeCompanion" },
		{ "<Leader>ax", mode = { "n", "x" }, ":CodeCompanionActions<CR>", desc = "CodeCompanion Actions" },
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
			inline = {
				adapter = {
					name = "copilot",
					model = "claude-sonnet-4",
				},
			},
			chat = {
				adapter = "copilot",
				model = "claude-sonnet-4",

				roles = {
					llm = function(adapter)
						return "Agent (" .. adapter.formatted_name .. ")"
					end,
					user = vim.loop.os_get_passwd().username,
				},

				slash_commands = {
					["buffer"] = {
						keymaps = {
							modes = {
								i = "<C-b>",
							},
						},
					},
					["fetch"] = {
						keymaps = {
							modes = {
								i = "<C-f>",
							},
						},
					},
					["help"] = {
						opts = {
							max_lines = 1000,
						},
					},
					-- ["image"] = {
					-- 	keymaps = {
					-- 		modes = {
					-- 			i = "<C-i>",
					-- 		},
					-- 	},
					-- 	opts = {
					-- 		dirs = { "~/Documents/Screenshots" },
					-- 	},
					-- },
				},
			},
		},
		display = {
			action_palette = {
				provider = "default",
			},
			chat = {
				-- show_references = true,
				-- show_header_separator = false,
				-- show_settings = false,
				icons = {
					tool_success = "󰸞 ",
				},
				fold_context = true,
			},
		},

		opts = {
			log_level = "DEBUG", -- or "TRACE"
		},

		prompt_library = {
			["commit"] = {
				strategy = "chat",
				adapter = "copilot",
				-- model = "claude-sonnet-4-5-20250929",
				description = "Create a detailed commit",
				opts = {
					index = 11,
					is_slash_cmd = true,
					is_default = true,
					auto_submit = false,
					short_name = "commit",
				},
				-- context = {
				-- 	{
				-- 		type = "file",
				-- 		path = { ".git/COMMIT_EDITMSG" },
				-- 	},
				-- },
				prompts = {
					{
						role = "system",
						content = "You're a git assistant running within neovim, with access to buffers",
					},
					{
						role = "user",
						content = [[ 
Insert a commit message for these changes. 
Keep the title under 72 characters. 
- Bullet points should be indented by 2 spaces and wrapped at 80 characters.
- Append 2 newlines at the end of the commit message


Find neovim data about the current state below:
#{buffer:COMMIT_EDITMSG}
@{files}
						]],
					},
				},
			},
		},
	},

	config = function(_, opts)
		require("codecompanion").setup(opts)
	end,

	dependencies = {
		"j-hui/fidget.nvim", -- Display status
	},
}
