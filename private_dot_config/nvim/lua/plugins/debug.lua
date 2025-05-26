return {
	"mfussenegger/nvim-dap",
	keys = {
		{
			"<leader>dc",
			function()
				require("dap").continue()
			end,
			desc = "Debug: Start/Continue",
		},
		{
			"<leader>di",
			function()
				require("dap").step_into()
			end,
			desc = "Debug: Step Into",
		},
		{
			"<leader>ds",
			function()
				require("dap").step_over()
			end,
			desc = "Debug: Step Over",
		},
		{
			"<leader>du",
			function()
				require("dap").step_out()
			end,
			desc = "Debug: Step Out",
		},
		{
			"<leader>db",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Debug: Toggle Breakpoint",
		},
		{
			"<leader>dB",
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			desc = "Debug: Set Breakpoint",
		},
		-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
		{
			"<leader>dt",
			function()
				require("dapui").toggle()
			end,
			desc = "Debug: See last session result.",
		},
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		-- Dap UI setup
		-- For more information, see |:help nvim-dap-ui|
		dapui.setup({
			icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
			controls = {
				icons = {
					pause = "⏸",
					play = "▶",
					step_into = "⏎",
					step_over = "⏭",
					step_out = "⏮",
					step_back = "b",
					run_last = "▶▶",
					terminate = "⏹",
					disconnect = "⏏",
				},
			},
		})

		-- Change breakpoint icons
		vim.api.nvim_set_hl(0, "DapBreak", { fg = "#e51400" })
		vim.api.nvim_set_hl(0, "DapStop", { fg = "#ffcc00" })
		local breakpoint_icons = vim.g.have_nerd_font
				and {
					Breakpoint = "",
					BreakpointCondition = "",
					BreakpointRejected = "",
					LogPoint = "",
					Stopped = "",
				}
			or {
				Breakpoint = "●",
				BreakpointCondition = "⊜",
				BreakpointRejected = "⊘",
				LogPoint = "◆",
				Stopped = "⭔",
			}
		for type, icon in pairs(breakpoint_icons) do
			local tp = "Dap" .. type
			local hl = (type == "Stopped") and "DapStop" or "DapBreak"
			vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
		end

		dap.listeners.after.event_initialized["dapui_config"] = dapui.open
		dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		dap.listeners.before.event_exited["dapui_config"] = dapui.close

		-- Add new debuggers below here

		-- ensure the DAP-compatible debuggers are installed
		require("mason-nvim-dap").setup({
			automatic_installation = true,
			handlers = {},
			ensure_installed = {
				"delve", -- golang
				"debugpy", -- python
				-- "codelldb",	-- rust, c, cpp, zig
				-- "js-debug-adapter", -- microsoft's javascript DA
			},
		})

		-- Setup dependencies from below
		require("dap-python").setup("uv")
		require("dap-go").setup({
			-- On Windows delve must be run attached or it crashes.
			-- https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
			delve = { detached = vim.fn.has("win32") == 0 },
		})
	end,

	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"mason-org/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",
		"theHamsta/nvim-dap-virtual-text",
		-- Add new nvim/dap providers here
		"leoluz/nvim-dap-go",
		"mfussenegger/nvim-dap-python",
	},
}
