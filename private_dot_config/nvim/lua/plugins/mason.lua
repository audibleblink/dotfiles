return {
	"williamboman/mason-lspconfig.nvim",
	event = "VeryLazy",
	dependencies = { "williamboman/mason.nvim" },
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
}
