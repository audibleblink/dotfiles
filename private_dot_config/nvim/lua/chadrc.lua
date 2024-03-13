local M = {}

M.ui = {
	theme = "bearded-arc",
	tabufline = { enabled = false },
	statusline = { separator_style = "arrow" },
	nvdash = { load_on_startup = true },
	hl_override = {
		CursorLine = { bg = "black2" },
	},
}

return M
