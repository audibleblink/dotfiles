local M = {}

M.ui = {
	transparency = true,
	theme = "bearded-arc",
	tabufline = { enabled = false },
	statusline = { separator_style = "round" },
	hl_override = { CursorLine = { bg = "black2" } },
	term = {
		sizes = { sp = 0.3, vsp = 0.2 },
		float = {
			relative = "editor",
			row = 0.05,
			col = 0.15,
			width = 0.7,
			height = 0.6,
			border = "single",
		},
	},
}

return M
