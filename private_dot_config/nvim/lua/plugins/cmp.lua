return {
	{ "L3MON4D3/LuaSnip", dependencies = "rafamadriz/friendly-snippets" },
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = { "L3MON4D3/LuaSnip" },
		opts = function()
			local cmp = require("cmp")
			return {
				experimental = { ghost_text = true },
				performance = {
					debounce = 500,
					max_view_entries = 9,
				},
				completion = {
					completeopt = "menuone,fuzzy,nosort",
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				preselect = cmp.PreselectMode.None,
				mapping = {
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.config.disable,
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-e>"] = cmp.mapping.close(),
					["<C-l>"] = cmp.mapping.confirm({ select = true }),

					["<Tab>"] = cmp.mapping(function(fallback)
						local status_ok, luasnip = pcall(require, "luasnip")
						if status_ok and luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						local status_ok, luasnip = pcall(require, "luasnip")
						if status_ok and luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				},

				sources = {
					{ name = "copilot", group_index = 1, priority = 1 },
					{ name = "nvim_lsp", group_index = 1 },
					{ name = "nvim_lua", group_index = 1 },
					{ name = "path", group_index = 1 },
					{ name = "luasnip", group_index = 1, keyword_length = 2 },
					{ name = "nvim_lsp_signature_help" },
					-- { name = "lazydev", group_index = 0 },
					{ name = "buffer", group_index = 2 },
				},
			}
		end,
		config = function(_, opts)
			local options = vim.tbl_deep_extend("force", opts, require("nvchad.cmp"))
			require("cmp").setup(options)
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		dependencies = { "hrsh7th/nvim-cmp" },
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
		event = "InsertEnter",
		dependencies = { "hrsh7th/nvim-cmp" },
		config = function()
			require("cmp").setup.cmdline(":", {
				mapping = require("cmp").mapping.preset.cmdline({
					["<C-l>"] = {
						c = function(fallback)
							if require("cmp").visible() then
								require("cmp").confirm()
							else
								fallback()
							end
						end,
					},
				}),
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
			})
		end,
	},
	{ "saadparwaiz1/cmp_luasnip", event = "InsertEnter" },
	{ "hrsh7th/cmp-nvim-lua", event = "InsertEnter" },
	{ "hrsh7th/cmp-nvim-lsp", event = "InsertEnter" },
	{ "hrsh7th/cmp-buffer", event = "InsertEnter" },
	{ "hrsh7th/cmp-path", event = "InsertEnter" },
	{ "hrsh7th/cmp-nvim-lsp-signature-help", event = "InsertEnter" },
}
