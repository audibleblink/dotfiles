return {
	"someone-stole-my-name/yaml-companion.nvim",
	requires = {
		{ "neovim/nvim-lspconfig" },
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-telescope/telescope.nvim" },
	},
	ft = { "yaml", "yml" },
	opts = {},
	config = function(_, opts)
		require("yaml-companion").setup(opts)
		require("telescope").load_extension("yaml_schema")
	end,
}
