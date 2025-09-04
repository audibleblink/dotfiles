return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		presets = {
			bottom_search = false, -- use a classic bottom cmdline for search
			command_palette = false, -- position the cmdline and popupmenu together
			long_message_to_split = true, -- long messages will be sent to a split
			inc_rename = false, -- enables an input dialog for inc-rename.nvim
			lsp_doc_border = false, -- add a border to hover docs and signature help
		},
		lsp = {
			signature = { enabled = false },
			hover = { enabled = true },
			message = { enabled = false },
		},
		views = {
			cmdline_popup = {
				size = { min_width = 66 },
				position = { row = "90%" },
				border = { style = { "", " ", "", " ", "", " ", "", " " } },
				win_options = { winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder" },
			},

			cmdline_input = {
				view = "cmdline_popup",
				border = { style = { "", " ", "", " ", "", " ", "", " " } },
				win_options = { winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder" },
			},
		},
		timeout = 2000,
		fps = 60,
		routes = {
			{
				filter = { find = "No information available" },
				view = "mini",
			},
			{
				filter = { find = "written" },
				view = "mini",
			},
			{
				filter = { find = "Successfully applied" },
				view = "mini",
			},
			{
				filter = { event = "msg_showmode" }, -- show recording msgs
				view = "notify",
			},
		},
	},
}
