return {
	"greggh/claude-code.nvim",
	cmd = "ClaudeCode",
	dependencies = {
		"nvim-lua/plenary.nvim", -- Required for git operations
	},
	opts = {
		-- Terminal window settings
		window = {
			split_ratio = 0.3, -- Percentage of screen for the terminal window (height for horizontal, width for vertical splits)
			position = "vertical", -- Position of the window: "botright", "topleft", "vertical", "rightbelow vsplit", etc.
			enter_insert = false, -- Whether to enter insert mode when opening Claude Code
			hide_numbers = true, -- Hide line numbers in the terminal window
			hide_signcolumn = true, -- Hide the sign column in the terminal window
		},
		-- Keymaps
		keymaps = {
			toggle = {
				normal = "<C-,>", -- Normal mode keymap for toggling Claude Code, false to disable
				terminal = "<C-,>", -- Terminal mode keymap for toggling Claude Code, false to disable
				variants = {
					continue = "<leader>cC", -- Normal mode keymap for Claude Code with continue flag
					verbose = "<leader>cV", -- Normal mode keymap for Claude Code with verbose flag
				},
			},
			window_navigation = false, -- Enable window navigation keymaps (<C-h/j/k/l>)
			scrolling = true, -- Enable scrolling keymaps (<C-f/b>) for page up/down
		},
	},
}
