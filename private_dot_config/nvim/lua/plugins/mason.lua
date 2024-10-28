return {
	"williamboman/mason.nvim",
	opts = {
		automatic_installation = true,
		ensure_installed = {
			-- Language Servers
			-- "clangd",
			-- "csharp-language-server",
			-- "css-lsp",
			"gopls",
			-- "html-lsp",
			"jedi-language-server",
			"lua-language-server",
			"rust-analyzer",
			"yaml-language-server",
			"zls",

			-- Linters
			-- "cppcheck",
			-- "csharpier",
			"flake8",
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
