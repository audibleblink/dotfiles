-- new version just places lsp configs in vim's $rtp/lsp. nice.
-- use neovim's builtin lsp api to load
return {
	"neovim/nvim-lspconfig",
	enabled = not vim.g.vscode,
	event = { "BufReadPre", "BufNewFile" },
	dependencies = "mason-org/mason.nvim", -- not really, but nice to have in one file

	config = function()
		vim.lsp.enable({
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
		})

		vim.lsp.config("*", {
			capabilities = require("cmp_nvim_lsp").default_capabilities(),
		})

		--  Non-default LSP settings
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
							disableOrganizeImports = true, -- address conflict ruff
							typeCheckingMode = "off", -- ditto
							diagnosticMode = "workspace",
							useLibraryCodeForTypes = true,
						},
					},
				},
			},

			-- vim.lsp.config (vim.tbl_deep_extend) doesn't merge lists, so we do it here
			denols = { filetypes = vim.tbl_extend("keep", { "json", "jsonc" }, vim.lsp.config.denols.filetypes) },
		}

		for server, config in pairs(custom) do
			vim.lsp.config(server, config)
		end

		local x = vim.diagnostic.severity
		vim.diagnostic.config({
			update_in_insert = false,
			signs = { text = { [x.ERROR] = "󰅙", [x.WARN] = "", [x.INFO] = "󰋼", [x.HINT] = "󰌵" } },
			virtual_text = { current_line = true, severity = { min = x.HINT } },
			severity_sort = true,
			underline = true,
			float = { border = "single" },
		})
	end,
}
