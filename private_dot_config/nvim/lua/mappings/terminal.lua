-- Terminal related mappings

local map = vim.keymap.set
local modes = { "n", "t" }
local terminal = require("nvchad.term")

-- Terminal mode escape
map("t", "<C-x>", "<C-\\><C-N>", { desc = "Terminal Escape terminal mode" })

-- Terminal toggles
map(modes, "<leader>hh", function()
	terminal.toggle({ pos = "sp", id = "htoggleTerm", size = 0.3 })
end, { desc = "Terminal New horizontal term" })

map(modes, "<leader>vv", function()
	terminal.toggle({ pos = "vsp", id = "vtoggleTerm", size = 0.3 })
end, { desc = "Terminal Toggleable vertical term" })

map(modes, "<leader>ii", function()
	terminal.toggle({ pos = "float", id = "floatTerm" })
end, { desc = "Terminal Toggle Floating term" })

-- File type specific terminal commands
local ft_cmds = {
	python = "python " .. vim.fn.expand("%"),
	zig = "zig build; exit ",
}

map(modes, "<leader>it", function()
	terminal.runner({
		pos = "float",
		cmd = ft_cmds[vim.bo.filetype],
		id = "runner",
		clear_cmd = false,
	})
end, { desc = "Run zig build in Floating term" })

