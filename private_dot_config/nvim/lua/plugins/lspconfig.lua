local M = {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"nvim-lua/plenary.nvim",
		"jose-elias-alvarez/null-ls.nvim",
	},
	config = function()
		local util = require("lspconfig/util")
		local lspconfig = require("lspconfig")

		-- Load NvChad defaults
		require("nvchad.configs.lspconfig").defaults()

		-- Get the on_attach function from the null-ls plugin
		local null_ls = require("plugins.null-ls")
		local null_ls_on_attach = null_ls.get_on_attach()

		-- Default server config
		local default_config = {
			on_attach = function(client, bufnr)
				-- Apply default on_attach from NvChad
				local on_attach = require("nvchad.configs.lspconfig").on_attach
				on_attach(client, bufnr)

				-- Apply null-ls formatting on save if function is available
				if null_ls_on_attach then
					null_ls_on_attach(client, bufnr)
				end
			end,
			capabilities = require("nvchad.configs.lspconfig").capabilities,
		}

		-- Language-specific configurations
		local server_configs = {
			rust_analyzer = {
				cmd = { "rust-analyzer" },
				filetypes = { "rust" },
				root_dir = util.root_pattern("Cargo.toml"),
				settings = {
					["rust-analyzer"] = {
						rustfmt = {
							extraArgs = { "+nightly" },
						},
						imports = {
							granularity = {
								group = "module",
							},
							prefix = "self",
						},
						cargo = {
							buildScripts = {
								enable = true,
							},
						},
						procMacro = {
							enable = true,
						},
					},
				},
			},

			gopls = {
				cmd = { "gopls" },
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				root_dir = util.root_pattern("go.work", "go.mod"),
				settings = {
					gopls = {
						completeUnimported = true,
						usePlaceholders = true,
					},
				},
			},

			lua_ls = {
				settings = {
					Lua = {
						diagnostics = {
							enable = true,
							globals = { "vim" },
						},
					},
				},
			},

			ruff = {
				init_options = {
					settings = {
						lineLength = 100,
						lint = {
							preview = true,
						},
						format = {
							preview = true,
						},
					},
				},
			},

			yamlls = {},
			zls = {},
		}

		-- Setup servers
		for server_name, server_config in pairs(server_configs) do
			local config = vim.tbl_deep_extend("force", default_config, server_config)
			lspconfig[server_name].setup(config)
		end
	end,
}

return M
