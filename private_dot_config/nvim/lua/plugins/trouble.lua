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
		modes = {
			symbols = {
				focus = true,
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
