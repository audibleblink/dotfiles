local null_ls = require("null-ls")

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local lint = null_ls.builtins.diagnostics

local sources = {
	formatting.prettier,
	formatting.stylua,
	formatting.gofumpt,
	formatting.goimports_reviser,
	formatting.golines,
	-- formatting.csharpier,
	formatting.yq,

	diagnostics.yamllint,
	diagnostics.selene,
	diagnostics.flake8,
	diagnostics.golangci_lint,
	diagnostics.staticcheck,
	diagnostics.cppcheck,
	diagnostics.standardrb,

	lint.shellcheck,
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
	debug = true,
	sources = sources,

	on_attach = function(client, bufnr)
		vim.api.nvim_clear_autocmds({
			group = augroup,
			buffer = bufnr,
		})

		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({ bufnr = bufnr })
			end,
		})
	end,
})
