---@diagnostic disable: missing-fields
return {
	"folke/trouble.nvim",
	cmd = "Trouble",
	keys = {
		{ "<leader>x" },
		{ "<leader>o" },
		{
			"<leader>xx",
			"<cmd>Trouble diagnostics toggle<cr>",
			desc = "Diagnostics (Trouble)",
		},
		{
			"<leader>xX",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			desc = "Buffer Diagnostics (Trouble)",
		},
		{
			"<leader>xl",
			"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
			desc = "LSP Definitions / references / ... (Trouble)",
		},
	},
	opts = {
		icons = {
			indent = {
				ws = " ",
				top = "│ ",
				middle = "├╴",
				last = "└╴",
				-- last          = "-╴",
				-- last       = "╰╴", -- rounded
				fold_open = " ",
				fold_closed = " ",
			},
			folder_closed = "",
			folder_open = "",
			kinds = {
				Array = "",
				Boolean = "󰨙",
				Class = "",
				Constant = "󰏿",
				Constructor = "",
				Enum = "",
				EnumMember = "",
				Event = "",
				Field = "",
				File = "",
				Function = "󰊕",
				Interface = "",
				Key = "",
				Method = "󰊕",
				Module = "",
				Namespace = "󰦮",
				Null = "",
				Number = "󰎠",
				Object = "",
				Operator = "",
				Package = "",
				Property = "",
				String = "",
				Struct = "󰆼",
				TypeParameter = "",
				Variable = "󰀫",
			},
		},
		modes = {
			symbols = {
				focus = false,
				win = { position = "left" },
			},
		},
	},
	config = function(_, opts)
		local trouble = require("trouble")
		trouble.setup(opts)

		vim.keymap.set("n", "<leader>o", function()
			trouble.toggle({ mode = "symbols" })
		end, { desc = "Symbols Outline" })

		vim.keymap.set("n", "<leader>xq", function()
			trouble.toggle({ mode = "qflist" })
		end, { desc = "Quickfix List (Trouble)" })

		vim.keymap.set("n", "<leader>xl", function()
			trouble.toggle({ mode = "loclist" })
		end, { desc = "Location List (Trouble)" })
	end,
}
