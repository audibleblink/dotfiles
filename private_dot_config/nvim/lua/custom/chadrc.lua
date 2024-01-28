local M = {}

M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"

vim.opt.timeoutlen = 250
vim.opt.swapfile   = false

M.ui = {
  theme = 'bearded-arc',
  tabufline = { enabled = false },
  statusline = { separator_style = "arrow" },
  nvdash = { load_on_startup = true },
}

return M
