return {
	"nvim-telescope/telescope.nvim",
	lazy = false,
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-treesitter/nvim-treesitter" },
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "nvim-tree/nvim-web-devicons",            enabled = true },
		{ "xvzc/chezmoi.nvim" },
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable "make" == 1
			end,
		},
	},
	cmd = "Telescope",
	config = function()
		-- config options
		require("telescope").setup({
			defaults = {
				prompt_prefix = "   ",
				selection_caret = " ",
				entry_prefix = " ",
				sorting_strategy = "ascending",
				layout_config = {
					horizontal = {
						prompt_position = "top",
						preview_width = 0.55,
					},
					width = 0.87,
					height = 0.80,
				},
				mappings = {
					n = { ["q"] = require("telescope.actions").close },
					i = { ["<esc>"] = require("telescope.actions").close },
				},
			},
			extensions_list = { "themes", "terms" },
			extensions = {},
		})

		pcall(require('telescope').load_extension, 'fzf')
		pcall(require('telescope').load_extension, 'ui-select')
		pcall(require('telescope').load_extension, 'chezmoi')

		local map = vim.keymap.set
		local ts = require('telescope.builtin')

		-- File navigation
		map('n', '<leader>fa', function()
			ts.find_files {
				follow = true,
				no_ignore = true,
				hidden = true,
			}
		end, { desc = 'Telescope Find All' })

		map("n", "<leader>b", function()
			ts.buffers({ignore_current_buffer = true, sort_mru = true})
		end, { desc = "Telescope - Find buffers" })
		map('n', '<leader>cm', require("telescope").extensions.chezmoi.find_files, { desc = 'Chezmoi' })
		map("n", "<leader>ff", ts.find_files, { desc = "Telescope Find files" })
		map("n", "<leader>fo", ts.oldfiles, { desc = "Telescope Find oldfiles" })
		map("n", "<leader>fz", ts.current_buffer_fuzzy_find, { desc = "Telescope Find in current buffer" })
		map("n", "<leader>fw", ts.live_grep, { desc = "Telescope Live grep" })
		map("n", "<leader>fh", ts.help_tags, { desc = "Telescope Help page" })
		map("n", "<leader>gc", ts.git_commits, { desc = "Telescope Git commits" })
		map("n", "<leader>gs", ts.git_status, { desc = "Telescope Git status" })
		map("n", "<leader>fm", ts.keymaps, { desc = "Telescope Keymaps" })
		map("n", "<leader><leader>", ts.resume, { desc = "Telescope Reopen" })
	end
}
