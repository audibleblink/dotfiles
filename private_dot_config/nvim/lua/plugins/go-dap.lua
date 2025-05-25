-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)
--[[
  kickstart.plugins.debug: Sets up debugging tools within Neovim, possibly using plugins like nvim-dap. This includes configurations for connecting to debuggers, setting breakpoints, watching variables, and navigating through the call stack.
]]

return {
  -- nvim-dap-ui
  {
    'rcarriga/nvim-dap-ui',
    dependencies = {
      'mfussenegger/nvim-dap',
      'nvim-neotest/nvim-nio',
    },
    ft = "go",
    opts = {
      layouts = {
        {
          elements = {
            { id = "scopes",      size = 0.33 },
            { id = "stacks",      size = 0.33 },
            { id = "breakpoints", size = 0.33 },
          },
          position = "right",
          size = 30
        },
        {
          elements = {
            { id = "watches", size = 0.33 },
            { id = "repl",    size = 0.33 },
            { id = "console", size = 0.33 }
          },
          position = "bottom",
          size = 10
        }
      },
    },
    config = function()
      require('dapui').setup()
    end,
  },

  -- nvim-dap
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      "nvim-telescope/telescope-dap.nvim",
      "theHamsta/nvim-dap-virtual-text",
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
      'leoluz/nvim-dap-go',
    },
    ft = "go",
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'
      local dapgo = require 'dap-go'

      require('telescope').load_extension('dap')
      require("nvim-dap-virtual-text").setup()

      -- Go debugger
      dapgo.setup()

      require('mason').setup()
      require('mason-nvim-dap').setup {
        automatic_installation = true,
        handlers = {},
        ensure_installed = {
          'delve',
          'debugpy',
          'bash-debug-adapter',
          'chrome-debug-adapter',
          'codeLLdb',
          'firefox-debug-adapter',
          'go-debug-adapter',
          'js-debug-adapter',
          'node-debug2-adapter',
          'php-debug',
        },
      }

      -- Dap UI setup
      dapui.setup {
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
          icons = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = 'b',
            run_last = '▶▶',
            terminate = '⏹',
            disconnect = '⏏',
          },
        },
      }

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close

      local map = vim.keymap.set

      map("n", "<space>du", "<cmd>DapUiToggle<CR>", {})
      map("n", "<space>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
      map("n", "<space>dt", "<cmd>DapTerminate<cr>", { desc = "Debuger Terminate" })
      map("n", "<space>dgc", dap.continue, { desc = "Debuger Continue" })
      map("n", "<space>dgi", dap.step_into, { desc = "Step Into" })
      map("n", "<space>dgn", dap.step_over, { desc = "Step Over" })
      map("n", "<space>dgo", dap.step_out, { desc = "Step Out" })
      map("n", "<space>dgg", dap.run_to_cursor, { desc = "Run to Cursor" })

      map("n", "<space>d?", function()
        dapui.eval(nil, { enter = true })
      end, { desc = "Eval var under cursor" })

      map("n", "<space>dgt", function()
        dapgo.debug_test()
      end, { desc = "Debug go test" })

      map("n", "<space>dgl", function()
        dapgo.debug_last()
      end, { desc = "Debug last go test" })

      vim.fn.sign_define(
        "DapBreakpoint",
        { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
      )
    end,
  },
}
