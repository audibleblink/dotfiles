local plugins = {

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
    "williamboman/mason.nvim",
    opts = function()
      require "custom.configs.symbols-outline"
    end,
  },

  { "justinmk/vim-sneak" },
  { "christoomey/vim-tmux-navigator" , lazy = false },
  { "tpope/vim-sleuth"               , lazy = false },
  { "tpope/vim-surround"             , lazy = false },
  { "junegunn/goyo.vim"              , lazy = false },
  { "justinmk/vim-sneak"             , lazy = false },
  { "jiangmiao/auto-pairs"           , lazy = false },

}

return plugins
