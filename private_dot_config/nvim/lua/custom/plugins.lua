local plugins = {

  {
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

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function()
      require "custom.configs.treesitter"
    end,
  },

  {
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

  {
    "junegunn/vim-easy-align",
    keys = {
      { "ga" , "<Plug>(EasyAlign)"    , desc = "EasyAlign" , mode = "x" } ,
      { "ga" , "<Plug>(EasyAlign)"    , desc = "EasyAlign" , mode = "v" } ,
    }
  },

  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    -- config = true,
    opts = function()
      require "custom.configs.symbols-outline"
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = function()
      require "custom.configs.mason"
    end,
  },

  {
    "Pocco81/auto-save.nvim",
    lazy = false,
    event = { "InsertLeave", "TextChanged" } 
  },

  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    init = function()
      require("core.utils").load_mappings "nvimtree"
    end,
    opts = function()
      return require "custom.configs.nvimtree"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "nvimtree")
      require("nvim-tree").setup(opts)
    end,
  },
  { "christoomey/vim-tmux-navigator" , lazy = false },
  { "tpope/vim-sleuth"               , lazy = false },
  { "tpope/vim-surround"             , lazy = false },
  { "junegunn/goyo.vim"              , lazy = false },
  { "justinmk/vim-sneak"             , lazy = false },
  { "jiangmiao/auto-pairs"           , lazy = false },
  { "tpope/vim-fugitive"             , lazy = false },
}

return plugins
