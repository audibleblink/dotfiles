-- General mappings

local map = vim.keymap.set

-- Basic operations
map("n", "<CR>", ":", { desc = "CMD enter command mode" })
map("n", "<leader><Tab>", "<cmd> b# <CR>", { desc = "Previous Buffer" })
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "General Clear highlights" })
map("n", "<C-q>", "<cmd>copen<CR>", { desc = "Open QuickFix" })

-- Line numbers
map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "Toggle Line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "Toggle Relative number" })

-- Window management
map("n", "<leader>zi", "<cmd> wincmd | <CR>:wincmd _ <CR>", { desc = "Zoom Pane" })
map("n", "<leader>zo", "<cmd> wincmd = <CR>", { desc = "Reset Zoom" })

-- Text editing
map("n", "c*", "*Ncgn", { desc = "Search and Replace 1x1" })
map("v", "<C-r>", 'y:%s/<C-r>"//gc<left><left><left>', { desc = "Inster highlight as search string" })

-- Insert mode navigation
map("i", "jk", "<ESC>", { desc = "Escape insert mode" })
map("i", "<C-b>", "<ESC>^i", { desc = "Move Beginning of line" })
map("i", "<C-e>", "<End>", { desc = "Move End of line" })
map("i", "<C-h>", "<Left>", { desc = "Move Left" })
map("i", "<C-l>", "<Right>", { desc = "Move Right" })
map("i", "<C-j>", "<Down>", { desc = "Move Down" })
map("i", "<C-k>", "<Up>", { desc = "Move Up" })
-- Custom navigation (commented out in original)
map("n", "j", "v:count > 1 ? 'm`' . v:count . 'j' : 'gj'", { expr = true })
map("n", "k", "v:count > 1 ? 'm`' . v:count . 'k' : 'gk'", { expr = true })

-- More specific autocmd that only triggers on window focus
vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*",
	group = vim.api.nvim_create_augroup("qf", { clear = true }),
	callback = function()
		if vim.bo.buftype == "quickfix" then
			map("n", "<c-q>", function()
				vim.cmd("cclose")
			end, { buffer = true })
			map("n", "<cr>", "<cr>", { buffer = true })
		end
	end,
	desc = "Binding qf",
})
