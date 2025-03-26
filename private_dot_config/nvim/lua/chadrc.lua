local M = {}

M.base46 = {
	transparency = true,
	theme = "catppuccin",
	hl_override = { CursorLine = { bg = "black2" } },
}

M.ui = {
	tabufline = { enabled = false },
	statusline = {
		-- theme = "default",
		separator_style = "round",
		order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "cursor", "cwd", "f" },
		modules = {
			-- abc = function()
			-- 	return "hi"
			-- end,
			f = "%f",
		},
	},
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
