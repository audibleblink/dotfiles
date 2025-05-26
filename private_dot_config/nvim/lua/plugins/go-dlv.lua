-- Setup null-ls module with on_attach function for formatting
local M = {
	'leoluz/nvim-dap-go',
	dependencies = {
		'mfussenegger/nvim-dap' ,
		'rcarriga/nvim-dap-ui' ,
		'nvim-neotest/nvim-nio' ,
	},
	opts = function()
		local dap_go = require('dap-go')
		local dap = require('dap')
		local dap_ui = require('dapui')

		dap_go.setup()
		-- For One
		table.insert(dap.configurations.go, {
			type = 'delveone',
			name = 'One CONTAINER debugging',
			mode = 'remote',
			request = 'attach',
			substitutePath = {
				{ from = '/opt/homebrew/Cellar/go/1.23.1/libexec', to = '/usr/local/go'},
				{ from = '${workspaceFolder}', to = '/path/in/container' },
			},
		})

		-- For Two
		table.insert(dap.configurations.go, {
			type = 'delvetwo',
			name = 'Two CONTAINER debugging',
			mode = 'remote',
			request = 'attach',
			substitutePath = {
				{ from = '/opt/homebrew/Cellar/go/1.23.1/libexec', to = '/usr/local/go'},
				{ from = '${workspaceFolder}', to = '/path/in/contianer' },
			},
		})

		-- adapters configuration
		dap.adapters.delveone = {
			type = 'server',
			host = '127.0.0.1',
			port = '2345'
		}

		dap.adapters.delvetwo = {
			type = 'server',
			host = '127.0.0.1',
			port = '2346'
		}


		dap_ui.setup({
			layouts = {
				{
					elements = {
						{
							id = "scopes",
							size = 0.35
						},
						{
							id = "breakpoints",
							size = 0.30,
						},
						{
							id = "repl",
							size = 0.35,
						},
					},
					position = "right",
					size = 50,
				},
			},
		})
	end,
}


return M
