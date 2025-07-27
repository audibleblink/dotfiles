return {
	"williamboman/mason.nvim",
	event = "VeryLazy",
	dependencies = { "williamboman/mason-lspconfig.nvim" },

	config = function()
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"basedpyright",
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
