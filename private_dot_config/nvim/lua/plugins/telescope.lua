return {
	"nvim-telescope/telescope.nvim",
	keys = "<Leader>",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-treesitter/nvim-treesitter" },
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "nvim-tree/nvim-web-devicons" },
		{ "xvzc/chezmoi.nvim",                      cmd = { "ChezmoiEdit", "ChezmoiList" } },
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
	},
	cmd = "Telescope",
	config = function()
		-- config options
		local tt = require("telescope")
		tt.setup({
			defaults = {
				prompt_prefix = "   ",
				selection_caret = " ",
				entry_prefix = " ",
				sorting_strategy = "ascending",
				layout_config = {
					horizontal = {
						prompt_position = "bottom",
						preview_width = 0.55,
					},
					width = 0.80,
					height = 0.60,
				},
				mappings = {
					n = { ["q"] = require("telescope.actions").close },
					i = { ["<esc>"] = require("telescope.actions").close },
				},
			},
			extensions_list = { "themes", "terms" },
			extensions = {},
		})

		pcall(tt.load_extension, "fzf")
		pcall(tt.load_extension, "ui-select")
		pcall(tt.load_extension, "chezmoi")

		local map = vim.keymap.set
		local ts = require("telescope.builtin")

		-- File navigation
		map("n", "<leader>fa", function()
			ts.find_files({
				follow = true,
				no_ignore = true,
				hidden = true,
			})
		end, { desc = " Find All" })

		map("n", "<leader>fb", function()
			ts.buffers({ ignore_current_buffer = true, sort_mru = true, previewer = false })
		end, { desc = " - Find buffers" })


		map("n", "<leader>gc", function() ts.git_commits({ initial_mode = "normal" }) end, { desc = " Git commits" })
		map("n", "<leader>gs", function() ts.git_status({ initial_mode = "normal" }) end, { desc = " Git status" })
		map("n", "<leader>cm", tt.extensions.chezmoi.find_files, { desc = " Chezmoi" })
		map("n", "<leader>ff", ts.find_files, { desc = " Find files" })
		map("n", "<leader>fo", ts.oldfiles, { desc = " Find oldfiles" })
		map("n", "<leader>fz", ts.current_buffer_fuzzy_find, { desc = " Find in current buffer" })
		map("n", "<leader>fw", ts.live_grep, { desc = " Live grep" })
		map("n", "<leader>fh", ts.help_tags, { desc = " Help page" })
		map("n", "<leader>fm", ts.keymaps, { desc = " Keymaps" })
		map("n", "<leader><leader>", ts.resume, { desc = " Reopen" })
	end,
}
