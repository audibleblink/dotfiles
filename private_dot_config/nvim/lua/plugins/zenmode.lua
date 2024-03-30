return {
	"folke/zen-mode.nvim",
	cmd = "ZenMode",
	keys = {
		{ "<leader>zn", "<cmd> ZenMode <CR>", desc = "Toggle ZenMode" },
	},
	opts = {
		window = {
			backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
			-- height and width can be:
			-- * an absolute number of cells when > 1
			-- * a percentage of the width / height of the editor when <= 1
			-- * a function that returns the width or the height
			width = function()
				return math.min(80, vim.o.columns * 0.75)
			end,
			height = 0.9, -- height of the Zen window
			-- by default, no options are changed for the Zen window
			-- uncomment any of the options below, or add other vim.wo options you want to apply
			options = {
				signcolumn = "no", -- disable signcolumn
				number = false, -- disable number column
				relativenumber = false, -- disable relative numbers
				cursorline = false, -- disable cursorline
				cursorcolumn = false, -- disable cursor column
				foldcolumn = "0", -- disable fold column
				colorcolumn = "0",
				-- list = false, -- disable whitespace characters
			},
		},
		plugins = {
			-- disable some global vim options (vim.o...)
			-- comment the lines to not apply the options
			options = {
				enabled = true,
				ruler = true, -- disables the ruler text in the cmd line area
				showcmd = true, -- disables the command in the last line of the screen
				-- you may turn on/off statusline in zen mode by setting 'laststatus'
				-- statusline will be shown only if 'laststatus' == 3
				laststatus = 1, -- turn off the statusline in zen mode
			},
			twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
			gitsigns = { enabled = true }, -- disables git signs
			tmux = { enabled = true }, -- disables the tmux statusline
			-- this will change the font size on kitty when in zen mode
			-- to make this work, you need to set the following kitty options:
			-- - allow_remote_control socket-only
			-- - listen_on unix:/tmp/kitty
			kitty = {
				enabled = true,
				font = "+6", -- font size increment
			},
			-- this will change the font size on alacritty when in zen mode
			-- requires  Alacritty Version 0.10.0 or higher
			-- uses `alacritty msg` subcommand to change font size
			alacritty = {
				enabled = false,
				font = "14", -- font size
			},
			-- this will change the font size on wezterm when in zen mode
			-- See alse also the Plugins/Wezterm section in this projects README
			wezterm = {
				enabled = false,
				-- can be either an absolute font size or the number of incremental steps
				font = "+4", -- (10% increase per step)
			},
		},
		-- callback where you can add custom code when the Zen window opens
		on_open = function(win)
			vim.o.colorcolumn = "0"
		end,
		-- callback where you can add custom code when the Zen window closes
		on_close = function() end,
	},
}
