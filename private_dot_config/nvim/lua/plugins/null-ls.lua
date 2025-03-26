-- Setup null-ls module with on_attach function for formatting
local M = {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = function()
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
			formatting.ruff,
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
		
		-- Define on_attach function for formatting on save
		local on_attach = function(client, bufnr)
			if client.supports_method("textDocument/formatting") then
				local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
				
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
		
		return {
			debug = true,
			sources = sources,
			on_attach = on_attach,
		}
	end,
	config = function(_, opts)
		require("null-ls").setup(opts)
	end,
}

-- Function to get the on_attach function for use in other modules
function M.get_on_attach()
	return M.opts().on_attach
end

return M