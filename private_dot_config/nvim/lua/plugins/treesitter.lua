return {
	{
		"OXY2DEV/markview.nvim",
		priority = 49,
		config = function()
			local presets = require("markview.presets").headings
			dofile(vim.g.base46_cache .. "markview")
			require("markview").setup({
				markdown = {
					headings = presets.simple,
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		branch = "main",
		build = ":TSUpdate",
		opts = {
			-- web dev
			"html",
			"css",
			"javascript",
			"typescript",
			"tsx",
			"json",
			"vue",
			"svelte",

			-- other
			"base",
			"c",
			"go",
			"rust",
			"glsl",
			"ruby",
			"typst",
			"python",
			"lua",
			"hcl",
			"terraform",
			"markdown",
			"markdown_inline",
			"luadoc",
			"printf",
			"regex",
			"vim",
			"vimdoc",
			"yaml",
		},

		config = function(_, opts)
			require("nvim-treesitter").install(opts)
			require("nvim-treesitter").setup()

			-- Auto load tree-sitter if we have parser
			vim.api.nvim_create_autocmd("FileType", {
				desc = "Load tree-sitter for supported file types",
				pattern = opts,
				callback = function()
					vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					vim.treesitter.start()
				end,
			})
		end,
	},
}
