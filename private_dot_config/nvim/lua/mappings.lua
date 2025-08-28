local map = vim.keymap.set

-------------------------------------- General -----------------------------------------
map("n", "<leader>gc", vim.cmd.GitCommit, { desc = "Git Commit" })
map("i", "jk", "<ESC>", { desc = "Escape insert mode" })

-- QoL
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

-- Highlight Searching
map("n", "c*", "*Ncgn", { desc = "Search and Replace 1x1" })
map("v", "<C-r>", 'y:%s/<C-r>"//gc<left><left><left>', { desc = "Insert highlight as search string" })

------------------------------------ Brace Match ---------------------------------------
-- NOTE custom objects config'd in mini.ai plugin
vim.keymap.set("n", "mm", "%")
-- Selects until matching pair, ex: `vm`
vim.keymap.set("x", "m", "%")
-- Use with operators, ex: `dm` - delete until matching pair
vim.keymap.set("o", "m", "%")

-------------------------------------- Tabline -----------------------------------------
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

function _G.PillTabline()
	local tabs = vim.api.nvim_list_tabpages()
	local current = vim.api.nvim_get_current_tabpage()

	local s = "%="
	for i, tab in ipairs(tabs) do
		local is_active = (tab == current)

		local hl_left = is_active and "%#TabLinePillActiveLeft#" or "%#TabLinePillInactiveLeft#"
		local hl_text = is_active and "%#TabLinePillActiveText#" or "%#TabLinePillInactiveText#"
		local hl_right = is_active and "%#TabLinePillActiveRight#" or "%#TabLinePillInactiveRight#"

		s = s .. hl_left .. ""
		s = s .. hl_text .. " " .. i .. " "
		s = s .. hl_right .. ""
		s = s .. "%#TabLineFill# "
	end
	s = s .. "%="
	return s
end

vim.o.tabline = "%!v:lua.PillTabline()"

-- Apply custom tab highlights using base46 colors
vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
	callback = function()
		local colors = require("base46").get_theme_tb("base_30")
		vim.api.nvim_set_hl(0, "TabLinePillActiveLeft", { fg = colors.blue })
		vim.api.nvim_set_hl(0, "TabLinePillActiveText", { fg = colors.black, bg = colors.blue, bold = false })
		vim.api.nvim_set_hl(0, "TabLinePillActiveRight", { fg = colors.blue })
		vim.api.nvim_set_hl(0, "TabLinePillInactiveLeft", { fg = colors.grey })
		vim.api.nvim_set_hl(0, "TabLinePillInactiveText", { fg = colors.black, bg = colors.grey })
		vim.api.nvim_set_hl(0, "TabLinePillInactiveRight", { fg = colors.grey })
	end,
})

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
