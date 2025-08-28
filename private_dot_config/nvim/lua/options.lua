local opt = vim.opt
local g = vim.g
local o = vim.o

-------------------------------------- Globals -----------------------------------------
g.mapleader = " "
g.toggle_theme_icon = "   "
g.tmux_navigator_save_on_switch = 2

-- disable some default providers
g["loaded_node_provider"] = 0
g["loaded_python3_provider"] = 0
g["loaded_perl_provider"] = 0
g["loaded_ruby_provider"] = 0

-------------------------------------- Options ------------------------------------------
opt.shortmess:append("sI")
opt.fillchars = { eob = " " }
opt.autoread = true
opt.whichwrap:append("<>[]hl")
o.updatetime = 500 -- used by gitsigns/CursorHold
o.laststatus = 3
o.showmode = false
o.ignorecase = true
o.smartcase = true
o.signcolumn = "auto:2"
o.splitbelow = true
o.splitright = true
o.timeoutlen = 500
o.undofile = true
o.mouse = "a"
o.wrap = false

o.clipboard = "unnamedplus"
o.cursorline = true
o.cursorlineopt = "both"

-- Indenting
o.smartindent = true
o.tabstop = 4

-- Numbers
o.number = true
o.numberwidth = 2
o.ruler = false

-- add binaries installed by mise and mason.nvim to PATH
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. ":" .. vim.env.PATH
vim.env.PATH = vim.env.PATH .. ":" .. vim.env.XDG_DATA_HOME .. "/mise/shims"

-- Custom
opt.swapfile = false
opt.scrolloff = 5
opt.colorcolumn = "100"
opt.guifont = "CodeliaLigatures Nerd Font"

-- Create project-specific shada-files
opt.shadafile = (function()
	local data = vim.fn.stdpath("state")
	local cwd = vim.fn.getcwd()
	cwd = vim.fs.root(0, ".git") or cwd

	local cwd_b64 = vim.base64.encode(cwd)
	local file = vim.fs.joinpath(data, "_shada", cwd_b64)
	vim.fn.mkdir(vim.fs.dirname(file), "p")
	return file
end)()

-- Find function for raw-dogging file search
function Fd(file_pattern, _)
	-- if first char is * then fuzzy search
	if file_pattern:sub(1, 1) == "*" then
		file_pattern = file_pattern:gsub(".", ".*%0") .. ".*"
	end
	local cmd = 'fd  --color=never --no-ignore --full-path --type file --hidden --exclude=".git" --exclude="deps" "'
		.. file_pattern
		.. '"'
	return vim.fn.systemlist(cmd)
end
vim.opt.findfunc = "v:lua.Fd"
vim.keymap.set("n", "<C-p>", ":find ", { desc = "raw-dog: Project Files" })
