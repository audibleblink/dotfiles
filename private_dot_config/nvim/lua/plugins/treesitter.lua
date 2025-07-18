return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile" },
	cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
	build = ":TSUpdate",
	opts = {
		ensure_installed = {
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
		},
		highlight = {
			enable = true,
			use_languagetree = true,
		},

		indent = { enable = true },
	},
}
