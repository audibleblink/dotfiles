return {
	"neovim/nvim-lspconfig",
	enabled = not vim.g.vscode,
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},

	config = function()
		-- Server-specific configurations (only non-default settings)
		local servers = {
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
			gopls = {},
		}

		-- Setup each server
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		for server, config in pairs(servers) do
			vim.lsp.config(server, { capabilities = capabilities, settings = config.settings })
		end

		-- Configure diagnostics
		local x = vim.diagnostic.severity
		vim.diagnostic.config({
			update_in_insert = false,
			signs = { text = { [x.ERROR] = "󰅙", [x.WARN] = "", [x.INFO] = "󰋼", [x.HINT] = "󰌵" } },
			virtual_text = {
				severity = { min = x.WARN },
			},
			severity_sort = true,
			underline = true,
			float = { border = "single" },
		})
	end,
}
