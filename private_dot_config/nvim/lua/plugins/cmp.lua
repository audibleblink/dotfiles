local cmp = require("cmp")
-- local lspkind = require "lspkind"
--
cmp.event:on("menu_opened", function()
	vim.b.copilot_suggestion_hidden = true
end)

return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	opts = {
		completion = { completeopt = "menu,menuone" },
		preselect = cmp.PreselectMode.None,
		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},

		mapping = {
			["<CR>"] = cmp.config.disable,
			["<C-p>"] = cmp.mapping.select_prev_item(),
			["<C-n>"] = cmp.mapping.select_next_item(),
			["<C-d>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-e>"] = cmp.mapping.close(),
			["<C-Space>"] = cmp.mapping.complete(),

			["<C-l>"] = cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Insert,
				select = false,
			}),
		},

		sources = {
			{ name = "nvim_lsp" },
			{ name = "copilot" },
			{ name = "luasnip" },
			{ name = "buffer" },
			{ name = "nvim_lua" },
			{ name = "path" },
		},

		-- formatting = {
		-- 	format = lspkind.cmp_format({
		-- 		mode = "symbol",
		-- 		max_width = 50,
		-- 		symbol_map = { Copilot = "" }
		-- 	})
		-- }
	}
,
	dependencies = {
		{
			-- snippet plugin
			"L3MON4D3/LuaSnip",
			dependencies = "rafamadriz/friendly-snippets",
			opts = { history = true, updateevents = "TextChanged,TextChangedI" },
			config = function(_, opts)
				require("luasnip").config.set_config(opts)
				require("nvchad.configs.luasnip")
			end,
		},

		-- autopairing of (){}[] etc
		{
			"windwp/nvim-autopairs",
			opts = {
				fast_wrap = {},
				disable_filetype = { "TelescopePrompt", "vim" },
			},
			config = function(_, opts)
				require("nvim-autopairs").setup(opts)

				-- setup cmp for autopairs
				local cmp_autopairs = require("nvim-autopairs.completion.cmp")
				require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
			end,
		},

		{
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
	},
}
