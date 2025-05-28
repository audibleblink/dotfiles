local M = {}

M.base46 = {
	transparency = true,
	theme = "catppuccin",
	theme_toggle = { "catppuccin", "one_light" },
	hl_override = { CursorLine = { bg = "black2" } },
}

-- :h nvui.tabufline.api
M.ui = {
	tabufline = {
		enabled = true,
		lazyload = true,
		order = { "treeOffset", "buffers", "tabs", "btns" },
		modules = nil,
		bufwidth = 21,
	},
	telescope = { style = "bordered" }, -- borderless / bordered
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
