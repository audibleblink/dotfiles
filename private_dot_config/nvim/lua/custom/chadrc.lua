---@type ChadrcConfig 

local M = {}

M.mappings = require "custom.mappings"
M.plugins = "custom.plugins"

vim.opt.timeoutlen = 250

M.ui = {
  theme = 'bearded-arc',
  tabufline = { enabled = false },
  statusline = {
    theme = "minimal",
    separator_style = "round",
  },
  nvdash = {
    load_on_startup = true,
  },
}

return M
