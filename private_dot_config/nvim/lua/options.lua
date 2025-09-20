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

-- Numbers
o.number = true
o.numberwidth = 2

-- add binaries installed by mise and mason.nvim to PATH
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. ":" .. vim.env.PATH
vim.env.PATH = vim.env.PATH .. ":" .. vim.env.XDG_DATA_HOME .. "/mise/shims"

-- Custom
opt.swapfile = false
opt.scrolloff = 4
opt.colorcolumn = "100"
opt.guifont = "CodeliaLigatures Nerd Font"

-- Create project-specific shada-files
opt.shadafile = (function()
	local git_root = vim.fs.root(0, ".git")
	if not git_root then
		return
	end
	local shadafile = vim.fs.joinpath(vim.fn.stdpath("state"), "_shada", vim.base64.encode(git_root))
	vim.fn.mkdir(vim.fs.dirname(shadafile), "p")
	return shadafile
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
