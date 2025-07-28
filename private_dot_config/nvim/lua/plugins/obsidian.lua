local path = vim.fn.expand("~") .. "/Vaults"

return {
	"obsidian-nvim/obsidian.nvim",
	-- enabled = false,
	lazy = true,
	version = "*",
	-- ui = { enable = false },
	cmd = { "ObsidianQuickSwitch", "ObsidianDailies", "ObsidianToday", "ObsidianNew", "ObsidianWorkspace" },
	keys = {
		-- { "<leader>oo", "<cmd>ObsidianWorkspace<CR>", desc = "Open Obsidian Workspace Picker" },
		-- { "<leader>on", "<cmd>ObsidianNew<CR>", desc = "New Note (Obsidian)" },
	},
	event = {
		"BufNewFile " .. path .. "/**.md",
		"BufReadPre " .. path .. "/**.md",
	},
	---@module 'obsidian'
	---@type obsidian.config
	opts = {

		open_app_foreground = false,
		workspaces = {

			{
				name = "personal",
				path = path .. "/Personal",
				overrides = {
					notes_subdir = "Notes",
					daily_notes = {
						folder = "Journals",
						template = "daily.md",
						alias_format = "%B %-d, %Y",
					},
					templates = {
						subdir = "Templates",
					},
					attachments = {
						img_folder = "Notes/files",
					},
				},
			},

			{
				name = "work",
				path = path .. "/Work",
				overrides = {
					notes_subdir = "Notes",
					daily_notes = {
						folder = "Journals",
						template = "daily.md",
						alias_format = "%B %-d, %Y",
					},
					templates = {
						subdir = "Templates",
					},
					attachments = {
						img_folder = "Notes/files",
					},
				},
			},
			{
				name = "rule10",
				path = path .. "/obsidian.wiki",
				overrides = {
					notes_subdir = "03 - Content",
					daily_notes = {
						folder = "Day Planners",
						template = "daily.md",
						alias_format = "%B %-d, %Y",
					},
					templates = {
						subdir = "04 - Templates",
					},
					attachments = {
						img_folder = "03 - Content/files",
					},
				},
			},
		},

		mappings = {
			["<C-c>"] = {
				action = function()
					return require("obsidian").util.toggle_checkbox()
				end,
				opts = { buffer = true },
			},
			["gd"] = {
				action = "<cmd>ObsidianToday<CR>",
				opts = { buffer = true },
			},
			["gi"] = {
				action = "<cmd>ObsidianTemplate<CR>",
				opts = { buffer = true },
			},
			["go"] = {
				action = "<cmd>ObsidianOpen<CR>",
				opts = { buffer = true },
			},
			["<cr>"] = {
				action = function()
					return require("obsidian").util.smart_action()
				end,
				opts = { buffer = true, expr = true },
			},
			["gf"] = {
				action = function()
					return require("obsidian").util.gf_passthrough()
				end,
				opts = { noremap = false, expr = true, buffer = true },
			},
		},

		callbacks = {
			post_set_workspace = function(client, workspace)
				client.log.info("Changing directory to %s", workspace.path)
				vim.cmd.cd(tostring(workspace.path))
			end,
		},

		disable_frontmatter = true,
		note_frontmatter_func = function(note)
			-- Add the title of the note as an alias.
			if note.title then
				note:add_alias(note.title)
			end

			local out = { aliases = note.aliases }

			-- Make sure those fields are kept in the frontmatter.
			if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
				for k, v in pairs(note.metadata) do
					out[k] = v
				end
			end

			return out
		end,
	},
	config = function(_, opts)
		vim.o.conceallevel = 1
		require("obsidian").setup(opts)
	end,
}
