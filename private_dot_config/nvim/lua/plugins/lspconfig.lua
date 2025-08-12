return {
	"neovim/nvim-lspconfig",
	enabled = not vim.g.vscode,
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "mason-org/mason.nvim" },

	config = function()
		local lspconfig = require("lspconfig")
		local installed = require("mason-lspconfig").get_installed_servers()

		-- Server-specific configurations (only non-default settings)
		local custom = {
			ruff = {
				settings = {
					lineLength = 100,
					lint = { preview = true },
					format = { preview = true },
				},
			},

			basedpyright = {
				settings = {
					basedpyright = {
						analysis = {
							disableOrganizeImports = true, -- using ruff
							typeCheckingMode = "off", -- using ruff
							diagnosticMode = "workspace",
							useLibraryCodeForTypes = true,
						},
					},
				},
			},
			denols = { filetypes = { "json", "jsonc" } },
		}

		-- Setup each server
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		for _, server in ipairs(installed) do
			local config = custom[server] or {}
			local merged = vim.tbl_deep_extend("force", config, { capabilities = capabilities })

			-- using lspconfig's setup over vim.lsp.config ensures passing empty tables
			-- still uses the defaults provided by lspconfig
			lspconfig[server].setup(merged)
		end

		--
		-- Configure diagnostics
		local x = vim.diagnostic.severity
		vim.diagnostic.config({
			update_in_insert = false,
			signs = { text = { [x.ERROR] = "󰅙", [x.WARN] = "", [x.INFO] = "󰋼", [x.HINT] = "󰌵" } },
			virtual_text = { current_line = true, severity = { min = x.WARN } },
			severity_sort = true,
			underline = true,
			float = { border = "single" },
			-- float = false,
			-- virtual_lines = { current_line = true, severity = { min = "ERROR" } },
		})
	end,
}
