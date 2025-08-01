return {
	"nvim-telescope/telescope.nvim",
	keys = "<Leader>",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-telescope/telescope-file-browser.nvim" },
		{ "nvim-telescope/telescope-frecency.nvim" },
		{ "nvim-treesitter/nvim-treesitter" },
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "nvim-tree/nvim-web-devicons" },
		{ "xvzc/chezmoi.nvim", cmd = { "ChezmoiEdit", "ChezmoiList" } },
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
	},
	cmd = "Telescope",
	opts = {
		pickers = {
			buffers = {
				theme = "dropdown",
			},
		},
		defaults = {
			prompt_prefix = "   ",
			selection_caret = " ",
			entry_prefix = " ",
			sorting_strategy = "ascending",
			layout_config = {
				horizontal = {
					prompt_position = "bottom",
					preview_width = 0.5,
				},
				width = 0.8,
				height = 0.7,
			},
			mappings = {
				n = { ["q"] = require("telescope.actions").close },
				i = { ["<esc>"] = require("telescope.actions").close },
			},
		},
		extensions = { themes = {}, "terms", fzf = {}, "ui-select", "chezmoi", "frecency", "file-browser" },
	},
	config = function(_, opts)
		-- config options
		local tt = require("telescope")
		tt.setup(opts)

		require("telescope").load_extension("fzf")
		local map = vim.keymap.set
		local ts = require("telescope.builtin")

		-- File navigation
		map("n", "<leader>fa", function()
			ts.find_files({ follow = true, no_ignore = true, hidden = true })
		end, { desc = " Find All" })

		map("n", "<leader>fb", function()
			ts.buffers({ ignore_current_buffer = true, sort_mru = true })
		end, { desc = " - Find buffers" })

		map("n", "<leader>fs", function()
			ts.git_status({ sort_lastused = true })
		end, { desc = " - Git Status" })

		map("n", "<space>fo", function()
			local themes = require("telescope.themes")
			tt.extensions.file_browser.file_browser(themes.get_ivy())
		end, { desc = " File Browser", noremap = true })

		map("n", "<leader>fp", function()
			ts.find_files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") })
		end, { desc = " - Search Neovim Plugins" })

		map("n", "<leader>fc", ts.git_bcommits, { desc = " Git buffer history" })
		map("n", "<leader>fC", ts.git_commits, { desc = " Git commits" })
		map("n", "<leader>cm", tt.extensions.chezmoi.find_files, { desc = " Chezmoi" })
		map("n", "<leader>ff", ts.find_files, { desc = " Find files" })
		map("n", "<leader>fr", tt.extensions.frecency.frecency, { desc = " Find oldfiles" })
		map("n", "<leader>fz", ts.current_buffer_fuzzy_find, { desc = " Find in current buffer" })
		map("n", "<leader>fw", ts.live_grep, { desc = " Live grep" })
		map("n", "<leader>fh", ts.help_tags, { desc = " Help page" })
		map("n", "<leader>fm", ts.keymaps, { desc = " Keymaps" })
		map("n", "<leader><leader>", ts.resume, { desc = " Reopen" })
	end,
}
