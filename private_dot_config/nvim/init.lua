vim.g.base46_cache = vim.fn.stdpath("data") .. "/nvchad/base46/"
require("options")

---------------------------------- Lazy Plugins -------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({ import = "plugins" })

-- load base46 theme caches
for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
	dofile(vim.g.base46_cache .. v)
end

-----------------------------------Auto-Commands-------------------------------------
-- highlight yanked text for 300ms using the "Visual" highlight group
--
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Reload files if changed externally
--
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
	desc = "Reload files if changed externally",
	command = "if mode() != 'c' | checktime | endif",
	pattern = { "*" },
})

--  Chezmoi autoload/apply
--
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
--
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
	desc = "Show cursor line only in active window",
	callback = function()
		if vim.w.auto_cursorline then
			vim.wo.cursorline = true
			vim.w.auto_cursorline = nil
		end
	end,
})
vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
	desc = "Hide cursor line when leaving insert mode or window",
	callback = function()
		if vim.wo.cursorline then
			vim.w.auto_cursorline = true
			vim.wo.cursorline = false
		end
	end,
})

-- More specific autocmd that only triggers on window focus
--
vim.api.nvim_create_autocmd("BufWinEnter", {
	desc = "Set up quickfix window keybindings",
	pattern = "*",
	group = vim.api.nvim_create_augroup("qf", { clear = true }),
	callback = function()
		if vim.bo.buftype == "quickfix" then
			vim.keymap.set("n", "<c-q>", function()
				vim.cmd("cclose")
			end, { buffer = true })
			vim.keymap.set("n", "<cr>", "<cr>", { buffer = true })
		end
	end,
})

-- Enter insert mode when focusing terminal
--
vim.api.nvim_create_autocmd("WinEnter", {
	desc = "Enter insert mode when focusing terminal",
	pattern = "*",
	group = vim.api.nvim_create_augroup("term_insert", { clear = true }),
	callback = function()
		if vim.bo.buftype == "terminal" then
			vim.cmd("startinsert")
		end
	end,
})

-- Highlight TODO, FIXME, etc. in comments
--
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = "*",
	callback = function()
		vim.fn.matchadd("Todo", "\\(TODO\\|FIXME\\|HACK\\|BUG\\|NOTE\\)")
	end,
})

require("mappings")
