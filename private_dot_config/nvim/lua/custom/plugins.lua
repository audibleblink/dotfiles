-- vim: ft=lua foldmarker=[[[,]]] foldlevelstart=0 foldmethod=marker spell:

local plugins = {

  { -- Noice [[[
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = { },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      -- "rcarriga/nvim-notify",
      }
  },
-- ]]]
  { -- [[[ TreeSitter
    "nvim-treesitter/nvim-treesitter",
    opts = function()
      local conf = require "plugins.configs.treesitter"
      local custom = require "custom.configs.treesitter"
      conf.ensure_installed = custom.ensure_installed
      return conf
    end,
  },
-- ]]]
  { -- lspConfig [[[ 
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/null-ls.nvim",
      config = function()
        require "custom.configs.null-ls"
      end,
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
-- ]]]
  { -- EasyAlign [[[ 
    "junegunn/vim-easy-align",
    keys = {
      { "ga" , "<Plug>(EasyAlign)"    , desc = "EasyAlign" , mode = "x" } ,
      { "ga" , "<Plug>(EasyAlign)"    , desc = "EasyAlign" , mode = "v" } ,
    }
  },
-- ]]]
  { -- SymbolsOutline [[[ 
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    -- config = true,
    opts = function()
      require "custom.configs.symbols-outline"
    end,
  },
-- ]]]
  { -- Mason [[[ 
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = require "custom.configs.mason"
  },
-- ]]]
  { -- AutoSave [[[ 
    "okuuva/auto-save.nvim",
    cmd = "ASToggle", -- optional for lazy loading on command
    event = { "InsertLeave" }, -- optional for lazy loading on trigger events
    opts = {
      trigger_events = {
        immediate_save = { "BufLeave" }, -- vim events that trigger an immediate save
        defer_save = { "InsertLeave" }, -- vim events that trigger a deferred save (saves after `debounce_delay`)
      },
      debounce_delay = 2000
    },
  },
-- ]]]
  { -- NvimTree [[[ 
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    init = function()
      require("core.utils").load_mappings "nvimtree"
    end,
    opts = require "custom.configs.nvimtree",
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "nvimtree")
      require("nvim-tree").setup(opts)
    end,
  },
-- ]]]

  { "tpope/vim-sleuth"      , lazy = false },
  { "tpope/vim-surround"    , lazy = false },
  { "junegunn/goyo.vim"     , lazy = false },
  { "justinmk/vim-sneak"    , lazy = false },
  { "jiangmiao/auto-pairs"  , lazy = false },
  { "tpope/vim-fugitive"    , lazy = false },
  { "github/copilot.vim"    , lazy = false },

  { "christoomey/vim-tmux-navigator" , lazy = false },
}

return plugins
