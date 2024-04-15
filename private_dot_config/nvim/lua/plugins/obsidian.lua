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
		disable_frontmatter = true,
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
			-- alias_format = "%Y-%m-%d",
		},
		templates = {
			subdir = "04 - Templates",
			-- time_format = "%X",
			-- substitutions = {
			-- 	["time:HH:mm:ss"] = function()
			-- 		return os.date("%X")
			-- 	end,
			-- },
		},

		attachments = {
			img_folder = "03 - Content/files", -- This is the default
		},
		-- see below for full list of options 👇
	},
}
