return {
	"neovim/nvim-lspconfig",
	enabled = not vim.g.vscode,
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"nvim-lua/plenary.nvim",
	},

	opts = function()
		local util = require("lspconfig/util")

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

			-- gopls = {
			-- 	cmd = { "gopls" },
			-- 	filetypes = { "go", "gomod", "gowork", "gotmpl" },
			-- 	root_dir = util.root_pattern("go.work", "go.mod"),
			-- 	settings = {
			-- 		gopls = {
			-- 			usePlaceholders = true,
			-- 			analyses = {
			-- 				unusedparams = true,
			-- 			},
			-- 			staticcheck = true,
			-- 			gofumpt = true,
			-- 		},
			-- 	},
			-- },
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
			basedpyright = {
				settings = {
					basedpyright = {
						analysis = {
							disableOrganizeImports = true, -- using ruff
							typeCheckingMode = "off", -- using ruff
							-- typeCheckingMode = "standard",
							diagnosticMode = "workspace",
							useLibraryCodeForTypes = true,
						},
					},
				},
			},
			yamlls = {},
			zls = {},
		}

		return {
			server_configs = server_configs,
		}
	end,

	config = function(_, opts)
		local lspconfig = require("lspconfig")

		-- Setup servers
		for server_name, server_config in pairs(opts.server_configs) do
			local config = vim.tbl_deep_extend("force", {
				on_attach = opts.on_attach,
				capabilities = opts.capabilities,
			}, server_config)

			lspconfig[server_name].setup(config)
		end

		vim.diagnostic.config({
			update_in_insert = false, -- false so diags are updated on InsertLeave
			virtual_text = { current_line = true, severity = { min = "WARN", max = "ERROR" } },
			-- virtual_lines = { current_line = true, severity = { min = "ERROR" } },
			severity_sort = true,
			float = false,
		})
	end,
}
