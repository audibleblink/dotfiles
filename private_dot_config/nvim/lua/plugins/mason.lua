return {
	"williamboman/mason.nvim",
	opts = {
		automatic_installation = true,
		ensure_installed = {
			-- Language Servers
			-- "clangd",
			-- "csharp-language-server",
			-- "css-lsp",
			-- "html-lsp",
			"gopls",
			"ruff",
			"lua-language-server",
			"rust-analyzer",
			"yaml-language-server",
			"zls",

			-- Linters
			-- "cppcheck",
			-- "csharpier",
			"gofumpt",
			"goimports-reviser",
			"golangci-lint",
			"golines",
			"prettier",
			"selene",
			"standardrb",
			"staticcheck",
			"stylua",
			"yq",
		},
	},
}
