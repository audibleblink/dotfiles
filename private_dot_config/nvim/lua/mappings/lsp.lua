-- LSP related mappings

local map = vim.keymap.set
local vim = vim

-- Navigation
map('n', 'gr', vim.lsp.buf.references, { desc = "Show References" })
map('n', 'gd', vim.lsp.buf.definition, { desc = "Go to Definition" })
map('n', 'ga', vim.lsp.buf.rename, { desc = "Rename Symbol" })

-- Diagnostics
map("n", "<leader>lf", vim.diagnostic.open_float, { desc = "Lsp floating diagnostics" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Lsp diagnostic loclist" })

-- Go to previous diagnostic
map("n", "[d", function()
	vim.diagnostic.jump({ count = -1 })
end, { desc = "Lsp prev diagnostic" })

-- Go to next diagnostic
map("n", "]d", function()
	vim.diagnostic.jump({ count = 1 })
end, { desc = "Lsp next diagnostic" })

-- Log level
vim.lsp.set_log_level(vim.log.levels.WARN)

vim.diagnostic.config({
	signs = { priority = 9999 },
	underline = true,
	update_in_insert = false, -- false so diags are updated on InsertLeave
	virtual_text = { current_line = true, severity = { min = "INFO", max = "WARN" } },
	virtual_lines = { current_line = true, severity = { min = "ERROR" } },
	severity_sort = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = true,
		header = "",
	},
})
