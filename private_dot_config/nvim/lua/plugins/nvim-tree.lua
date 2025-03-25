return {
	"nvim-tree/nvim-tree.lua",
	opts = {
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
			enable = false,
		},
	},
}
