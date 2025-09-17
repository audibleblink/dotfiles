local map = vim.keymap.set

-------------------------------------- General -----------------------------------------
map("n", "<leader>gc", vim.cmd.GitCommit, { desc = "Git Commit" })
map("i", "jk", "<ESC>", { desc = "Escape insert mode" })

-- QoL
map("n", "<CR>", ":", { desc = "CMD enter command mode" })
map("n", "<leader><Tab>", "<cmd> b# <CR>", { desc = "Previous Buffer" })
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "General Clear highlights" })
map("n", "<C-q>", "<cmd>copen<CR>", { desc = "Open QuickFix" })
map("n", "gh", "0", { desc = "Jump: Start of line" })
map("n", "gl", "$", { desc = "Jump: End of line" })
map("n", "gca", function()
	vim.fn.setqflist({ {
		filename = vim.fn.expand("%"),
		lnum = 1,
		col = 1,
		text = vim.fn.expand("%"),
	} }, "a")
end, { desc = "Add current file to QuickFix" })
-- Line numbers
map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "Toggle Line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "Toggle Relative number" })

-- Window management
map("n", "<leader>zi", "<cmd> wincmd | <CR>:wincmd _ <CR>", { desc = "Zoom Pane" })
map("n", "<leader>zo", "<cmd> wincmd = <CR>", { desc = "Reset Zoom" })

-- Highlight Searching
map("n", "c*", "*Ncgn", { desc = "Search and Replace 1x1" })
map("v", "<C-r>", 'y:%s/<C-r>"//gc<left><left><left>', { desc = "Insert highlight as search string" })

-- Shift + Arrow Keys
vim.keymap.set("n", "<S-Up>", "<cmd>resize +2<CR>") -- Increase height
vim.keymap.set("n", "<S-Down>", "<cmd>resize -2<CR>") -- Decrease height
vim.keymap.set("n", "<S-Right>", "<cmd>vertical resize +5<CR>") -- Increase width
vim.keymap.set("n", "<S-Left>", "<cmd>vertical resize -5<CR>") -- Decrease width

------------------------------------ Brace Match ---------------------------------------
-- NOTE custom objects config'd in mini.ai plugin
map("n", "mm", "%")
-- Selects until matching pair, ex: `vm`
map("x", "m", "%")
-- Use with operators, ex: `dm` - delete until matching pair
map("o", "m", "%")

-------------------------------------- Tabline -----------------------------------------
map("n", "<leader>tt", function()
	require("i3tab").toggle_tabline()
end, { desc = "Toggle [t]abs" })
map("n", "]t", ":tabnext<CR>", { desc = "Next tab", silent = true })
map("n", "[t", ":tabprevious<CR>", { desc = "Previous tab", silent = true })

-------------------------------------- Terminal -----------------------------------------
-- Terminal mode escape
--
map("t", "<C-g>", "<C-\\><C-N>", { desc = "Terminal Escape terminal mode" })

-- Terminal Navigation
local function navigate_from_terminal(direction)
	return "<C-\\><C-N><C-w>" .. direction
end

map("t", "<C-h>", navigate_from_terminal("h"))
map("t", "<C-j>", navigate_from_terminal("j"))
map("t", "<C-k>", navigate_from_terminal("k"))
map("t", "<C-l>", navigate_from_terminal("l"))

local modes = { "n", "t" }
local function run_in_terminal(cmd, opts)
	opts = opts or {}
	local direction = opts.direction or "normal"
	if direction == "vsplit" then
		vim.cmd("vsplit")
	elseif direction == "hsplit" then
		vim.cmd("split")
	elseif direction == "tab" then
		vim.cmd("tabnew")
	elseif direction == "float" then
		-- TODO floating window logic
	end
	local term_buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_win_set_buf(0, term_buf)
	---@diagnostic disable-next-line: deprecated
	vim.fn.termopen(cmd, opts or {})
end

local last_cmd = ""
map(modes, "<leader>tr", function()
	local cmd = vim.fn.input("Command to run: ", last_cmd)
	if cmd and cmd ~= "" then
		last_cmd = cmd
		run_in_terminal(cmd, { direction = "tab" })
	end
end, { desc = "Run user command in terminal" })

map(modes, "<leader>ts", function()
	local cmd = vim.fn.input("Command to run (vs): ", last_cmd)
	if cmd and cmd ~= "" then
		last_cmd = cmd
		run_in_terminal(cmd, { direction = "vsplit" })
	end
end, { desc = "Run user command in vertical split terminal" })
