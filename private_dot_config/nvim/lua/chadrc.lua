local M = {}

M.base46 = {
	theme = "catppuccin-macchiato",
	theme_toggle = { "catppuccin-macchiato", "catppuccin-light" },
}

-- force color change
-- require("base46").compile()
-- require("base46").load_all_highlights()

M.ui = {
	tabufline = { enabled = false },
	telescope = { style = "borderless" }, -- borderless / bordered
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
}

return M
