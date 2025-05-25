return {
	"nvim-tree/nvim-tree.lua",
	keys = {
		{ "<C-n>", "<cmd>NvimtreeToggle<CR>", desc = "Toggle NvimTree" },
	},
	config = function()
		require("nvim-tree").setup({
			view = {
				side = "right",
				float = {
					enable = true,
					open_win_config = {
						relative = "editor",
						border = "rounded",
						width = 30,
						height = 45,
						row = 1,
						col = 999,
						anchor = "NE",
					},
				},
			},
			git = {
				enable = true,
			},
		})

		local map = vim.keymap.set
		local api = require("nvim-tree.api")
		map("n", "<C-n>", api.tree.toggle, { desc = "Nvimtree Toggle window" })
		map("n", "<leader>e", api.tree.focus, { desc = "Nvimtree Focus window" })
	end
}
