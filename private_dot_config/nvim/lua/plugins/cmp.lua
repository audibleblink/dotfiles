local cmp = require("cmp")
return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	opts = {
		completion = { completeopt = "menu,menuone" },
		preselect = cmp.PreselectMode.Item,
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

			["<C-l>"] = cmp.mapping.confirm({ select = true }),
		},

		sources = {
			{ name = "nvim_lsp" },
			{ name = "copilot" },
			{ name = "buffer" },
			{ name = "nvim_lua" },
			{ name = "luasnip" },
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
				cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
			end,
		},
		{
			"hrsh7th/cmp-cmdline",
			opts = {
				mapping = cmp.mapping.preset.cmdline({
					["<C-l>"] = {
						c = function(fallback)
							if cmp.visible() then
								cmp.confirm()
							else
								fallback()
							end
						end,
					},
				}),
				sources = cmp.config.sources({
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
				cmp.setup.cmdline(":", opts)
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
