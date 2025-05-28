return {
	{
		"NvChad/NvChad",
		lazy = false,
		branch = "v2.5",
		import = "nvchad.plugins",
	},
	{ "numToStr/Comment.nvim" },
	{ "someone-stole-my-name/yaml-companion.nvim" },
	{ "Darazaki/indent-o-matic", lazy = false },

	-- override nvchad
	{ "L3MON4D3/LuaSnip", enabled = false },
	{ "nvzone/volt", enabled = false },
	{ "nvzone/minty", enabled = false },
	{ "nvzone/menu", enabled = false },
}
