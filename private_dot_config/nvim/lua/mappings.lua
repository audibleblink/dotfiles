local map = vim.keymap.set
local vim = vim

map("n", "<CR>", ":", { desc = "CMD enter command mode" })
map("n", "<c-q>", ":quitall<CR>", { desc = "Quit all bufers" })
map("n", "<leader>cl", "<cmd> hi Normal guibg=none <CR>", { desc = "Clear Background (Transparency)" })
-- map("n", "<leader>b", "<cmd> Telescope buffers <CR>", { desc = "Search buffers" })
map("n", "<leader><Tab>", "<cmd> b# <CR>", { desc = "Previous Buffer" })
map("n", "<leader>m", "<cmd> wincmd | <CR>:windcmd _ <CR>", { desc = "Zoom Pane" })
map("n", "<leader>mm", "<cmd> wincmd = <CR>", { desc = "Reset Zoom" })
map("n", "c*", "*Ncgn", { desc = "Search and Replace 1x1" })
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "General Clear highlights" })
map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "Toggle Line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "Toggle Relative number" })
map("n", "<leader>ch", "<cmd>NvCheatsheet<CR>", { desc = "Toggle NvCheatsheet" })
map("n", "gm", function()
	require("conform").format({ lsp_fallback = true })
end, { desc = "Format Files" })

-- global lsp mappings
map("n", "<leader>lf", vim.diagnostic.open_float, { desc = "Lsp floating diagnostics" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Lsp prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Lsp next diagnostic" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Lsp diagnostic loclist" })

-- blankline
map("n", "<leader>cc", function()
	local config = { scope = {} }
	config.scope.exclude = { language = {}, node_type = {} }
	config.scope.include = { node_type = {} }
	local node = require("ibl.scope").get(vim.api.nvim_get_current_buf(), config)

	if node then
		local start_row, _, end_row, _ = node:range()
		if start_row ~= end_row then
			vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start_row + 1, 0 })
			vim.api.nvim_feedkeys("_", "n", true)
		end
	end
end, { desc = "Blankline Jump to current context" })

-- Comment
map("n", "<leader>/", function()
	require("Comment.api").toggle.linewise.current()
end, { desc = "Comment Toggle" })

map(
	"v",
	"<leader>/",
	"<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
	{ desc = "Comment Toggle" }
)

-- nvimtree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Nvimtree Toggle window" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "Nvimtree Focus window" })

-- telescope
map("n", "<leader>fm", "<cmd>Telescope messages<CR>", { desc = "Telescope Messages" })
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "Telescope Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Telescope Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Telescope Help page" })

map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Telescope Find oldfiles" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Telescope Find in current buffer" })
map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "Telescope Git commits" })
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "Telescope Git status" })
map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "Telescope Pick hidden term" })
map("n", "<leader>th", function()
	require("nvchad.themes").open({ style = "bordered" })
end, { desc = "Telescope Nvchad themes" })
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Telescope Find files" })
map(
	"n",
	"<leader>fa",
	"<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
	{ desc = "Telescope Find all files" }
)

-- terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "Terminal Escape terminal mode" })

map("v", "<C-r>", "hy:%s/<C-r>h//gc<left><left><left>", { desc = "Inster highlight as search string" })

map("i", "jk", "<ESC>", { desc = "Escape insert mode" })
map("i", "<C-b>", "<ESC>^i", { desc = "Move Beginning of line" })
map("i", "<C-e>", "<End>", { desc = "Move End of line" })
map("i", "<C-h>", "<Left>", { desc = "Move Left" })
map("i", "<C-l>", "<Right>", { desc = "Move Right" })
map("i", "<C-j>", "<Down>", { desc = "Move Down" })
map("i", "<C-k>", "<Up>", { desc = "Move Up" })

local terminal = require("nvchad.term")
local modes = { "n", "t" }

-- new terminals
map(modes, "<leader>hh", function()
	terminal.toggle({ pos = "sp", id = "htoggleTerm", size = 0.3 })
end, { desc = "Terminal New horizontal term" })

map(modes, "<leader>vv", function()
	terminal.toggle({ pos = "vsp", id = "vtoggleTerm", size = 0.3 })
end, { desc = "Terminal Toggleable vertical term" })

map(modes, "<leader>ii", function()
	terminal.toggle({ pos = "float", id = "floatTerm" })
end, { desc = "Terminal Toggle Floating term" })

local ft_cmds = {
	python = "python3 " .. vim.fn.expand("%"),
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

-- noremap <expr> j v:count > 1 ? 'm`' . v:count . 'j' : 'gj'
-- noremap <expr> k v:count > 1 ? 'm`' . v:count . 'k' : 'gk'
