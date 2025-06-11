local M = {}

M.base46 = {
	-- transparency = true,
	theme = "catppuccin-macchiato",
	theme_toggle = { "catppuccin-macchiato", "one_light" },
	-- hl_override = { CursorLine = { bg = "one_bg" } },
}
-- force color change
-- require("base46").compile()
-- require("base46").load_all_highlights()

-- :h nvui.tabufline.api
M.ui = {
	tabufline = { enabled = false },
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
