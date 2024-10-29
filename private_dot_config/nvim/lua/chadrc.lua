local M = {}

M.base46 = {
	transparency = true,
	theme = "catppuccin",
	hl_override = { CursorLine = { bg = "black2" } },
}

M.ui = {
	tabufline = { enabled = false },
	statusline = { separator_style = "round" },
	term = {
		sizes = { sp = 0.3, vsp = 0.2 },
		float = {
			relative = "editor",
			row = 0.05,
			col = 0.15,
			width = 0.8,
			height = 0.6,
			border = "single",
		},
	},
}

return M
