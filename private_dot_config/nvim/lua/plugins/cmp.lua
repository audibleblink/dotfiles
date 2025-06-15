return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	opts = {
		completion = { completeopt = "menu,menuone" },
		preselect = require("cmp").PreselectMode.None,
		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},

		mapping = {
			["<CR>"] = require("cmp").config.disable,
			["<C-p>"] = require("cmp").mapping.select_prev_item(),
			["<C-n>"] = require("cmp").mapping.select_next_item(),
			["<C-d>"] = require("cmp").mapping.scroll_docs(-4),
			["<C-f>"] = require("cmp").mapping.scroll_docs(4),
			["<C-e>"] = require("cmp").mapping.close(),
			["<C-Space>"] = require("cmp").mapping.complete(),

			["<C-l>"] = require("cmp").mapping.confirm({
				behavior = require("cmp").ConfirmBehavior.Replace,
				select = true,
			}),
		},

		sources = {
			{ name = "nvim_lsp" },
			{ name = "copilot" },
			{ name = "luasnip" },
			{ name = "buffer" },
			{ name = "nvim_lua" },
			{ name = "cmdline" },
			{ name = "path" },
		},
	},
	dependencies = {
		{
			"windwp/nvim-autopairs",
			opts = {
				fast_wrap = {},
				disable_filetype = { "TelescopePrompt", "vim" },
			},
			config = function(_, opts)
				require("nvim-autopairs").setup(opts)
				local cmp_autopairs = require("nvim-autopairs.completion.cmp")
				require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
			end,
		},
		{
			"hrsh7th/cmp-cmdline",
			opts = {
				mapping = require("cmp").mapping.preset.cmdline(),
				sources = require("cmp").config.sources({
					{ name = "path" },
				}, {
					{
						name = "cmdline",
						option = {
							ignore_cmds = { "Man", "!" },
						},
					},
				}),
			},
			config = function(_, opts)
				require("cmp").setup.cmdline(":", opts)
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
