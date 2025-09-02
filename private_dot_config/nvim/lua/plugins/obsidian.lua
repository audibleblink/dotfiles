local path = vim.fn.expand("~") .. "/Vaults"

return {
	"obsidian-nvim/obsidian.nvim",
	lazy = true,
	version = "*",
	cmd = { "Obsidian" },
	event = {
		"BufNewFile " .. path .. "/**.md",
		"BufReadPre " .. path .. "/**.md",
	},

	---@module 'obsidian'
	---@type obsidian.config
	opts = {
		legacy_commands = false,
		open = {
			func = function(uri)
				vim.ui.open(uri, { cmd = { "open", "-a", "/Applications/Obsidian.app" } })
			end,
		},
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
		require("obsidian").setup(opts)
		vim.o.concealcursor = ""
	end,
}
