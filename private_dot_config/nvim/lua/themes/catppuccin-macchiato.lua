---@type Base46Table
local M = {}
M.base_30 = {
	white = "#cad3f5",
	darker_black = "#181926",
	black = "#24273a", --  nvim bg
	black2 = "#2a2e41",
	one_bg = "#363a4f", -- real bg of onedark
	one_bg2 = "#3e4258",
	one_bg3 = "#464a5f",
	grey = "#5b6078",
	grey_fg = "#6e738d",
	grey_fg2 = "#8087a2",
	light_grey = "#939ab7",
	red = "#ed8796",
	baby_pink = "#f5bde6",
	pink = "#f5bde6",
	line = "#363a4f", -- for lines like vertsplit
	green = "#a6da95",
	vibrant_green = "#a6da95",
	nord_blue = "#8aadf4",
	blue = "#8aadf4",
	yellow = "#eed49f",
	sun = "#eed49f",
	purple = "#c6a0f6",
	dark_purple = "#c6a0f6",
	teal = "#8bd5ca",
	orange = "#f5a97f",
	cyan = "#91d7e3",
	statusline_bg = "#1e2030",
	lightbg = "#363a4f",
	pmenu_bg = "#a6da95",
	folder_bg = "#8aadf4",
	lavender = "#b7bdf8",
}

M.base_16 = {
	base00 = "#24273a",
	base01 = "#1e2030",
	base02 = "#363a4f",
	base03 = "#494d64",
	base04 = "#5b6078",
	base05 = "#cad3f5",
	base06 = "#f4dbd6",
	base07 = "#b8c0e0",
	base08 = "#ed8796",
	base09 = "#f5a97f",
	base0A = "#eed49f",
	base0B = "#a6da95",
	base0C = "#8bd5ca",
	base0D = "#8aadf4",
	base0E = "#c6a0f6",
	base0F = "#f5bde6",
}

M.polish_hl = {
	treesitter = {
		["@variable"] = { fg = M.base_30.lavender },
		["@property"] = { fg = M.base_30.teal },
		["@variable.builtin"] = { fg = M.base_30.red },
	},
}

M.type = "dark"

M = require("base46").override_theme(M, "catppuccin-macchiato")

return M
