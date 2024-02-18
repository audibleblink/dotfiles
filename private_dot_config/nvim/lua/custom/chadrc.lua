local M = {}

M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"

vim.opt.timeoutlen = 250
vim.opt.swapfile   = false
vim.opt.scrolloff  = 8
vim.opt.cursorline = true
vim.opt.colorcolumn = "99"

-- NvChad specific settings
M.ui = {
  theme = 'bearded-arc',
  tabufline = { enabled = false },
  statusline = { separator_style = "arrow" },
  nvdash = { load_on_startup = true },
  hl_override = {
    CursorLine = { bg = "black2" },
  },
}

return M
