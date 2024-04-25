local path = vim.fn.expand("~") .. "/Vaults"

return {
	"epwalsh/obsidian.nvim",
	version = "*",
	cmd = { "ObsidianQuickSwitch", "ObsidianDailies", "ObsidianToday", "ObsidianNew" },
	event = {
		"BufNewFile " .. path .. "/**.md",
		"BufReadPre " .. path .. "/**.md",
	},

	dependencies = {
		"nvim-lua/plenary.nvim",
	},

	opts = {
		open_app_foreground = false,
		workspaces = {

			{
				name = "personal",
				path = path .. "/Wiki",
				overrides = {
					notes_subdir = "03 - Content",
					daily_notes = {
						folder = "05 - Journals",
						template = "0402 - Daily.md",
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

			{
				name = "work",
				path = path .. "/Work",
				overrides = {
					notes_subdir = "Notes",
					daily_notes = {
						folder = "Journals",
						template = "Daily.md",
						alias_format = "%B %-d, %Y",
					},
					templates = {
						subdir = "Templates",
					},
					attachments = {
						img_folder = "Notes/data",
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
}
