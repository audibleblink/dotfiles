require("nvchad.configs.lspconfig").defaults()

local util = require("lspconfig/util")
local lspconfig = require("lspconfig")
local servers = {
	-- "html",
	-- "cssls",
	-- "clangd",
	"gopls",
	"yamlls",
	-- "csharp_ls",
	-- "sourcekit",
	"jedi_language_server",
	-- "rubocop",
	"rust_analyzer",
}

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

lspconfig.rust_analyzer.setup({
	cmd = { "rust-analyzer" },
	filetypes = { "rs" },
	root_dir = util.root_pattern("Cargo.toml"),
	settings = {
		["rust-analyzer"] = {
			rustfmt = {
				extraArgs = { "+nightly" },
			},
			imports = {
				granularity = {
					group = "module",
				},
				prefix = "self",
			},
			cargo = {
				buildScripts = {
					enable = true,
				},
			},
			procMacro = {
				enable = true,
			},
		},
	},
})

lspconfig.gopls.setup({
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_dir = util.root_pattern("go.work", "go.mod"),
	settings = {
		gopls = {
			completeUnimported = true,
			usePlaceholders = true,
		},
	},
})
