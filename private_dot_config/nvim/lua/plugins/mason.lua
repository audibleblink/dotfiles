return {
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
		},
		opts = {
			automatic_installation = true,
			ensure_installed = {
				-- Language Servers
				-- "clangd",
				-- "csharp_language_server",
				-- "css_lsp",
				-- "html_lsp",
				"basedpyright",
				"gopls",
				"lua_ls",
				"markdown_oxide",
				"ruff",
				"rust_analyzer",
				"yamlls",
				"zls",
			},
		},
		config = function(_, opts)
			require("mason").setup()
			require("mason-lspconfig").setup(opts)
		end,
	},
}
