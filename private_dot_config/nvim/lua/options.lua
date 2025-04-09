local opt = vim.opt
local g = vim.g
local o = vim.o

-------------------------------------- globals -----------------------------------------
g.toggle_theme_icon = "   "
g.tmux_navigator_save_on_switch = 2

-- disable some default providers
g["loaded_node_provider"] = 0
g["loaded_python3_provider"] = 0
g["loaded_perl_provider"] = 0
g["loaded_ruby_provider"] = 0

-------------------------------------- options ------------------------------------------
-- disable nvim intro
opt.shortmess:append("sI")
opt.fillchars = { eob = " " }
opt.autoread = true
-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append("<>[]hl")
-- interval for writing swap file to disk, also used by gitsigns
o.updatetime = 250
o.laststatus = 3
o.showmode = false
o.ignorecase = true
o.smartcase = true
o.signcolumn = "yes"
o.splitbelow = true
o.splitright = true
o.timeoutlen = 250
o.undofile = true
o.mouse = "a"

o.clipboard = "unnamedplus"
o.cursorline = true
o.cursorlineopt = "both"

-- Indenting
o.expandtab = true
o.shiftwidth = 2
o.smartindent = true
o.tabstop = 2
o.softtabstop = 2

-- Numbers
o.number = true
o.numberwidth = 2
o.ruler = false

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has("win32") ~= 0
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. (is_windows and ";" or ":") .. vim.env.PATH

-- Custom
opt.swapfile = false
opt.scrolloff = 8
opt.colorcolumn = "99"
opt.guifont = "CodeliaLigatures Nerd Font"

-- highlight yanked text for 300ms using the "Visual" highlight group
vim.cmd([[
	augroup highlight_yank
		autocmd!
		au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=300})
	augroup END
]])

-- Reload files if changed externally
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
	command = "if mode() != 'c' | checktime | endif",
	pattern = { "*" },
})

-- Create project-specific shada-files for things like marks
opt.shadafile = (function()
	local data = vim.fn.stdpath("state")
	local cwd = vim.fn.getcwd()
	cwd = vim.fs.root(0, ".git") or cwd

	local cwd_b64 = vim.base64.encode(cwd)
	local file = vim.fs.joinpath(data, "_shada", cwd_b64)
	vim.fn.mkdir(vim.fs.dirname(file), "p")
	return file
end)()
