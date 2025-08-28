-- General mappings

local map = vim.keymap.set

map("n", "<leader>gc", vim.cmd.GitCommit, { desc = "Git Commit" })

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

-- Custom Tabline --
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", { desc = "Toggle [t]abs" })
vim.keymap.set("n", "<leader>tt", function()
	if vim.o.showtabline == 2 then
		vim.o.showtabline = 0
	else
		vim.o.showtabline = 2
	end
end, { desc = "Toggle [t]abs" })

vim.keymap.set("n", "]t", ":tabnext<CR>", { desc = "Next tab", silent = true })
vim.keymap.set("n", "[t", ":tabprevious<CR>", { desc = "Previous tab", silent = true })

vim.api.nvim_set_hl(0, "TabLine", { bg = "NONE", fg = "#666666" }) -- fallback for non-pill content
vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" }) --             background of unused space

vim.api.nvim_set_hl(0, "TabLinePillActiveLeft", { fg = "#8aadf4", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "TabLinePillActiveText", { fg = "#1e1e2e", bg = "#8aadf4", bold = false })
vim.api.nvim_set_hl(0, "TabLinePillActiveRight", { fg = "#8aadf4", bg = "#1e1e2e" })

vim.api.nvim_set_hl(0, "TabLinePillInactiveLeft", { fg = "#737994", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "TabLinePillInactiveText", { fg = "#1e1e2e", bg = "#737994" })
vim.api.nvim_set_hl(0, "TabLinePillInactiveRight", { fg = "#737994", bg = "#1e1e2e" })

vim.o.tabline = "%!v:lua.PillTabline()"

function _G.PillTabline()
	local s = "%="
	local tabs = vim.api.nvim_list_tabpages()
	local current = vim.api.nvim_get_current_tabpage()

	for i, tab in ipairs(tabs) do
		local is_active = (tab == current)

		local hl_left = is_active and "%#TabLinePillActiveLeft#" or "%#TabLinePillInactiveLeft#"
		local hl_text = is_active and "%#TabLinePillActiveText#" or "%#TabLinePillInactiveText#"
		local hl_right = is_active and "%#TabLinePillActiveRight#" or "%#TabLinePillInactiveRight#"

		s = s .. hl_left .. ""
		s = s .. hl_text .. i
		s = s .. hl_right .. ""
		s = s .. "%#TabLineFill# "
	end
	s = s .. "%="
	return s
end

-- Terminal related mappings
local modes = { "n", "t" }

local function run_in_terminal(cmd, opts)
	opts = opts or {}
	local direction = opts.direction or "normal"
	if direction == "vsplit" then
		vim.cmd("vsplit")
	elseif direction == "hsplit" then
		vim.cmd("split")
	elseif direction == "float" then
		-- Implement floating window logic if desired
	end
	local term_buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_win_set_buf(0, term_buf)
	---@diagnostic disable-next-line: deprecated
	vim.fn.termopen(cmd, opts or {})
end

local last_cmd = ""
map(modes, "<leader>lr", function()
	local cmd = vim.fn.input("Command to run: ", last_cmd)
	if cmd and cmd ~= "" then
		last_cmd = cmd
		run_in_terminal(cmd, { direction = "normal" })
	end
end, { desc = "Run user command in terminal" })

map(modes, "<leader>lsv", function()
	local cmd = vim.fn.input("Command to run (vs): ", last_cmd)
	if cmd and cmd ~= "" then
		last_cmd = cmd
		run_in_terminal(cmd, { direction = "vsplit" })
	end
end, { desc = "Run user command in vertical split terminal" })

-- Terminal mode escape
--
map("t", "<C-x>", "<C-\\><C-N>", { desc = "Terminal Escape terminal mode" })

-- Terminal Navigation
local function navigate_from_terminal(direction)
	return "<C-\\><C-N><C-w>" .. direction
end

map("t", "<C-h>", navigate_from_terminal("h"))
map("t", "<C-j>", navigate_from_terminal("j"))
map("t", "<C-k>", navigate_from_terminal("k"))
map("t", "<C-l>", navigate_from_terminal("l"))
