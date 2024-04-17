local path = vim.fn.expand("~") .. "/Documents/Wiki"

return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	-- lazy = true,
	-- ft = "markdown",
	cmd = { "ObsidianQuickSwitch", "ObsidianDailies", "ObsidianToday", "ObsidianNew" },
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	event = {
		-- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
		-- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
		"BufReadPre "
			.. path
			.. "/**.md",
		"BufNewFile " .. path .. "/**.md",
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
