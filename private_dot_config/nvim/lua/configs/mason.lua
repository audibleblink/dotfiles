local opts = {
  automatic_installation = true,
  ensure_installed = {
    -- Language Servers
    "clangd",
    "csharp-language-server",
    "css-lsp",
    "gopls",
    "html-lsp",
    "jedi-language-server",
    "lua-language-server",
    "rust-analyzer",
    "selene",
    "yaml-language-server",

    -- Linters
    "prettier",
    "stylua",
    "gofumpt",
    "goimports-reviser",
    "golines",
    "csharpier",
    "yq",
    "flake8",
    "cppcheck",
    "standardrb",
  }
}

return opts
