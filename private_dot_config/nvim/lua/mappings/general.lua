-- General mappings

local map = vim.keymap.set
local vim = vim

-- Basic operations
map("n", "<CR>", ":", { desc = "CMD enter command mode" })
map("n", "<c-q>", ":quitall<CR>", { desc = "Quit all bufers" })
map("n", "<leader>cl", "<cmd> hi Normal guibg=none <CR>", { desc = "Clear Background (Transparency)" })
map("n", "<leader><Tab>", "<cmd> b# <CR>", { desc = "Previous Buffer" })
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "General Clear highlights" })

-- Line numbers
map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "Toggle Line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "Toggle Relative number" })

-- Window management
map("n", "<leader>m", "<cmd> wincmd | <CR>:windcmd _ <CR>", { desc = "Zoom Pane" })
map("n", "<leader>mm", "<cmd> wincmd = <CR>", { desc = "Reset Zoom" })

-- Text editing
map("n", "c*", "*Ncgn", { desc = "Search and Replace 1x1" })
map("v", "<C-r>", "hy:%s/<C-r>h//gc<left><left><left>", { desc = "Inster highlight as search string" })

-- Insert mode navigation
map("i", "jk", "<ESC>", { desc = "Escape insert mode" })
map("i", "<C-b>", "<ESC>^i", { desc = "Move Beginning of line" })
map("i", "<C-e>", "<End>", { desc = "Move End of line" })
map("i", "<C-h>", "<Left>", { desc = "Move Left" })
map("i", "<C-l>", "<Right>", { desc = "Move Right" })
map("i", "<C-j>", "<Down>", { desc = "Move Down" })
map("i", "<C-k>", "<Up>", { desc = "Move Up" })

-- Formatting
map("n", "gm", function()
	require("conform").format({ lsp_fallback = true })
end, { desc = "Format Files" })