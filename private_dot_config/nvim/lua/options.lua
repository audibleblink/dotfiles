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
-- interval for writing swap file to disk, also used by gitsigns/CursorHold
o.updatetime = 500
o.laststatus = 3
o.showmode = false
o.ignorecase = true
o.smartcase = true
o.signcolumn = "yes"
o.splitbelow = true
o.splitright = true
o.timeoutlen = 500
o.undofile = true
o.mouse = "a"

o.clipboard = "unnamedplus"
o.cursorline = true
o.cursorlineopt = "both"

-- Indenting
o.smartindent = true
o.tabstop = 4
-- o.expandtab = true
-- o.shiftwidth = 2
-- o.softtabstop = 2

-- Numbers
o.number = true
o.numberwidth = 2
o.ruler = false

-- add binaries installed by mise and mason.nvim to path
local is_windows = vim.fn.has("win32") ~= 0
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. (is_windows and ";" or ":") .. vim.env.PATH
vim.env.PATH = vim.env.XDG_DATA_HOME .. "/mise/shims:" .. vim.env.PATH

-- Custom
opt.swapfile = false
opt.scrolloff = 5
opt.colorcolumn = "120"
opt.guifont = "CodeliaLigatures Nerd Font"

-- highlight yanked text for 300ms using the "Visual" highlight group
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Reload files if changed externally
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
	command = "if mode() != 'c' | checktime | endif",
	pattern = { "*" },
	desc = "Enter insert mode when focusing terminal",
})

--  e.g. ~/.local/share/chezmoi/*
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	desc = "Editing a chezmoi file",
	pattern = { os.getenv("HOME") .. "/.local/share/chezmoi/*" },
	group = vim.api.nvim_create_augroup("chezmoi", { clear = true }),
	callback = function(ev)
		local bufnr = ev.buf
		local edit_watch = function()
			require("chezmoi.commands.__edit").watch(bufnr)
		end
		vim.schedule(edit_watch)
	end,
})

-- show cursor line only in active window
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
	callback = function()
		if vim.w.auto_cursorline then
			vim.wo.cursorline = true
			vim.w.auto_cursorline = nil
		end
	end,
})
vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
	callback = function()
		if vim.wo.cursorline then
			vim.w.auto_cursorline = true
			vim.wo.cursorline = false
		end
	end,
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

function Fd(file_pattern, _)
	-- if first char is * then fuzzy search
	if file_pattern:sub(1, 1) == "*" then
		file_pattern = file_pattern:gsub(".", ".*%0") .. ".*"
	end
	local cmd = 'fd  --color=never --full-path --type file --hidden --exclude=".git" --exclude="deps" "'
	    .. file_pattern
	    .. '"'
	local result = vim.fn.systemlist(cmd)
	return result
end

vim.opt.findfunc = "v:lua.Fd"
vim.keymap.set("n", "<C-p>", ":find ", { desc = "raw-dog: Project Files" })


vim.api.nvim_create_autocmd('FileType', {
	pattern = _G.treesitter,
	callback = function()
		vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		vim.treesitter.start()
	end,
})
