vim.g.mapleader = " " -- ensure leader is set so subsequent mappings use it
vim.cmd.packadd("nohlsearch")
vim.loader.enable(true)

vim.o.autoindent = true
vim.o.autoread = true
vim.o.breakindent = true
vim.o.breakindentopt = "list:-1"
-- vim.o.clipboard = "unnamedplus"
vim.o.colorcolumn = "100"
vim.o.complete = ".,w,b,kspell"
vim.o.completeopt = "menuone,noselect,fuzzy,nosort"
vim.o.cursorline = true
vim.o.cursorlineopt = "screenline,number"
vim.o.fillchars = "eob: ,fold:,diff:╱"
vim.o.foldlevel = 10
vim.o.foldnestmax = 10
vim.o.foldtext = ""
vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]
vim.o.formatoptions = "rqnl1j"
vim.o.guifont = "CodeliaLigatures Nerd Font"
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.infercase = true
vim.o.iskeyword = "@,48-57,_,192-255,-"
vim.o.laststatus = 3
vim.o.linebreak = true
vim.o.list = true
vim.o.listchars = "extends:…,nbsp:␣,precedes:…,tab:  "
vim.o.mouse = "a"
vim.o.number = true
vim.o.numberwidth = 1
vim.o.pumheight = 10
vim.o.relativenumber = true
vim.o.scrolloff = 4
vim.o.shortmess = "CFIOSWaco"
vim.o.showmode = false
vim.o.signcolumn = "yes"
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.spelloptions = "camel"
vim.o.splitbelow = true
vim.o.splitkeep = "screen"
vim.o.splitright = true
vim.o.swapfile = false
vim.o.switchbuf = "usetab"
vim.o.tabstop = 4
vim.o.termguicolors = true
vim.o.timeoutlen = 500
vim.o.undofile = true
vim.o.virtualedit = "block"
vim.o.winborder = "solid"
vim.o.wrap = false
vim.o.whichwrap = "<>[]hl,b,s"

--- add binaries installed by mise
vim.env.PATH = vim.env.PATH .. ":" .. vim.env.XDG_DATA_HOME .. "/mise/shims"

--- Create project-specific shada-files
vim.o.shadafile = (function()
	local git_root = vim.fs.root(0, ".git")
	if not git_root then
		return
	end
	local shadafile = vim.fs.joinpath(vim.fn.stdpath("state"), "_shada", vim.base64.encode(git_root))
	vim.fn.mkdir(vim.fs.dirname(shadafile), "p")
	return shadafile
end)()

--- Globals
---
_G.debuggers = {
	"delve",
	"debugpy",
}

_G.lang_servers = {
	"basedpyright",
	"copilot",
	"denols",
	"gopls",
	"lua_ls",
	"markdown_oxide",
	"ruff",
	"rust_analyzer",
	"tinymist",
	"yamlls",
	"zls",
}
