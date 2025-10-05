local M = {}

M.base46 = {
	-- transparency = true,
	theme = "catppuccin-macchiato",
	theme_toggle = { "catppuccin-macchiato", "catppuccin-light" },
	hl_add = {
		RenderMarkdownH1Bg = { fg = "blue" },
		RenderMarkdownH2Bg = { fg = "cyan" },
		RenderMarkdownH3Bg = { fg = "green" },
		RenderMarkdownH4Bg = { fg = "yellow" },
		RenderMarkdownH5Bg = { fg = "orange" },
		RenderMarkdownH6Bg = { fg = "red" },
		i3tabActiveSym = { fg = "blue", bg = "black" },
		i3tabActiveText = { fg = "black", bg = "blue" },
		i3tabInactiveSym = { fg = "grey", bg = "black" },
		i3tabInactiveText = { fg = "black", bg = "grey" },
		i3tabPad = { bg = "black" },
	},
}

-- require("base46").compile(); require("base46").load_all_highlights()

M.nvdash = {
	load_on_startup = true,
	header = {
		"░▀█▀░▄▀▀▄░█▀▄▀█░▄▀▀▄░█▀▀▄░█▀▀▄░▄▀▀▄░█░░░█",
		"░░█░░█░░█░█░▀░█░█░░█░█▄▄▀░█▄▄▀░█░░█░▀▄█▄▀",
		"░░▀░░░▀▀░░▀░░▒▀░░▀▀░░▀░▀▀░▀░▀▀░░▀▀░░░▀░▀░",
		"  ░█▀▀█░▄▀▀▄░█▀▄▀█░█▀▀░█▀▀",
		"  ░█░░░░█░░█░█░▀░█░█▀▀░▀▀▄",
		"  ░▀▀▀▀░░▀▀░░▀░░▒▀░▀▀▀░▀▀▀",
		"",
		"",
	},
	buttons = {
		{ txt = " ", hl = "NvDashFooter", no_gap = true, rep = true },
		{ txt = "  Find File", keys = "f", cmd = "Telescope find_files" },
		{ txt = "  Recent Files", keys = "r", cmd = "Telescope oldfiles" },
		{ txt = "󰅩  Open Code Repo", keys = "o", cmd = "Telescope file_browser cwd=~/code" },
		{ txt = "  Lazy", keys = "l", cmd = "Lazy" },
		{ txt = "  Dotfiles", keys = "d", cmd = "Telescope chezmoi find_files" },
		{ txt = "󱞁  Scratch Buffer", keys = "s", cmd = "enew | setlocal buftype=nofile bufhidden=hide noswapfile" },
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
	tabufline = { enabled = false },
	telescope = { style = "borderless" }, -- borderless / bordered
	cmp = {
		icons_left = true, -- only for non-atom styles!
		style = "flat_dark", -- default/flat_light/flat_dark/atom/atom_colored
	},
	statusline = {
		-- theme = "minimal",
		separator_style = "round",
		order = {
			"_mode",
			"file",
			"_rec",
			"%=",
			"f",
			"lsp_msg",
			"%=",
			"diagnostics",
			"lsp",
			"_rec",
			"_git",
			"_cc",
			"_cursor",
		},
		modules = {
			f = "%f",
			_mode = function()
				if not utils.is_activewin() then
					return ""
				end

				local m = vim.api.nvim_get_mode().mode
				local mode_hi = "%#St_" .. utils.modes[m][2] .. "Mode#"
				local mode_sep_hi = "%#St_" .. utils.modes[m][2] .. "ModeSep#"
				local path = vim.uv.cwd() or ""
				local cwd = "%#MatchWord#" .. " " .. path:match("([^/]+)$") .. "%#St_EmptySpace#"
				return mode_hi .. " 󰞷 " .. mode_sep_hi .. sep_r .. cwd .. sep_r
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

			_rec = function()
				local rec = vim.fn.reg_recording()
				return rec ~= "" and "%#St_cwd_sep#" .. " 󰑋 " .. rec .. " " or ""
			end,

			_cc = function()
				if not utils.is_activewin() then
					return ""
				end

				local bufnr = vim.api.nvim_get_current_buf()
				if vim.bo[bufnr].filetype == "codecompanion" then
					return "%#St_cwd_text#" .. "codecompanion "
				else
					return ""
				end
			end,
		},
	},
}

M.lsp = { signature = false }

return M
