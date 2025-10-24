return {
	"olimorris/codecompanion.nvim",

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
					cache_models_for = 3600,
					-- proto://host:port
					proxy = nil,
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
					llm = function()
						local bufnr = vim.api.nvim_get_current_buf()
						return "AI: "
							.. _G.codecompanion_chat_metadata[bufnr].adapter.name
							.. "/"
							.. _G.codecompanion_chat_metadata[bufnr].adapter.model
					end,
					user = function()
						return "User: " .. vim.loop.os_get_passwd().username
					end,
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
		memory = {
			opts = {
				chat = {
					enabled = true,
				},
			},
		},
		prompt_library = {
			["myCommit"] = {
				strategy = "inline",
				adapter = "copilot",
				model = "claude-sonnet-4",
				description = "Create a detailed commit",
				opts = {
					placement = "replace",
					is_slash_cmd = true,
					auto_submit = true,
					short_name = "myCommit",
					lines = vim.api.nvim_buf_get_lines(0, 0, -1, false),
					-- pre_hook = function()
					-- 	vim.api.nvim_feedkeys("ggVG", "n", false)
					-- 	return vim.api.nvim_get_current_buf()
					-- end,
				},
				prompts = {
					{
						role = "system",
						content = "You're a git assistant running within neovim, with access to buffers",
					},
					{
						role = "user",
						content = function(context)
							return [[ 
<prompt>
#{buffer}
#buffer

Replace the buffer/file with a commit message for these changes. 
Keep the title under 72 characters. 
- Bullet points should be indented by 2 spaces and wrapped at 80 characters.
- Append 2 newlines at the end of the commit message
</prompt>
]]
						end,
					},
				},
			},
		},
	},

	config = function(_, opts)
		require("codecompanion").setup(opts)
		vim.cmd([[cab cc CodeCompanion]])

		local spinner = {
			completed = "󰗡 Completed",
			error = " Error",
			cancelled = "󰜺 Cancelled",
		}

		---Format the adapter name and model for display with the spinner
		---@param adapter CodeCompanion.Adapter
		---@return string
		local function format_adapter(adapter)
			local parts = {}
			table.insert(parts, adapter.formatted_name)
			if adapter.model and adapter.model ~= "" then
				table.insert(parts, "(" .. adapter.model .. ")")
			end
			return table.concat(parts, " ")
		end

		---Setup the spinner for CodeCompanion
		---@return nil
		local function codecompanion_spinner()
			local ok, progress = pcall(require, "fidget.progress")
			if not ok then
				return
			end

			spinner.handles = {}

			local group = vim.api.nvim_create_augroup("dotfiles.codecompanion.spinner", {})

			vim.api.nvim_create_autocmd("User", {
				pattern = "CodeCompanionRequestStarted",
				group = group,
				callback = function(args)
					local handle = progress.handle.create({
						title = "",
						message = "  Sending...",
						lsp_client = {
							name = format_adapter(args.data.adapter),
						},
					})
					spinner.handles[args.data.id] = handle
				end,
			})

			vim.api.nvim_create_autocmd("User", {
				pattern = "CodeCompanionRequestFinished",
				group = group,
				callback = function(args)
					local handle = spinner.handles[args.data.id]
					spinner.handles[args.data.id] = nil
					if handle then
						if args.data.status == "success" then
							handle.message = spinner.completed
						elseif args.data.status == "error" then
							handle.message = spinner.error
						else
							handle.message = spinner.cancelled
						end
						handle:finish()
					end
				end,
			})
		end

		codecompanion_spinner()
	end,

	dependencies = {
		"j-hui/fidget.nvim", -- Display status
	},
}
