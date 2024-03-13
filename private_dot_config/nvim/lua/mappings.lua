require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";",  ":",     { desc = "CMD enter command mode" })

map("n", "<leader>cl",    "<cmd> hi Normal guibg=none <CR>",    { desc = "Clear Background (Transparency)" })
map("n", "<leader>b",     "<cmd> Telescope buffers <CR>",       { desc = "Clear Background (Transparency)" })
map("n", "<leader><Tab>", "<cmd> b# <CR>",                      { desc = "Previous Buffer" })
map("n", "<leader>z",     "<cmd> wincmd | <CR>:windcmd _ <CR>", { desc = "Zoom Pane" })
map("n", "<leader>Z",     "<cmd> wincmd = <CR>",                { desc = "Reset Zoom" })
map("n", "<C-\\>",        "<cmd> TmuxNavigatePrevious <CR>",    { desc = "Previous Pane" })
map("n", "<C-h>",         "<cmd> TmuxNavigateLeft <CR>",        { desc = "Navigate Left" })
map("n", "<C-j>",         "<cmd> TmuxNavigateDown <CR>",        { desc = "Navigate Down" })
map("n", "<C-k>",         "<cmd> TmuxNavigateUp <CR>",          { desc = "Navigate Up" })
map("n", "<C-l>",         "<cmd> TmuxNavigateRight <CR>",       { desc = "Navigate Right" })


map("i", "jk", "<ESC>", { desc = "Escape insert mode" })
