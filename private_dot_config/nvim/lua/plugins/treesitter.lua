-- Global because I use this to enable TS for these types
-- in an autocmd in init.lua
_G.treesitter = {
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
	"vim",
	"vimdoc",
	"yaml",
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			{ -- not really a dep, but resolves load order issues
				"OXY2DEV/markview.nvim",
				config = function()
					local presets = require("markview.presets").headings
					dofile(vim.g.base46_cache .. "markview")
					require("markview").setup({
						markdown = {
							headings = presets.arrowed,
						},
					})
				end,
			},
		},
		lazy = false,
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
		branch = "main",
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")
			ts.setup()
			ts.install(_G.treesitter)
		end,
	},
}
