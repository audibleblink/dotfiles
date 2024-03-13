require("nvchad.configs.lspconfig").defaults()
-- local configs = require("configs")
--
-- local on_attach = configs.on_attach
-- local capabilities = configs.capabilities

local util = require("lspconfig/util")
local lspconfig = require("lspconfig")
local servers = {
	"html",
	"cssls",
	"clangd",
	"gopls",
	"yamlls",
	"csharp_ls",
	"sourcekit",
	"jedi_language_server",
	"rubocop",
}

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

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
