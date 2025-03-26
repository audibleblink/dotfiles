-- LSP related mappings

local map = vim.keymap.set
local vim = vim

-- Navigation
map('n', 'gr', vim.lsp.buf.references, { desc = "Show References" } )
map('n', 'gd', vim.lsp.buf.definition, { desc = "Go to Definition" } )
map('n', 'ga', vim.lsp.buf.rename, { desc = "Rename Symbol" } )

-- Diagnostics
map("n", "<leader>lf", vim.diagnostic.open_float, { desc = "Lsp floating diagnostics" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Lsp prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Lsp next diagnostic" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Lsp diagnostic loclist" })