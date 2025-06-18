return {
	"nvzone/floaterm",
	lazy = true,
	keys = { { "<Leader>lt", "<cmd>FloatermToggle<CR>", desc = "Toggle Terminals" } },
	cmd = "FloatermToggle",
	dependencies = "nvzone/volt",
	opts = {
		border = false,
		size = { h = 60, w = 70 },
		mappings = {
			sidebar = nil,
			term = function(buf)
				vim.keymap.set({ "n", "t" }, "<C-n>", function()
					require("floaterm.api").cycle_term_bufs("next")
				end, { buffer = buf })
				vim.keymap.set({ "n", "t" }, "<C-p>", function()
					require("floaterm.api").cycle_term_bufs("prev")
				end, { buffer = buf })
				vim.keymap.set({ "n", "t" }, "<Leader>lt", require("floaterm").toggle, { buffer = buf })
			end,
		},

		terminals = {
			{ name = "Terminal" },
			{ name = "Terminal", cmd = "btop" },
		},
	},
}
