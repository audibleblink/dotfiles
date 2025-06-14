local M = {}

M.base_30 = {
  white         = "#4c4f69",
  darker_black  = "#e6e9ef",
  black         = "#eff1f5", --  nvim bg
  black2        = "#e6e9ef",
  one_bg        = "#dce0e8", -- real bg of onedark
  one_bg2       = "#ccd0da",
  one_bg3       = "#bcc0cc",
  grey          = "#9ca0b0",
  grey_fg       = "#8c8fa1",
  grey_fg2      = "#7c7f93",
  light_grey    = "#6c6f85",
  red           = "#e64553",
  baby_pink     = "#dd7878",
  pink          = "#ea76cb",
  line          = "#dce0e8", -- for lines like vertsplit
  green         = "#40a02b",
  vibrant_green = "#40a02b",
  nord_blue     = "#1e66f5",
  blue          = "#1e66f5",
  yellow        = "#df8e1d",
  sun           = "#df8e1d",
  purple        = "#8839ef",
  dark_purple   = "#8839ef",
  teal          = "#179299",
  orange        = "#fe640b",
  cyan          = "#04a5e5",
  statusline_bg = "#e6e9ef",
  lightbg       = "#dce0e8",
  pmenu_bg      = "#40a02b",
  folder_bg     = "#1e66f5",
  lavender      = "#7287fd",
}

M.base_16 = {
  base00 = "#eff1f5",
  base01 = "#e6e9ef",
  base02 = "#dce0e8",
  base03 = "#ccd0da",
  base04 = "#bcc0cc",
  base05 = "#4c4f69",
  base06 = "#dc8a78",
  base07 = "#7c7f93",
  base08 = "#e64553",
  base09 = "#fe640b",
  base0A = "#df8e1d",
  base0B = "#40a02b",
  base0C = "#179299",
  base0D = "#1e66f5",
  base0E = "#8839ef",
  base0F = "#dd7878",
}

M.polish_hl = {
  treesitter = {
    ["@variable"] = { fg = M.base_30.lavender },
    ["@property"] = { fg = M.base_30.teal },
    ["@variable.builtin"] = { fg = M.base_30.red },
  },
}

M.type = "light"

M = require("base46").override_theme(M, "catppuccin-latte")

return M
