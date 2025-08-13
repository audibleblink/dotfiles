local servers = {
	"basedpyright",
	"denols",
	"gopls",
	"lua_ls",
	"markdown_oxide",
	"ruff",
	"rust_analyzer",
	"tinymist",
	"yamlls",
	"zls",
}

return {
	"neovim/nvim-lspconfig",
	enabled = not vim.g.vscode,
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "mason-org/mason.nvim", opts = {
			ui = { check_outdated_packages_on_open = false },
		} },
		{ "mason-org/mason-lspconfig.nvim", opts = {
			automatic_enable = false,
			ensure_installed = servers,
		} },
	},

	config = function()
		vim.lsp.enable(servers)

		vim.lsp.config("*", {
			capabilities = require("cmp_nvim_lsp").default_capabilities(),
		})

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

			-- vim.lsp.config doesn't merge lists, so we do it here
			denols = { filetypes = vim.tbl_extend("keep", { "json", "jsonc" }, vim.lsp.config.denols.filetypes) },
		}

		for server, config in pairs(custom) do
			vim.lsp.config(server, config)
		end

		-- Configure diagnostics
		local x = vim.diagnostic.severity
		vim.diagnostic.config({
			update_in_insert = false,
			signs = { text = { [x.ERROR] = "󰅙", [x.WARN] = "", [x.INFO] = "󰋼", [x.HINT] = "󰌵" } },
			virtual_text = { current_line = true, severity = { min = x.HINT } },
			severity_sort = true,
			underline = true,
			float = { border = "single" },
			-- float = false,
			-- virtual_lines = { current_line = true, severity = { min = "ERROR" } },
		})
	end,
}
