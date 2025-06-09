function Fd(file_pattern, _)
	-- if first char is * then fuzzy search
	if file_pattern:sub(1, 1) == "*" then
		file_pattern = file_pattern:gsub(".", ".*%0") .. ".*"
	end
	local cmd = 'fd  --color=never --full-path --type file --hidden --exclude=".git" --exclude="deps" "'
			.. file_pattern
			.. '"'
	local result = vim.fn.systemlist(cmd)
	return result
end

vim.opt.findfunc = "v:lua.Fd"
vim.keymap.set("n", "<C-p>", ":find ", { desc = "raw-dog: Project Files" })

return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	config = function()
		local cmp = require("cmp")

		cmp.setup({
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
				{ name = "cmdline" },
				{ name = "path" },
			},
		})
	end,

	dependencies = {
		-- autopairing of (){}[] etc
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
			config = function()
				local cmp = require("cmp")
				cmp.setup.cmdline(':', {
					mapping = cmp.mapping.preset.cmdline(),
					sources = cmp.config.sources({
						{ name = 'path' }
					}, {
						{
							name = 'cmdline',
							option = {
								ignore_cmds = { 'Man', '!' }
							}
						}
					})
				})
			end
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
