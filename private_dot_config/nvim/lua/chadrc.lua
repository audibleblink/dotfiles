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
		order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "cursor", "cwd", "abc" },
		modules = {
			abc = function()
				local buf_path = vim.api.nvim_buf_get_name(0)
				local root = vim.fs.root(buf_path, { ".git", "HEAD" })
				if not root then
					return vim.fn.getcwd()
				end
				local relative_path = buf_path:sub(#root + 1)
				local dir_path = vim.fs.dirname(relative_path)
				dir_path = dir_path:gsub("^/", "")
				return dir_path
			end,
		},
	},
}

return M
