return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	keys = "<Leader>",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-telescope/telescope-file-browser.nvim" },
		{ "nvim-telescope/telescope-frecency.nvim" },
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
	opts = function()
		return {
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
			extensions = {
				themes = {},
				fzf = {},
				"chezmoi",
				"frecency",
				"file-browser",
				["ui-select"] = {
					require("telescope.themes").get_dropdown({
						layout_config = {
							anchor = "N",
							prompt_position = "bottom",
							width = 0.4,
							height = 0.25,
						},
					}),
				},
			},
		}
	end,
	config = function(_, opts)
		-- config options
		local tt = require("telescope")
		local themes = require("telescope.themes")
		tt.setup(opts)

		local map = vim.keymap.set
		local ts = require("telescope.builtin")

		-- File navigation
		map("n", "<leader>fa", function()
			ts.find_files({ follow = true, no_ignore = true, hidden = true })
		end, { desc = " Find All" })

		map("n", "<leader>b", function()
			ts.buffers(themes.get_ivy({ sort_mru = true }))
		end, { desc = " - Find buffers" })

		map("n", "<leader>fs", function()
			ts.git_status({ sort_lastused = true })
		end, { desc = " - Git Status" })

		map("n", "<space>fb", function()
			tt.extensions.file_browser.file_browser(themes.get_ivy())
		end, { desc = " - File Browser", noremap = true })

		map("n", "<leader>fp", function()
			ts.find_files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") })
		end, { desc = " - Search Neovim Plugins" })

		map("n", "<leader>fo", function()
			tt.extensions.file_browser.file_browser({ cwd = "~/code" })
		end, { desc = " - Open Code repo" })

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
