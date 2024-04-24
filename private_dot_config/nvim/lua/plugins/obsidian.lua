local path = vim.fn.expand("~") .. "/Documents/Wiki"

return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	cmd = { "ObsidianQuickSwitch", "ObsidianDailies", "ObsidianToday", "ObsidianNew" },
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	event = {
		-- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
		-- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
		"BufNewFile "
			.. path
			.. "/**.md",
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
				path = path,
				overrides = {
					notes_subdir = "03 - Content",
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

		callbacks = {
			---@param client obsidian.Client
			---@param workspace obsidian.Workspace
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

			-- `note.metadata` contains any manually added fields in the frontmatter.
			-- So here we just make sure those fields are kept in the frontmatter.
			if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
				for k, v in pairs(note.metadata) do
					out[k] = v
				end
			end

			return out
		end,
	},
}
