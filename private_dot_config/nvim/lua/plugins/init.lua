-- vim: ft=lua foldmarker=[[[,]]] foldlevelstart=0 foldmethod=marker spell:

return {

	{ -- Noice [[[
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			lsp = {
				signature = { enabled = false },
				hover = { enabled = false },
			},
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			-- "rcarriga/nvim-notify",
		},
	},
	-- ]]]
	{ -- [[[ TreeSitter
		"nvim-treesitter/nvim-treesitter",
		opts = function()
			local conf = require("nvchad.configs.treesitter")
			local custom = require("configs.treesitter")
			conf.ensure_installed = ensure_installed
			return conf
		end,
	},
	-- ]]]
	{ -- Mason [[[
		"williamboman/mason-lspconfig.nvim",
		opts = require("configs.mason"),
	},
	{
		"williamboman/mason.nvim",
		opts = function()
			return require("configs.mason")
		end,
	},
	-- ]]]
	{ -- lspConfig [[[
		"neovim/nvim-lspconfig",
		dependencies = {
			"jose-elias-alvarez/null-ls.nvim",
			config = function()
				require("configs.null-ls")
			end,
		},
		config = function()
			require("nvchad.configs.lspconfig").defaults()
			require("configs.lspconfig")
		end,
	},
	-- ]]]
	{ -- EasyAlign [[[
		"junegunn/vim-easy-align",
		keys = {
			{ "ga", "<Plug>(EasyAlign)", desc = "EasyAlign", mode = "x" },
			{ "ga", "<Plug>(EasyAlign)", desc = "EasyAlign", mode = "v" },
		},
	},
	-- ]]]
	{ -- SymbolsOutline [[[
		"simrat39/symbols-outline.nvim",
		cmd = "SymbolsOutline",
		keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
		-- config = true,
		opts = function()
			require("configs.symbols-outline")
		end,
	},
	-- ]]]
	{ -- AutoSave [[[
		"okuuva/auto-save.nvim",
		-- cmd = "ASToggle", -- optional for lazy loading on command
		event = { "InsertLeave" }, -- optional for lazy loading on trigger events
		opts = {
			trigger_events = {
				immediate_save = { "BufLeave" }, -- vim events that trigger an immediate save
				-- defer_save = { "InsertLeave" }, -- vim events that trigger a deferred save (saves after `debounce_delay`)
			},
			debounce_delay = 2000,
		},
	},
	-- ]]]
	{ -- NvimTree [[[
		"nvim-tree/nvim-tree.lua",
		opts = {
			view = {
				side = "right",
			},
			git = {
				enable = false,
			},
		},
	},
	-- ]]]
	{ -- [[[ Copilot
		"github/copilot.vim",
		cmd = "Copilot",
		config = function()
			vim.cmd([[
      imap <silent><script><expr> <C-;> copilot#Accept("\<CR>")
      let g:copilot_no_tab_map = v:true
      ]])
		end,
	},
	-- ]]]

	{ "junegunn/goyo.vim" },
	{ "tpope/vim-fugitive" },
	{ "someone-stole-my-name/yaml-companion.nvim" },
	{ "tpope/vim-sleuth", lazy = false },
	{ "tpope/vim-surround", lazy = false },
	{ "justinmk/vim-sneak", lazy = false },
	{ "jiangmiao/auto-pairs", lazy = false },
	{ "ellisonleao/glow.nvim", config = true, cmd = "Glow" },
	{ "christoomey/vim-tmux-navigator", lazy = false },
}
