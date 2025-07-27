return {
	"neovim/nvim-lspconfig",
	enabled = not vim.g.vscode,
	event = "VeryLazy",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},

	config = function()
		local lspconfig = require("lspconfig")
		local util = require("lspconfig.util")

		-- Common LSP configuration
		local common_config = {
			capabilities = vim.lsp.protocol.make_client_capabilities(),
		}

		-- Server-specific configurations (only non-default settings)
		local servers = {
			rust_analyzer = {
				root_dir = util.root_pattern("Cargo.toml"),
				settings = {
					["rust-analyzer"] = {
						rustfmt = { extraArgs = { "+nightly" } },
						imports = {
							granularity = { group = "module" },
							prefix = "self",
						},
						cargo = { buildScripts = { enable = true } },
						procMacro = { enable = true },
					},
				},
			},

			ruff = {
				init_options = {
					settings = {
						lineLength = 100,
						lint = { preview = true },
						format = { preview = true },
					},
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

			-- Servers with default configuration
			yamlls = {},
			zls = {},
		}

		-- Setup each server
		for server, config in pairs(servers) do
			lspconfig[server].setup(vim.tbl_deep_extend("force", common_config, config))
		end

		-- Configure diagnostics
		vim.diagnostic.config({
			update_in_insert = false,
			virtual_text = {
				severity = { min = vim.diagnostic.severity.WARN },
			},
			severity_sort = true,
			float = false,
		})
	end,
}
