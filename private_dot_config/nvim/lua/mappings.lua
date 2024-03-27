require("nvchad.mappings")

-- add yours here

local map = vim.keymap.set

map("n", "<CR>", ":", { desc = "CMD enter command mode" })
map("n", "<leader>cl", "<cmd> hi Normal guibg=none <CR>", { desc = "Clear Background (Transparency)" })
map("n", "<leader>b", "<cmd> Telescope buffers <CR>", { desc = "Search buffers" })
map("n", "<leader><Tab>", "<cmd> b# <CR>", { desc = "Previous Buffer" })
map("n", "<leader>z", "<cmd> wincmd | <CR>:windcmd _ <CR>", { desc = "Zoom Pane" })
map("n", "<leader>Z", "<cmd> wincmd = <CR>", { desc = "Reset Zoom" })
map("n", "<C-\\>", "<cmd> TmuxNavigatePrevious <CR>", { desc = "Previous Pane" })
map("n", "<C-h>", "<cmd> TmuxNavigateLeft <CR>", { desc = "Navigate Left" })
map("n", "<C-j>", "<cmd> TmuxNavigateDown <CR>", { desc = "Navigate Down" })
map("n", "<C-k>", "<cmd> TmuxNavigateUp <CR>", { desc = "Navigate Up" })
map("n", "<C-l>", "<cmd> TmuxNavigateRight <CR>", { desc = "Navigate Right" })
map("n", "c*", "*Ncgn", { desc = "Search and Replace 1x1" })

map("v", "<C-r>", "hy:%s/<C-r>h//gc<left><left><left>", { desc = "Inster highlight as search string" })

map("i", "jk", "<ESC>", { desc = "Escape insert mode" })

-- new terminals
map({ "n", "t" }, "<leader>h", function()
	require("nvchad.term").toggle({ pos = "sp", id = "htoggleTerm", size = 0.3 })
end, { desc = "Terminal New horizontal term" })

map({ "n", "t" }, "<leader>v", function()
	require("nvchad.term").toggle({ pos = "vsp", id = "vtoggleTerm", size = 0.3 })
end, { desc = "Terminal Toggleable vertical term" })

map({ "n", "t" }, "<leader>i", function()
	require("nvchad.term").toggle({ pos = "float", id = "floatTerm" })
end, { desc = "Terminal Toggle Floating term" })

-- noremap <expr> j v:count > 1 ? 'm`' . v:count . 'j' : 'gj'
-- noremap <expr> k v:count > 1 ? 'm`' . v:count . 'k' : 'gk'
