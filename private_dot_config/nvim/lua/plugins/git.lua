return {
	"lewis6991/gitsigns.nvim",
	event = "InsertEnter",
	dependencies = { "sindrets/diffview.nvim" },
	config = function()
		-- Register GitCommit command globally
		vim.api.nvim_create_user_command("GitCommit", function()
			-- This causes git to create COMMIT_EDITMSG but not complete the commit
			vim.fn.system("GIT_EDITOR=true git commit -v")
			local git_dir = vim.fn.system("git rev-parse --git-dir"):gsub("\n", "")
			vim.cmd("tabedit! " .. git_dir .. "/COMMIT_EDITMSG")

			vim.api.nvim_create_autocmd("BufWritePost", {
				desc = "Execute git commit",
				pattern = "COMMIT_EDITMSG",
				once = true,
				callback = function()
					vim.fn.system("git commit -F " .. vim.fn.expand("%:p"))
				end,
			})
		end, {})

		require("gitsigns").setup({
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")
				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				map("n", "<leader>gc", vim.cmd.GitCommit, { desc = "[Git] Commit" })

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

				-- Motion-based hunk staging
				local function stage_hunk_operator()
					local start_pos = vim.api.nvim_buf_get_mark(0, "[")
					local end_pos = vim.api.nvim_buf_get_mark(0, "]")
					gitsigns.stage_hunk({ start_pos[1], end_pos[1] })
				end

				map("n", "gs", function()
					_G._stage_hunk_operator = stage_hunk_operator
					vim.o.operatorfunc = "v:lua._stage_hunk_operator"
					return "g@"
				end, { expr = true, desc = "[Git] Stage hunk with motion" })

				-- Toggles
				map("n", "<leader>gtb", gitsigns.toggle_current_line_blame, { desc = "[Git] Toggle Line Blame" })
				map("n", "<leader>gtw", gitsigns.toggle_word_diff, { desc = "[Git] Toggle Word Diff" })

				-- Text object
				map({ "o", "x" }, "ih", gitsigns.select_hunk)
			end,
		})
	end,
}
