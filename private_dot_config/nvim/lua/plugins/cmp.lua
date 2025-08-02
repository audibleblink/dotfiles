-- dofile(vim.g.base46_cache .. "cmp")
return {
	{
		"hrsh7th/nvim-cmp",
		-- event = "InsertEnter",
		dependencies = { "L3MON4D3/LuaSnip" },
		config = function()
			require("cmp").setup({
				completion = { completeopt = "menu,menuone" },
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				preselect = require("cmp").PreselectMode.Item,
				mapping = {
					["<C-Space>"] = require("cmp").mapping.complete(),
					["<CR>"] = require("cmp").config.disable,
					["<C-p>"] = require("cmp").mapping.select_prev_item(),
					["<C-n>"] = require("cmp").mapping.select_next_item(),
					["<C-d>"] = require("cmp").mapping.scroll_docs(-4),
					["<C-f>"] = require("cmp").mapping.scroll_docs(4),
					["<C-e>"] = require("cmp").mapping.close(),
					["<C-l>"] = require("cmp").mapping.confirm({ select = true }),
				},

				sources = {
					{ name = "nvim_lsp" },
					{ name = "copilot" },
					{ name = "buffer" },
					{ name = "nvim_lua" },
					{ name = "luasnip" },
					{ name = "path" },
				},
			})
		end,
	},
	{
		"windwp/nvim-autopairs",
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
	{
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
	},
}
