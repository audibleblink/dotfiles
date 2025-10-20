-- vim: foldmarker={{{,}}} foldlevel=1 foldmethod=marker

-- AutoCommands {{{

--- UI Related {{{
local ui_helpers = vim.api.nvim_create_augroup("x_ui_helpers", { clear = true })
--- Highlight yanked text for 300ms using the "Visual" highlight group
--
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = ui_helpers,
	callback = function()
		vim.hl.on_yank()
	end,
})

--- Reload files if changed externally
--
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "FocusGained" }, {
	desc = "Reload files if changed externally",
	group = ui_helpers,
	command = "if mode() != 'c' | checktime | endif",
	pattern = { "*" },
})

--- Show cursor line only in active window
--
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
	desc = "Show cursor line only in active window",
	group = ui_helpers,
	callback = function()
		if vim.w.auto_cursorline then
			vim.wo.cursorline = true
			vim.w.auto_cursorline = nil
		end
	end,
})
vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
	desc = "Hide cursor line when leaving insert mode or window",
	group = ui_helpers,
	callback = function()
		if vim.wo.cursorline then
			vim.w.auto_cursorline = true
			vim.wo.cursorline = false
		end
	end,
})

--- }}}

--- FileType {{{
local x_filetypes = vim.api.nvim_create_augroup("x_filetypes", { clear = true })

--- Configure markdown files with spell check, wrapping, folding, and link surround
--
vim.api.nvim_create_autocmd("FileType", {
	desc = "Markdown",
	pattern = "markdown",
	group = x_filetypes,
	callback = function()
		-- Enable spelling and wrap for window
		vim.cmd("setlocal spell wrap")

		-- Fold with tree-sitter
		vim.cmd("setlocal foldmethod=expr foldexpr=v:lua.vim.treesitter.foldexpr()")

		-- Set markdown-specific surrounding in 'mini.surround'
		vim.b.minisurround_config = {
			custom_surroundings = {
				-- Markdown link. Common usage:
				-- `saiwL` + [type/paste link] + <CR> - add link
				-- `sdL` - delete link
				-- `srLL` + [type/paste link] + <CR> - replace link
				L = {
					input = { "%[().-()%]%(.-%)" },
					output = function()
						local link = require("mini.surround").user_input("Link: ")
						return { left = "[", right = "](" .. link .. ")" }
					end,
				},
			},
		}
	end,
})

--- disable buggy animations in completion windows
--
vim.api.nvim_create_autocmd("User", {
	desc = "BUG: Blink <> Snacks.animate incompatibility workaround",
	group = ui_helpers,
	pattern = { "BlinkCmpMenuOpen", "BlinkCmpMenuClose" },
	callback = function(e)
		vim.g.snacks_animate = not require("snacks").animate.enabled()
	end,
})
--- }}}

--- Usability {{{

local x_usability = vim.api.nvim_create_augroup("x_usability", { clear = true })

--- Add fold navigation mappings for init.lua
--- Maps arrow keys to navigate between folds (zj/zk)
--
vim.api.nvim_create_autocmd("FileType", {
	desc = "Mapping for init.lua",
	group = x_usability,
	pattern = "lua",
	callback = function()
		vim.keymap.set("n", "<down>", "zj", { buffer = true })
		vim.keymap.set("n", "<up>", "zk", { buffer = true })
	end,
})

--  Chezmoi: Watch and Save
--
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	desc = "Chezmoi: Apply on Save",
	group = x_usability,
	pattern = { os.getenv("HOME") .. "/.local/share/chezmoi/*" },
	callback = function(ev)
		local bufnr = ev.buf
		local edit_watch = function()
			require("chezmoi.commands.__edit").watch(bufnr)
		end
		vim.schedule(edit_watch)
	end,
})

--- Mimic harpoon, but with the quickfix window
--- Maps: qc to close, 1-4 to jump to item and close, dd to delete item from list
--
vim.api.nvim_create_autocmd("BufWinEnter", {
	desc = "Set up quickfix window keybindings",
	group = x_usability,
	pattern = "quickfix",
	callback = function()
		vim.keymap.set("n", "qc", ":ccl<cr>", { buffer = true })
		vim.keymap.set("n", "<cr>", "<cr>", { buffer = true })

		vim.keymap.set("n", "1", "1G<cr>:ccl<cr>", { buffer = true })
		vim.keymap.set("n", "2", "2G<cr>:ccl<cr>", { buffer = true })
		vim.keymap.set("n", "3", "3G<cr>:ccl<cr>", { buffer = true })
		vim.keymap.set("n", "4", "4G<cr>:ccl<cr>", { buffer = true })

		vim.keymap.set("n", "dd", function()
			local qflist = vim.fn.getqflist()
			table.remove(qflist, vim.fn.line("."))
			vim.fn.setqflist(qflist, "r")
		end, { buffer = true })
	end,
})

-- TODO: Find out who unsets this, making this necessary
vim.api.nvim_create_autocmd("FileType", {
	desc = "Re-set formatoptions",
	group = x_usability,
	pattern = "*",
	callback = function()
		vim.o.formatoptions = "rqnl1j"
	end,
})

--- Enter insert mode when focusing terminal
--
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
	desc = "Inset mode on TermEnter",
	group = x_usability,
	pattern = { "*" },
	callback = function()
		if vim.opt.buftype:get() == "terminal" then
			vim.cmd(":startinsert")
		end
	end,
})
--- }}}

