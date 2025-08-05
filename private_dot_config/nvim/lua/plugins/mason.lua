return {
	"williamboman/mason.nvim",
	event = "VeryLazy",
	dependencies = { "williamboman/mason-lspconfig.nvim" },

	config = function()
		require("mason").setup({
			ui = {
				check_outdated_packages_on_open = false,
			},
		})
		require("mason-lspconfig").setup({
			ensure_installed = {
				"basedpyright",
				"denols",
				"gopls",
				"lua_ls",
				"markdown_oxide",
				"ruff",
				"rust_analyzer",
				"yamlls",
				"zls",
			},
		})
	end,
}
