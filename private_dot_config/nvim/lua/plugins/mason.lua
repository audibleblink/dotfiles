return {
	"mason-org/mason-lspconfig.nvim",
	event = "VeryLazy",
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		{ "neovim/nvim-lspconfig" },
	},

	opts = {
		automatic_enable = false,
		ensure_installed = {
			"basedpyright",
			"denols",
			"gopls",
			"lua_ls",
			"markdown_oxide",
			"ruff",
			"rust_analyzer",
			"tinymist",
			"yamlls",
			"zls",
		},
	},

	config = function(_, opts)
		require("mason").setup({ ui = { check_outdated_packages_on_open = false } })
		require("mason-lspconfig").setup(opts)
	end,
}
