-- Terminal related mappings

local map = vim.keymap.set
local terminal = require("nvchad.term")
local modes = { "n", "t" }

-- Terminal toggles
--
map(modes, "<leader>lh", function()
	terminal.toggle({ pos = "sp", id = "htoggleTerm", size = 0.3 })
end, { desc = "Terminal New horizontal term" })

map(modes, "<leader>lv", function()
	terminal.toggle({ pos = "vsp", id = "vtoggleTerm", size = 0.3 })
end, { desc = "Terminal Toggleable vertical term" })

map(modes, "<leader>li", function()
	terminal.toggle({ pos = "float", id = "floatTerm" })
end, { desc = "Terminal Toggle Floating term" })

-- Temp Terminals and Runner bindings
--
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
	vim.fn.termopen(cmd, opts.termopen_opts or {})
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

-- Register GitCommit to commit in current buffer
--
vim.api.nvim_create_user_command("GitCommit", function()
	-- Get git directory
	local git_dir = vim.fn.system("git rev-parse --git-dir"):gsub("\n", "")

	-- Use 'true' as editor - it immediately exits with success
	-- This causes git to create COMMIT_EDITMSG but not complete the commit
	vim.fn.system("GIT_EDITOR=true git commit -v")

	-- Replace current buffer with COMMIT_EDITMSG
	vim.cmd("edit! " .. git_dir .. "/COMMIT_EDITMSG")

	-- Set up autocmd to run actual commit on save
	vim.api.nvim_create_autocmd("BufWritePost", {
		pattern = "COMMIT_EDITMSG",
		once = true,
		callback = function()
			vim.fn.system("git commit -F " .. vim.fn.expand("%:p"))
			require("mini.bufremove").delete()
		end,
	})
end, {})
map({ "n", "v" }, "<leader>gc", vim.cmd.GitCommit, { desc = "Git Commit" })

-- Terminal Navigation
local function navigate_from_terminal(direction)
	return "<C-\\><C-N><C-w>" .. direction
end

vim.keymap.set("t", "<C-h>", navigate_from_terminal("h"))
vim.keymap.set("t", "<C-j>", navigate_from_terminal("j"))
vim.keymap.set("t", "<C-k>", navigate_from_terminal("k"))
vim.keymap.set("t", "<C-l>", navigate_from_terminal("l"))

-- Enter insert mode when focusing terminal
--
vim.api.nvim_create_autocmd("WinEnter", {
	pattern = "*",
	group = vim.api.nvim_create_augroup("term_insert", { clear = true }),
	callback = function()
		if vim.bo.buftype == "terminal" then
			vim.cmd("startinsert")
		end
	end,
	desc = "Enter insert mode when focusing terminal",
})

-- Terminal mode escape
--
map("t", "<C-x>", "<C-\\><C-N>", { desc = "Terminal Escape terminal mode" })

