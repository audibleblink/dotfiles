return {
	"williamboman/mason-lspconfig.nvim",
	dependencies = {
		"williamboman/mason.nvim",
		-- opts = {
		-- 	automatic_installation = true,
		-- },
	},
	opts = {
		automatic_installation = true,
		ensure_installed = {
			-- Language Servers
			-- "clangd",
			-- "csharp_language_server",
			-- "css_lsp",
			-- "html_lsp",
			"lua_ls",
			"basedpyright",
			"gopls",
			"ruff",
			"rust_analyzer",
			"yamlls",
			"zls",
		},
	},
}
