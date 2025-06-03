-- local snacks = require("snacks")
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  keys = {
    { "<C-n>", "<cmd>lua Snacks.explorer()<CR>", desc = "Toggle File Tree" },
  },
  opts = {
    explorer     = { replace_netrw = true },
    picker       = {
      enabled = true,
      sources = {
        explorer = {
          auto_close = true,
          layout = { layout = { position = "right" } },
          matcher = { fuzzy = true },
          win = {
            list = {
              keys = {
                ["<C-n>"] = "close",
              }
            }
          },
        }
      }
    },

    bigfile      = { enabled = false },
    dashboard    = { enabled = false },
    indent       = { enabled = false },
    input        = { enabled = false },
    notifier     = { enabled = false },
    quickfile    = { enabled = false },
    scope        = { enabled = false },
    scroll       = { enabled = false },
    statuscolumn = { enabled = false },
    words        = { enabled = false },
  },
}
