return {
	{ "sindrets/diffview.nvim" },
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		config = function()
			require("gitsigns").setup({
				signs = {
					delete = { text = "󰍵" },
					changedelete = { text = "󱕖" },
				},
				on_attach = function(bufnr)
					local gitsigns = require("gitsigns")

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map("n", "]g", function()
						if vim.wo.diff then
							vim.cmd.normal({ "]g", bang = true })
						else
							gitsigns.nav_hunk("next")
						end
					end, { desc = "[Git] Next Hunk" })

					map("n", "[g", function()
						if vim.wo.diff then
							vim.cmd.normal({ "[g", bang = true })
						else
							gitsigns.nav_hunk("prev")
						end
					end, { desc = "[Git] Prev Hunk" })

					-- Actions

					map("v", "<leader>gs", function()
						gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "[Git] Stage Hunk" })

					map("v", "<leader>gr", function()
						gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "[Git] Reset Hunk" })

					map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "[Git] Stage Hunk" })
					map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "[Git] Reset Hunk" })
					map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "[Git] Stage Buffer" })
					map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "[Git] Reset Buffer" })
					map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "[Git] Preview Hunk" })
					map("n", "<leader>gi", gitsigns.preview_hunk_inline, { desc = "[Git] Preview Hunk Inline" })
					map("n", "<leader>gd", gitsigns.diffthis, { desc = "[Git] Diff This" })

					map("n", "<leader>gb", function()
						gitsigns.blame_line({ full = true })
					end, { desc = "[Git] Blame Hunk" })

					map("n", "<leader>gD", function()
						gitsigns.diffthis("~")
					end, { desc = "[Git] Diff This" })

					map("n", "<leader>gQ", function()
						gitsigns.setqflist("all")
					end, { desc = "[Git] Send All Hunks to QF" })
					map("n", "<leader>gq", gitsigns.setqflist, { desc = "[Git] Send Hunk to QF" })

					-- Toggles
					map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[Git] Toggle Link Blame" })
					map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "[Git] Toggle Word Diff" })

					-- Text object
					map({ "o", "x" }, "ih", gitsigns.select_hunk)
				end,
			})
		end,
	},
}
