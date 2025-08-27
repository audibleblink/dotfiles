return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		presets = {
			bottom_search = false, -- use a classic bottom cmdline for search
			command_palette = false, -- position the cmdline and popupmenu together
			long_message_to_split = true, -- long messages will be sent to a split
			inc_rename = false, -- enables an input dialog for inc-rename.nvim
			lsp_doc_border = true, -- add a border to hover docs and signature help
		},
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = false,
				["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
			},
		},
		views = {
			cmdline_popup = {
				size = { min_width = 66 },
				position = { row = "40%" },
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