-- TODO: try this later as a replacement for nvchad's term:
-- -- Terminal management module
-- local M = {}
--
-- -- Store terminal buffers and windows
-- M.terminals = {}
--
-- -- Create or toggle a terminal
-- function M.toggle(opts)
--     opts = opts or {}
--     local pos = opts.pos or "float"
--     local id = opts.id or "default"
--     local size = opts.size or 0.3
--
--     -- Check if terminal already exists
--     if M.terminals[id] then
--         local term_info = M.terminals[id]
--
--         -- If window exists and is valid, close it
--         if term_info.win and vim.api.nvim_win_is_valid(term_info.win) then
--             vim.api.nvim_win_close(term_info.win, false)
--             M.terminals[id].win = nil
--             return
--         end
--
--         -- If buffer exists but window doesn't, reopen window
--         if term_info.buf and vim.api.nvim_buf_is_valid(term_info.buf) then
--             M._create_window(term_info.buf, pos, size, id)
--             return
--         end
--     end
--
--     -- Create new terminal
--     M._create_terminal(pos, size, id)
-- end
--
-- -- Run a command in terminal
-- function M.runner(opts)
--     opts = opts or {}
--     local pos = opts.pos or "float"
--     local cmd = opts.cmd
--     local id = opts.id or "runner"
--     local clear_cmd = opts.clear_cmd ~= false -- default true
--
--     if not cmd then
--         print("No command specified")
--         return
--     end
--
--     -- Create or get existing terminal
--     local term_info = M.terminals[id]
--
--     if not term_info or not vim.api.nvim_buf_is_valid(term_info.buf) then
--         M._create_terminal(pos, 0.3, id)
--         term_info = M.terminals[id]
--     else
--         -- If terminal exists but window is closed, reopen it
--         if not term_info.win or not vim.api.nvim_win_is_valid(term_info.win) then
--             M._create_window(term_info.buf, pos, 0.3, id)
--         end
--     end
--
--     -- Clear terminal if requested
--     if clear_cmd then
--         vim.api.nvim_chan_send(term_info.job_id, "clear\n")
--     end
--
--     -- Send command
--     vim.api.nvim_chan_send(term_info.job_id, cmd .. "\n")
--
--     -- Focus the terminal window
--     vim.api.nvim_set_current_win(term_info.win)
-- end
--
-- -- Create a new terminal
-- function M._create_terminal(pos, size, id)
--     local buf = vim.api.nvim_create_buf(false, true)
--
--     -- Set buffer options
--     vim.api.nvim_buf_set_option(buf, "buftype", "terminal")
--     vim.api.nvim_buf_set_option(buf, "buflisted", false)
--
--     M._create_window(buf, pos, size, id)
--
--     -- Start terminal job
--     local job_id = vim.fn.termopen(vim.o.shell)
--
--     -- Store terminal info
--     M.terminals[id] = {
--         buf = buf,
--         win = vim.api.nvim_get_current_win(),
--         job_id = job_id,
--         pos = pos,
--         size = size
--     }
--
--     -- Set up buffer-local keymaps for terminal mode
--     M._setup_terminal_keymaps(buf)
-- end
--
-- -- Create window based on position
-- function M._create_window(buf, pos, size, id)
--     local win
--
--     if pos == "sp" then
--         -- Horizontal split
--         vim.cmd("split")
--         win = vim.api.nvim_get_current_win()
--         local height = math.floor(vim.o.lines * size)
--         vim.api.nvim_win_set_height(win, height)
--
--     elseif pos == "vsp" then
--         -- Vertical split
--         vim.cmd("vsplit")
--         win = vim.api.nvim_get_current_win()
--         local width = math.floor(vim.o.columns * size)
--         vim.api.nvim_win_set_width(win, width)
--
--     elseif pos == "float" then
--         -- Floating window
--         local width = math.floor(vim.o.columns * 0.8)
--         local height = math.floor(vim.o.lines * 0.8)
--         local row = math.floor((vim.o.lines - height) / 2)
--         local col = math.floor((vim.o.columns - width) / 2)
--
--         win = vim.api.nvim_open_win(buf, true, {
--             relative = "editor",
--             width = width,
--             height = height,
--             row = row,
--             col = col,
--             style = "minimal",
--             border = "rounded"
--         })
--     end
--
--     -- Set the buffer in the window
--     vim.api.nvim_win_set_buf(win, buf)
--
--     -- Update terminal info
--     if M.terminals[id] then
--         M.terminals[id].win = win
--     end
--
--     -- Enter terminal mode
--     vim.cmd("startinsert")
-- end
--
-- -- Set up terminal-specific keymaps
-- function M._setup_terminal_keymaps(buf)
--     local opts = { buffer = buf, silent = true }
--
--     -- Easy escape from terminal mode
--     vim.keymap.set("t", "<C-x>", "<C-\\><C-n>", opts)
--     vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", opts)
--
--     -- Window navigation from terminal
--     vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", opts)
--     vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", opts)
--     vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", opts)
--     vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", opts)
-- end
--
-- -- Clean up closed terminals
-- vim.api.nvim_create_autocmd("TermClose", {
--     callback = function(args)
--         local buf = args.buf
--         -- Find and remove terminal from our tracking
--         for id, term_info in pairs(M.terminals) do
--             if term_info.buf == buf then
--                 M.terminals[id] = nil
--                 break
--             end
--         end
--     end
-- })
--
-- -- Now set up your keymaps using this module
-- local map = vim.keymap.set
-- local modes = { "n", "t" }
--
-- -- Terminal toggles
-- map(modes, "<leader>hh", function()
--     M.toggle({ pos = "sp", id = "htoggleTerm", size = 0.3 })
-- end, { desc = "Terminal New horizontal term" })
--
-- map(modes, "<leader>vv", function()
--     M.toggle({ pos = "vsp", id = "vtoggleTerm", size = 0.3 })
-- end, { desc = "Terminal Toggleable vertical term" })
--
-- map(modes, "<leader>ii", function()
--     M.toggle({ pos = "float", id = "floatTerm" })
-- end, { desc = "Terminal Toggle Floating term" })
--
-- -- File type specific terminal commands
-- local ft_cmds = {
--     python = "python " .. vim.fn.expand("%"),
--     zig = "zig build; exit ",
-- }
--
-- map(modes, "<leader>it", function()
--     M.runner({
--         pos = "float",
--         cmd = ft_cmds[vim.bo.filetype],
--         id = "runner",
--         clear_cmd = false,
--     })
-- end, { desc = "Run zig build in Floating term" })
