-- Terminal related mappings

local map = vim.keymap.set
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
