---@type ChadrcConfig 

local M = {}

M.mappings = require "custom.mappings"
M.plugins = "custom.plugins"

vim.opt.timeoutlen = 250

M.ui = {
  theme = 'bearded-arc',
  tabufline = { enabled = false },
  statusline = { separator_style = "arrow" },
  nvdash = { load_on_startup = true },
}

return M
