local M = {}

M.base46 = {
	-- transparency = true,
	theme = "catppuccin-macchiato",
	theme_toggle = { "catppuccin-macchiato", "catppuccin-light" },
	hl_override = {
		St_gitIcons = { fg = "white", bg = "grey", bold = false }, -- hijacked
	},
}

M.nvdash = {
	load_on_startup = true,
	header = {
		"░▀█▀░▄▀▀▄░█▀▄▀█░▄▀▀▄░█▀▀▄░█▀▀▄░▄▀▀▄░█░░░█",
		"░░█░░█░░█░█░▀░█░█░░█░█▄▄▀░█▄▄▀░█░░█░▀▄█▄▀",
		"░░▀░░░▀▀░░▀░░▒▀░░▀▀░░▀░▀▀░▀░▀▀░░▀▀░░░▀░▀░",
		"	░█▀▄░▄▀▀▄░█▀▄▀█░█▀▀░█▀▀",
		"	░█░░░█░░█░█░▀░█░█▀▀░▀▀▄",
		"	░▀▀▀░░▀▀░░▀░░▒▀░▀▀▀░▀▀▀",
		"",
	},
	buttons = {
		{ txt = "  Find File", keys = "ff", cmd = "Telescope find_files" },
		{ txt = "  Recent Files", keys = "fo", cmd = "Telescope oldfiles" },
		{ txt = "󰈭  Find Word", keys = "fw", cmd = "Telescope live_grep" },
		{ txt = "  Mappings", keys = "fm", cmd = "Telescope keymaps" },
		{ txt = "  Dotifile", keys = "cm", cmd = "Telescope chezmoi find_files" },
		{ txt = "  Quit", keys = "q", cmd = "quit" },
		{ txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
		{
			txt = function()
				local stats = require("lazy").stats()
				local ms = math.floor(stats.startuptime) .. " ms"
				return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
			end,
			hl = "NvDashFooter",
			no_gap = true,
		},
		{ txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
	},
}

local utils = require("nvchad.stl.utils")
local sep_l = utils.separators["round"]["left"]
local sep_r = utils.separators["round"]["right"]
M.ui = {
	tabufline = {
		lazyload = true,
		order = { "buffers", "tabs", "btns" },
	},
	telescope = { style = "borderless" }, -- borderless / bordered
	statusline = {
		-- theme = "minimal",
		separator_style = "round",
		order = { "_mode", "file", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "_git", "_cursor" },
		modules = {
			_mode = function()
				if not utils.is_activewin() then
					return ""
				end

				local path = vim.uv.cwd() or ""
				local cwd = path:match("([^/]+)$")
				cwd = "%#St_gitIcons# " .. cwd

				local modes = utils.modes
				local m = vim.api.nvim_get_mode().mode
				local current_mode = "%#St_" .. modes[m][2] .. "Mode#  "
				local mode_sep1 = "%#St_" .. modes[m][2] .. "ModeSep#" .. sep_r
				return current_mode .. mode_sep1 .. cwd .. "%#St_EmptySpace#" .. sep_r
			end,

			_git = function()
				return "%#St_file_sep#" .. sep_l .. "%#St_cwd_text#" .. utils.git() .. " "
			end,

			_cursor = function()
				if not utils.is_activewin() then
					return ""
				end
				return "%#St_pos_sep#" .. sep_l .. "%#St_pos_icon#  %#St_pos_text# %l/%v "
			end,
		},
	},
}

M.lsp = { signature = false }

return M