--- Delayed Config {{{

--- Configure LSP settings when LSP attaches to buffer
--- Sets semantic token priority, enables inlay hints, configures diagnostics display
--
vim.api.nvim_create_autocmd("LspAttach", {
	desc = "Run after LSP attaches",
	once = true,
	group = vim.api.nvim_create_augroup("x_lsp", { clear = true }),
	callback = function()
		vim.highlight.priorities.semantic_tokens = 95 -- just below Treesitter
		vim.lsp.inlay_hint.enable()

		-- Toggle LSP inline completions and notify of status
		vim.keymap.set("n", "<leader>ac", function()
			vim.lsp.inline_completion.enable(not vim.lsp.inline_completion.is_enabled())
			vim.notify(
				"LSP inline completions " .. (vim.lsp.inline_completion.is_enabled() and "enabled" or "disabled"),
				vim.log.levels.INFO
			)
		end, { desc = "LSP: Toggle AI Completions" })

		-- defer loading: `vim.diagnostic` - it's a relatively heavy module.
		vim.diagnostic.config({
			update_in_insert = false,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "󰅙",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.INFO] = "󰋼",
					[vim.diagnostic.severity.HINT] = "󰌵",
				},
			},
			virtual_text = { current_line = true, severity = { min = vim.diagnostic.severity.HINT } },
			severity_sort = true,
			underline = true,
			float = { border = "solid", header = "Diagnostics" },
		})
	end,
})

--- }}}

--- Custom Commnands {{{
--- Creates User command to install all Mason packages
--
vim.api.nvim_create_user_command("MasonInstallAll", function()
	local mason_packages = {}
	vim.list_extend(mason_packages, _G.debuggers)
	for _, v in ipairs(require("conform").list_all_formatters()) do
		local fmts = vim.split(v.name:gsub(",", ""), "%s+")
		vim.list_extend(mason_packages, fmts)
	end

	vim.cmd("Mason")
	local mr = require("mason-registry")
	mr.refresh(function()
		for _, tool in ipairs(mason_packages) do
			local pkg = { name = tool, version = nil }
			local p = mr.get_package(pkg.name)

			if not p:is_installed() then
				p:install({ version = pkg.version })
			end
		end
	end)
end, {})

--- Git commit within current session
--- Opens COMMIT_EDITMSG in a new tab and commits on save
--
vim.api.nvim_create_user_command("Commit", function()
	-- This causes git to create COMMIT_EDITMSG but not complete the commit
	vim.fn.system("GIT_EDITOR=true git commit -v")
	local git_dir = vim.fn.system("git rev-parse --git-dir"):gsub("\n", "")
	vim.cmd("tabedit! " .. git_dir .. "/COMMIT_EDITMSG")

	--- Autocmd to complete the git commit when the message file is saved
	--
	vim.api.nvim_create_autocmd("BufWritePost", {
		desc = "Execute git commit",
		pattern = "COMMIT_EDITMSG",
		group = vim.api.nvim_create_augroup("gitcommit", { clear = true }),
		once = true,
		callback = function()
			vim.fn.system("git commit -F " .. vim.fn.expand("%:p"))
		end,
	})
end, {})
vim.keymap.set("n", "ghc", vim.cmd.Commit, { desc = "Git Commit" })

-- }}}

-- }}}
