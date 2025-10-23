-- vim: foldmarker={{{,}}} foldlevel=1 foldmethod=marker
--- KeyMaps {{{
---
vim.keymap.set("i", "<C-s>", "<cmd>w<cr>", { desc = "Join w/o cursor moving" })
vim.keymap.set("i", "jk", "<ESC>", { desc = "Escape insert mode" })
vim.keymap.set("n", "<leader>rr", ":update<CR> :source<CR>", { desc = "Source current file" })

--- QoL
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join w/o cursor moving" })
vim.keymap.set("n", "<CR>", ":", { desc = "CMD enter command mode" })
vim.keymap.set("n", "<leader><Tab>", "<cmd> b# <CR>", { desc = "Previous Buffer" })
vim.keymap.set("n", "<left>", "0", { desc = "Jump: Start of line" })
vim.keymap.set("n", "<right>", "$", { desc = "Jump: End of line" })

vim.keymap.set("n", "gp", '"+p', { desc = "Paste" })
vim.keymap.set("n", "gP", 'o<esc>"+p', { desc = "Paste below" })
vim.keymap.set("x", "gp", '"+P', { desc = "Paste overwrite" })
vim.keymap.set("x", "gP", "pgvy", { desc = "Paste without clobber" })

vim.keymap.set({ "n", "x" }, "gy", '"+y', { desc = "Yank" })
vim.keymap.set("n", "gyy", '"+yy', { desc = "Yank Line" })
vim.keymap.set("n", "gY", '"+y$', { desc = "Yank to end" })

vim.keymap.set("n", "q", "", { desc = "Unassing q key" })
vim.keymap.set("n", "\\", "q", { desc = "Macros" })
vim.keymap.set("n", "qo", "<cmd>copen<CR>", { desc = "Open QuickFix" })
vim.keymap.set("n", "qa", function()
	vim.fn.setqflist({ {
		filename = vim.fn.expand("%"),
		lnum = 1,
		col = 1,
		text = vim.fn.expand("%"),
	} }, "a")
end, { desc = "Add current file to QuickFix" })

--- Line numbers
vim.keymap.set("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "Toggle Line number" })
vim.keymap.set("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "Toggle Relative number" })

--- Window management
vim.keymap.set("n", "<leader>zi", "<cmd> wincmd | <CR>:wincmd _ <CR>", { desc = "Zoom Pane" })
vim.keymap.set("n", "<leader>zo", "<cmd> wincmd = <CR>", { desc = "Reset Zoom" })

--- Highlight Searching
vim.keymap.set("n", "c*", "*Ncgn", { desc = "Search and Replace 1x1" })
vim.keymap.set("v", "<C-r>", 'y:%s/<C-r>"//gc<left><left><left>', { desc = "Insert highlight as search string" })

--- Resize w/ Shift + Arrow Keys
vim.keymap.set("n", "<S-Up>", "<cmd>resize +2<CR>")             -- Increase height
vim.keymap.set("n", "<S-Down>", "<cmd>resize -2<CR>")           -- Decrease height
vim.keymap.set("n", "<S-Right>", "<cmd>vertical resize +5<CR>") -- Increase width
vim.keymap.set("n", "<S-Left>", "<cmd>vertical resize -5<CR>")  -- Decrease width

--- Smart highlight cancelling
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

------------------------------------ Brace Match ---------------------------------------
--- NOTE custom objects config'd in mini.ai plugin
vim.keymap.set("n", "mm", "%")
--- Selects until matching pair, ex: `vm`
vim.keymap.set("x", "m", "%")
--- Use with operators, ex: `dm` - delete until matching pair
vim.keymap.set("o", "m", "%")

-------------------------------------- Tabline -----------------------------------------
vim.keymap.set("n", "]t", ":tabnext<CR>", { desc = "Next tab", silent = true })
vim.keymap.set("n", "[t", ":tabprevious<CR>", { desc = "Previous tab", silent = true })

-------------------------------------- Terminal -----------------------------------------
--- Terminal mode escape
--
vim.keymap.set("t", "<C-g>", "<C-\\><C-N>", { desc = "Terminal Escape terminal mode" })

--- Terminal Navigation
local function navigate_from_terminal(direction)
	return "<C-\\><C-N><C-w>" .. direction
end

vim.keymap.set("t", "<C-h>", navigate_from_terminal("h"))
vim.keymap.set("t", "<C-j>", navigate_from_terminal("j"))
vim.keymap.set("t", "<C-k>", navigate_from_terminal("k"))
vim.keymap.set("t", "<C-l>", navigate_from_terminal("l"))

--- }}}
