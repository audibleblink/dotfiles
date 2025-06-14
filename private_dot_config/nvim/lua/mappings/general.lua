-- General mappings

local map = vim.keymap.set

-- Basic operations
map("n", "<CR>", ":", { desc = "CMD enter command mode" })
map("n", "<c-q>", ":quitall<CR>", { desc = "Quit all bufers" })
map("n", "<leader>bc", function() vim.api.nvim_buf_delete(0, {}) end, { desc = "Close buffer" })
map("n", "<leader><Tab>", "<cmd> b# <CR>", { desc = "Previous Buffer" })
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "General Clear highlights" })

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
