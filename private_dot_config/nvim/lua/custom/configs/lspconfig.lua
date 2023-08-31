local configs = require("plugins.configs.lspconfig")
local on_attach = configs.on_attach
local capabilities = configs.capabilities

local lspconfig = require "lspconfig"
local servers = {
  "html",
  "cssls",
  "clangd",
  "gopls",
  "yamlls",
  "csharp_ls",
  "sourcekit",
  "jedi_language_server",
  "ruby-lsp",
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end
