-- Setup null-ls module with on_attach function for formatting
local on_attach = nil

local M = {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local null_ls = require("null-ls")

		local formatting = null_ls.builtins.formatting
		local diagnostics = null_ls.builtins.diagnostics

		local sources = {
			-- Formatters
			formatting.prettier,
			-- formatting.stylua,
			formatting.gofumpt,
			formatting.goimports_reviser,
			formatting.golines,
<<<<<<< HEAD
=======
			formatting.ruff,
>>>>>>> 415f792 ((nvim) claude sonnet refactor)
			-- formatting.csharpier,
			formatting.yq,

			-- Linters
			diagnostics.yamllint,
			diagnostics.selene,
			diagnostics.ruff,
			diagnostics.golangci_lint,
			diagnostics.staticcheck,
			diagnostics.standardrb,
			diagnostics.shellcheck,
		}

		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		-- Define on_attach in module scope so it can be used by lspconfig
		on_attach = function(client, bufnr)
			if client.supports_method("textDocument/formatting") then
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
			end
		end

		null_ls.setup({
			debug = true,
			sources = sources,
			on_attach = on_attach,
		})
	end,
}

-- Function to get the on_attach function for use in other modules
function M.get_on_attach()
	return on_attach
end

return M

