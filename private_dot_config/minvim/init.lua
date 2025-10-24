-- vim: foldmarker={{{,}}} foldlevel=0 foldmethod=marker

-- Options {{{
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

-- }}}

-- Plugin Init and Config {{{

--- Plugin Declaration {{{

vim.pack.add({
	-- Deps and Extensions
	{ src = "https://github.com/MunifTanjim/nui.nvim" }, -- Noice
	{ src = "https://github.com/nvzone/volt" }, -- Floaterm
	{ src = "https://github.com/neovim/nvim-lspconfig" },

	-- Misbehaving or not needed at start time;
	-- Load later in autocmd or with packadd
	{ src = "https://github.com/jiaoshijie/undotree" },
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.7") },
	{ src = "https://github.com/catppuccin/nvim" },
	{ src = "https://github.com/sindrets/diffview.nvim" },
}, { load = false, confirm = false })
vim.cmd.colorscheme("catppuccin-macchiato")

vim.pack.add({
	{ src = "https://github.com/alexghergh/nvim-tmux-navigation" },
	{ src = "https://github.com/audibleblink/floaterm" },
	{ src = "https://github.com/audibleblink/i3tab.nvim" },
	{ src = "https://github.com/folke/noice.nvim" },
	{ src = "https://github.com/folke/snacks.nvim" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/linrongbin16/lsp-progress.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/nvim-mini/mini.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = "https://github.com/stevearc/conform.nvim" },
}, { load = true, confirm = false })

--- }}} End: Plugin Declaration

--- blink.cmp {{{
vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
	pattern = "*",
	once = true,
	callback = function()
		require("blink.cmp").setup({
			cmdline = {
				keymap = { preset = "inherit" },
				completion = { menu = { auto_show = true } },
			},
			completion = {
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 600,
				},
				menu = {
					border = "solid",
					scrollbar = true,
					auto_show = true,
					draw = {
						treesitter = { "lsp" },
						columns = {
							{ "kind_icon" },
							{ "label", "label_description", gap = 1 },
							{ "source_name" },
						},
						components = {
							source_name = {
								text = function(ctx)
									--- you can do this with a map.
									if ctx.source_name == "LSP" then
										return " "
									elseif ctx.source_name == "Snippets" then
										return "󰞘 "
									elseif ctx.source_name == "Buffer" then
										return " "
									end
									return ctx.source_name
								end,
							},
						},
					},
				},
				list = {
					selection = {
						preselect = true,
						auto_insert = false,
					},
				},
				ghost_text = { enabled = false },
			},
			keymap = {
				-- these are insert mode mappings
				preset = "default",
				["<C-l>"] = { "accept" },
				["<Tab>"] = {
					"snippet_forward",
					function() -- sidekick next edit suggestion
						return require("sidekick").nes_jump_or_apply()
					end,
					function() -- if you are using Neovim's native inline completions
						return vim.lsp.inline_completion.get()
					end,
					"fallback",
				},
				["<C-right>"] = {
					function()
						return vim.lsp.inline_completion.select()
					end,
				},
			},
			signature = {
				enabled = true,
				window = {
					border = "none",
				},
			},
			snippets = {
				preset = "mini_snippets",
			},
		})
	end,
})
--- }}}

--- conform.nvim {{{
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff", "isort", "black" },
		rust = { "rustfmt", lsp_format = "fallback" },
		javascript = { "deno", stop_after_first = true },
		go = { "gofumpt", "golines", "goimports-reviser" },
		sh = { "shfmt" },
		lisp = { "cljfmt" },
	},
	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 2000,
		lsp_format = "fallback",
	},
})
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.keymap.set("n", "gm", function()
	require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 10000 })
end, { desc = "Format Files" })
--- }}}

--- diffview.nvim {{{
vim.keymap.set("n", "<leader>d", function()
	vim.cmd.packadd("diffview.nvim")
	require("diffview").setup({
		view = {
			merge_tool = {
				layout = "diff3_mixed",
				disable_diagnostics = false,
			},
		},
	})
	vim.notify("Diffview activated")
end, { noremap = true, silent = true, desc = "UndoTree" })
--- }}}

--- floaterm {{{
vim.keymap.set("n", "``", function()
	require("floaterm").setup({
		size = { h = 70, w = 80 },
		mappings = {
			sidebar = nil,
			term = function(buf)
				vim.keymap.set({ "n", "t" }, "``", function()
					require("floaterm").toggle()
				end, { buffer = buf })
			end,
		},
	})

	vim.keymap.set({ "n", "t" }, "``", require("floaterm").toggle, { desc = "Floaterm: Toggle" })

	vim.keymap.set("n", "ghP", function()
		require("floaterm.api").open_and_run({ name = "Git", cmd = "git push" })
	end, { desc = "[Git] Floaterm: Push" })

	vim.keymap.set("n", "ghl", function()
		require("floaterm.api").open_and_run({
			name = "Git",
			cmd = [[git log --graph --decorate --all --pretty=format:"%C(cyan)%h%Creset %C()%s%Creset%n%C(dim italic white)      └─ %ar by %an %C(auto)  %D%n"]],
		})
	end, { desc = "[Git] Floaterm: Log" })
end, { desc = "Floaterm" })
--- }}}

--- gitsigns.nvim {{{
require("gitsigns").setup({
	on_attach = function(bufnr)
		local gitsigns = require("gitsigns")

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]g", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]g", bang = true })
			else
				gitsigns.nav_hunk("next")
			end
		end, { desc = "[Git] Next Hunk" })

		map("n", "[g", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[g", bang = true })
			else
				gitsigns.nav_hunk("prev")
			end
		end, { desc = "[Git] Prev Hunk" })

		-- Actions
		map("v", "ghs", function()
			gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "[Git] Stage Hunk" })

		map("v", "ghr", function()
			gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "[Git] Reset Hunk" })

		map("n", "ghs", gitsigns.stage_hunk, { desc = "[Git] Stage Hunk" })
		map("n", "ghr", gitsigns.reset_hunk, { desc = "[Git] Reset Hunk" })
		map("n", "ghS", gitsigns.stage_buffer, { desc = "[Git] Stage Buffer" })
		map("n", "ghR", gitsigns.reset_buffer, { desc = "[Git] Reset Buffer" })
		map("n", "ghp", gitsigns.preview_hunk, { desc = "[Git] Preview Hunk" })
		map("n", "ghi", gitsigns.preview_hunk_inline, { desc = "[Git] Preview Hunk Inline" })
		map("n", "ghd", gitsigns.diffthis, { desc = "[Git] Diff This" })

		map("n", "ghb", function()
			gitsigns.blame_line({ full = true })
		end, { desc = "[Git] Blame Hunk" })

		map("n", "ghD", function()
			gitsigns.diffthis("~")
		end, { desc = "[Git] Diff This" })

		map("n", "ghQ", function()
			gitsigns.setqflist("all")
		end, { desc = "[Git] Send All Hunks to QF" })
		map("n", "ghq", gitsigns.setqflist, { desc = "[Git] Send Hunk to QF" })

		-- Motion-based hunk staging
		local function stage_hunk_operator()
			local start_pos = vim.api.nvim_buf_get_mark(0, "[")
			local end_pos = vim.api.nvim_buf_get_mark(0, "]")
			gitsigns.stage_hunk({ start_pos[1], end_pos[1] })
		end

		-- Toggles
		map("n", "ghtb", gitsigns.toggle_current_line_blame, { desc = "[Git] Toggle Line Blame" })
		map("n", "ghtw", gitsigns.toggle_word_diff, { desc = "[Git] Toggle Word Diff" })

		map("n", "gs", function()
			_G._stage_hunk_operator = stage_hunk_operator
			vim.o.operatorfunc = "v:lua._stage_hunk_operator"
			return "g@"
		end, { expr = true, desc = "[Git] Stage hunk with motion" })

		-- Text objects
		map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "[Git] Hunk" })
		map("n", "gss", "gsih", { desc = "[Git] Stage Hunk", remap = true })
	end,
})
--- }}}

--- lualine.nvim {{{

require("lsp-progress").setup({
	client_format = function(_, _, series_messages)
		return #series_messages > 0 and (table.concat(series_messages, ", ")) or nil
	end,
	format = function(client_messages)
		if #client_messages > 0 then
			return table.concat(client_messages, " ")
		end
		return ""
	end,
})

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = "",
		section_separators = { left = "", right = "" },
		globalstatus = true,

		refresh = {
			statusline = 100,
			refresh_time = 33, -- ~60fps
		},
	},
	sections = {
		lualine_a = {
			{
				"mode",
				fmt = function()
					return "󰞷 "
				end,
				separator = { left = "" },
				right_padding = 2,
			},
		},
		lualine_b = { "filename" },
		lualine_c = {
			{
				require("noice").api.status.mode.get_hl,
				cond = require("noice").api.status.mode.has,
				icon = "󰑋",
				color = { fg = "#ff0000" },
			},
			"%=",
			"diagnostics",
		},
		lualine_x = {
			{
				"lsp_status",
				icon = " ",
				ignore_lsp = { "copilot", "stylua" },
			},
			function()
				return require("lsp-progress").progress()
			end,
		},
		lualine_y = { "branch" },
		lualine_z = { { "location", separator = { right = "" }, left_padding = 2 } },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = { "quickfix", "mason", "trouble" },
})
-- listen lsp-progress event and refresh lualine
--
vim.api.nvim_create_autocmd("User", {
	desc = "ReDraw the lsp_progress in lualine",
	group = vim.api.nvim_create_augroup("lualine_augroup", { clear = true }),
	pattern = "LspProgressStatusUpdated",
	callback = function()
		require("lualine").refresh()
	end,
})

--- }}}

--- mini.nvim {{{
require("mini.align").setup()
require("mini.bracketed").setup()
require("mini.comment").setup()
require("mini.icons").setup()
require("mini.move").setup()
require("mini.pairs").setup()
require("mini.surround").setup()
require("mini.bufremove").setup()
vim.keymap.set("n", "<leader>q", require("mini.bufremove").delete, { desc = "Close buffer, keep split" })

---- mini.ai {{{
local spec_treesitter = require("mini.ai").gen_spec.treesitter
require("mini.ai").setup({
	n_lines = 500,
	custom_textobjects = {
		f = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
		m = {
			{ "%b()", "%b[]", "%b{}" },
			"^.().*().$",
		},
	},
})
---}}}

---- mini.clue {{{
require("mini.clue").setup({
	triggers = {
		{ mode = "n", keys = "<Leader>" },
		{ mode = "x", keys = "<Leader>" },
		-- Built-in completion
		{ mode = "i", keys = "<C-x>" },
		{ mode = "n", keys = "g" },
		{ mode = "x", keys = "g" },
		{ mode = "n", keys = "]" },
		{ mode = "n", keys = "[" },
		{ mode = "x", keys = "]" },
		{ mode = "x", keys = "[" },
		{ mode = "n", keys = "'" },
		{ mode = "n", keys = "`" },
		{ mode = "x", keys = "'" },
		{ mode = "x", keys = "`" },
		-- Registers
		{ mode = "n", keys = '"' },
		{ mode = "x", keys = '"' },
		{ mode = "i", keys = "<C-r>" },
		{ mode = "c", keys = "<C-r>" },
		-- Window commands
		{ mode = "n", keys = "<C-w>" },
		-- `z` key
		{ mode = "n", keys = "z" },
		{ mode = "x", keys = "z" },
	},
	clues = {
		-- Enhance this by adding descriptions for <Leader> mapping groups
		require("mini.clue").gen_clues.builtin_completion(),
		require("mini.clue").gen_clues.g(),
		require("mini.clue").gen_clues.marks(),
		require("mini.clue").gen_clues.registers(),
		require("mini.clue").gen_clues.windows(),
		require("mini.clue").gen_clues.z(),
	},
	window = {
		delay = 400,
		config = { anchor = "SE", row = "auto", col = "auto" },
	},
})
---}}}

---- mini.files {{{
require("mini.files").setup()
--- Add bookmarks to every explorer.
vim.api.nvim_create_autocmd("User", {
	desc = "Add MiniFiles Bookmarks",
	pattern = "MiniFilesExplorerOpen",
	callback = function()
		MiniFiles.set_bookmark("w", vim.fn.getcwd, { desc = "Working directory" })
		MiniFiles.set_bookmark("c", vim.fn.stdpath("config"), { desc = "Config" })
	end,
})
vim.keymap.set("n", "-", function()
	require("mini.files").open(vim.api.nvim_buf_get_name(0), false)
end, { desc = "MiniFiles: Open" })

vim.api.nvim_create_autocmd("User", {
	desc = "TCD into dir",
	pattern = "MiniFilesBufferCreate",
	callback = function(event)
		local buf_id = event.data.buf_id
		vim.keymap.set("n", "<C-d>", function()
			local cur_directory = vim.fs.dirname(MiniFiles.get_fs_entry().path)
			vim.cmd.tcd(cur_directory)
			vim.notify("TCD: " .. cur_directory, vim.log.levels.INFO)
		end, { buffer = buf_id })
	end,
})
---}}}

---- mini.hipatterns {{{
require("mini.hipatterns").setup({
	highlighters = {
		fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
		hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
		todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
		note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
		fold1 = { pattern = "%-%-().*(){{%{", group = "Function" },
		fold2 = { pattern = "%-%-%-().*(){{%{", group = "NeogitBranch" },
		fold3 = { pattern = "%-%-%-%-().*(){{%{", group = "Error" },

		-- Highlight hex color strings (`#xxxxxx`) using that color
		hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
	},
})
---}}}

---- mini.indentscope {{{
require("mini.indentscope").setup({
	symbol = "┃",

	draw = {
		delay = 40,
		priority = 2,
		animation = require("mini.indentscope").gen_animation.exponential({
			easing = "in-out",
			duration = 80,
			unit = "total",
		}),
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "help", "terminal" },
	callback = function()
		vim.b.miniindentscope_disable = true
	end,
})

vim.cmd([[highlight! link MiniIndentscopeSymbol Identifier]])
---}}}

---- mini.snippets {{{
require("mini.snippets").setup({
	snippets = {
		require("mini.snippets").gen_loader.from_lang(),
	},
})
---}}}

--- }}}

--- noice.nvim {{{

require("noice").setup({
	popupmenu = { enabled = false },
	lsp = {
		signature = { enabled = false },
		hover = { enabled = false },
		progress = { enabled = false },
	},
	views = {
		cmdline_popup = {
			size = { min_width = 66 },
			position = { row = "90%" },
			border = { style = { "", " ", "", " ", "", " ", "", " " } },
			win_options = { winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder" },
		},
	},
	timeout = 1000,
	fps = 30,
	routes = {
		{
			filter = { find = "No information available" },
			view = "mini",
		},
		{
			filter = { find = "written" },
			view = "mini",
		},
		{
			filter = { find = "Successfully applied" },
			view = "mini",
		},
	},
})

--- }}}

--- nvim-tmux-navigation {{{
require("nvim-tmux-navigation").setup({
	disable_when_zoomed = false,
	keybindings = {
		left = "<C-h>",
		down = "<C-j>",
		up = "<C-k>",
		right = "<C-l>",
	},
})
--- }}}

--- snacks.nvim {{{

---- snacks.setup {{{
require("snacks").setup({
	picker = {
		actions = {
			sidekick_send = function(...)
				return require("sidekick.cli.snacks").send(...)
			end,
		},
		win = {
			input = {
				keys = {
					["kj"] = {
						"close",
						mode = { "n", "i" },
					},
					["<a-a>"] = {
						"sidekick_send",
						mode = { "n", "i" },
					},
				},
			},
		},
		layout = {
			layout = {
				box = "horizontal",
				backdrop = 30,
				width = 0.8,
				height = 0.6,
				border = "solid",
				title = "{title} {live} {flags}",
				title_pos = "center",

				{
					box = "vertical",
					{ win = "list", border = "solid" },
					{ win = "input", height = 1, border = "hpad" },
				},
				{ win = "preview", title = "{preview}", width = 0.6, border = "solid" },
			},
		},
		sources = {
			explorer = {
				jump = { close = true },
				auto_close = true,
			},
		},
	},

	dashboard = {
		preset = {
			header = [[
░▀█▀░▄▀▀▄░█▀▄▀█░▄▀▀▄░█▀▀▄░█▀▀▄░▄▀▀▄░█░░░█
░░█░░█░░█░█░▀░█░█░░█░█▄▄▀░█▄▄▀░█░░█░▀▄█▄▀
░░▀░░░▀▀░░▀░░▒▀░░▀▀░░▀░▀▀░▀░▀▀░░▀▀░░░▀░▀░
  ░█▀▀█░▄▀▀▄░█▀▄▀█░█▀▀░█▀▀
  ░█░░░░█░░█░█░▀░█░█▀▀░▀▀▄
  ░▀▀▀▀░░▀▀░░▀░░▒▀░▀▀▀░▀▀▀]],
			keys = {
				{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
				{ icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
				{ icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
				{
					icon = " ",
					key = "s",
					desc = "Scratch Buffer",
					action = ":enew | setlocal buftype=nofile bufhidden=hide noswapfile",
				},
				{ icon = "󰚰 ", key = "u", desc = "Update Plugins", action = ":lua vim.pack.update()" },
				{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
			},
		},
		sections = {
			{ section = "header" },
			{ section = "keys", gap = 1, padding = 1 },
		},
	},

	input = { enabled = true },

	notifier = { enabled = true },

	quickfile = { enabled = true },

	scroll = {
		animate = {
			-- duration = { step = 50, total = 500 },
			easing = "outSine",
		},
	},

	statuscolumn = {
		left = { "sign" },
		right = { "git", "mark" },
	},

	zen = { enabled = true },
})
---}}}

---- snacks.keymaps {{{
vim.keymap.set("n", "<C-b>", function()
	Snacks.picker.buffers({ layout = "vscode" })
end, { desc = "Snacks: Buffers" })
vim.keymap.set("n", "<C-n>", function()
	Snacks.picker.explorer({ layout = "right" })
end, { desc = "Snacks: Explorer" })
vim.keymap.set("n", "<leader>fa", function()
	Snacks.picker()
end, { desc = "Snacks: Pickers" })
vim.keymap.set("n", "<leader>ff", function()
	Snacks.picker.smart()
end, { desc = "Snacks: Files" })
vim.keymap.set("n", "<leader>fr", function()
	Snacks.picker.recent()
end, { desc = "Snacks: Recent" })
vim.keymap.set("n", "<leader>fs", function()
	Snacks.picker.git_status()
end, { desc = "Snacks: Git Status" })
vim.keymap.set("n", "<leader>fw", function()
	Snacks.picker.grep()
end, { desc = "Snacks: Grep" })
vim.keymap.set("n", "<leader>fpp", function()
	Snacks.picker.files({ dirs = { vim.fn.stdpath("data") .. "/site/pack/core/opt" } })
end, { desc = "Snacks: Plugins" })
vim.keymap.set("n", "<leader>fpa", function()
	Snacks.picker.grep({ dirs = { vim.fn.stdpath("data") .. "/site/pack/core/opt" } })
end, { desc = "Snacks: Grep Plugins" })
vim.keymap.set("n", "<C-c>", function()
	Snacks.picker.cliphist()
end, { desc = "Snacks: Clipboard History" })
vim.keymap.set("n", "<M-r>", function()
	Snacks.picker.registers()
end, { desc = "Registers" })
vim.keymap.set("n", "<leader><Space>", Snacks.picker.resume, { desc = "Snacks: Resume" })
vim.keymap.set("n", "<leader>fh", Snacks.picker.help, { desc = "Snacks: Help" })
vim.keymap.set({ "n", "x" }, "ghx", require("snacks").gitbrowse.open, { desc = "[Git] Open in web" })
---}}}

--- }}}

--- tree-sitter {{{
local ts_lang = {
	-- web dev
	"html",
	"css",
	"javascript",
	"typescript",
	"tsx",
	"json",
	"vue",
	"svelte",
	-- other
	"c",
	"go",
	"rust",
	"glsl",
	"ruby",
	"typst",
	"python",
	"lua",
	"hcl",
	"terraform",
	"markdown",
	"markdown_inline",
	"luadoc",
	"printf",
	"regex",
	"vim",
	"vimdoc",
	"yaml",
}
require("nvim-treesitter").install(ts_lang)

vim.api.nvim_create_autocmd("FileType", {
	desc = "Load tree-sitter for supported file types",
	pattern = ts_lang,
	callback = function()
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		vim.treesitter.start()
	end,
})
--- }}}

--- undotree {{{
vim.keymap.set("n", "<leader>u", function()
	vim.cmd.packadd("undotree")
	require("undotree").toggle()
end, { noremap = true, silent = true, desc = "UndoTree" })
--- }}}

--- LSP Servers and Configs {{{
require("mason").setup({ max_concurrent_installers = 8 })
require("mason-lspconfig").setup({ ensure_installed = _G.lang_servers })

--- Register completion capabilities universally
local custom = {
	ruff = {
		settings = {
			lineLength = 100,
			lint = { preview = true },
			format = { preview = true },
		},
	},
	basedpyright = {
		settings = {
			basedpyright = {
				analysis = {
					disableOrganizeImports = true, -- address conflict w/ ruff
					typeCheckingMode = "off", -- ditto
					diagnosticMode = "workspace",
					useLibraryCodeForTypes = true,
				},
			},
		},
	},
	-- NOTE vim.lsp.config (vim.tbl_deep_extend) doesn't merge lists, so we do it here
	denols = {
		filetypes = vim.tbl_extend("keep", { "json", "jsonc" }, vim.lsp.config.denols.filetypes),
	},
}
for server, config in pairs(custom) do
	vim.lsp.config(server, config)
end
--- }}} End: LSP and Completion

-- }}} End: Plugin Init and Config

-- KeyMaps {{{
---
vim.keymap.set("i", "<C-s>", "<cmd>w<cr>", { desc = "Join w/o cursor moving" })
vim.keymap.set("i", "jk", "<ESC>", { desc = "Escape insert mode" })
vim.keymap.set("n", "<leader>rr", ":update<CR> :source<CR>", { desc = "Source current file" })

--- QoL
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join w/o cursor moving" })
vim.keymap.set("n", "<CR>", ":", { desc = "CMD enter command mode" })
vim.keymap.set("n", "<leader><Tab>", "<cmd> b# <CR>", { desc = "Previous Buffer" })
vim.keymap.set("n", "<left>", "0", { desc = "Jump: Start of line" })
vim.keymap.set("n", "<right>", "$", { desc = "Jump: End of line" })

vim.keymap.set("n", "gp", '"+p', { desc = "Paste" })
vim.keymap.set("n", "gP", 'o<esc>"+p', { desc = "Paste below" })
vim.keymap.set("x", "gp", '"+P', { desc = "Paste overwrite" })
vim.keymap.set("x", "gP", "pgvy", { desc = "Paste without clobber" })

vim.keymap.set({ "n", "x" }, "gy", '"+y', { desc = "Yank" })
vim.keymap.set("n", "gyy", '"+yy', { desc = "Yank Line" })
vim.keymap.set("n", "gY", '"+y$', { desc = "Yank to end" })

vim.keymap.set("n", "q", "", { desc = "Unassing q key" })
vim.keymap.set("n", "\\", "q", { desc = "Macros" })
vim.keymap.set("n", "qo", "<cmd>copen<CR>", { desc = "Open QuickFix" })
vim.keymap.set("n", "qa", function()
	vim.fn.setqflist({ {
		filename = vim.fn.expand("%"),
		lnum = 1,
		col = 1,
		text = vim.fn.expand("%"),
	} }, "a")
end, { desc = "Add current file to QuickFix" })

--- Line numbers
vim.keymap.set("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "Toggle Line number" })
vim.keymap.set("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "Toggle Relative number" })

--- Window management
vim.keymap.set("n", "<leader>zi", "<cmd> wincmd | <CR>:wincmd _ <CR>", { desc = "Zoom Pane" })
vim.keymap.set("n", "<leader>zo", "<cmd> wincmd = <CR>", { desc = "Reset Zoom" })

--- Highlight Searching
vim.keymap.set("n", "c*", "*Ncgn", { desc = "Search and Replace 1x1" })
vim.keymap.set("v", "<C-r>", 'y:%s/<C-r>"//gc<left><left><left>', { desc = "Insert highlight as search string" })

--- Resize w/ Shift + Arrow Keys
vim.keymap.set("n", "<S-Up>", "<cmd>resize +2<CR>") -- Increase height
vim.keymap.set("n", "<S-Down>", "<cmd>resize -2<CR>") -- Decrease height
vim.keymap.set("n", "<S-Right>", "<cmd>vertical resize +5<CR>") -- Increase width
vim.keymap.set("n", "<S-Left>", "<cmd>vertical resize -5<CR>") -- Decrease width

--- Smart highlight cancelling
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

------------------------------------ Brace Match ---------------------------------------
--- NOTE custom objects config'd in mini.ai plugin
vim.keymap.set("n", "mm", "%")
--- Selects until matching pair, ex: `vm`
vim.keymap.set("x", "m", "%")
--- Use with operators, ex: `dm` - delete until matching pair
vim.keymap.set("o", "m", "%")

-------------------------------------- Tabline -----------------------------------------
vim.keymap.set("n", "]t", ":tabnext<CR>", { desc = "Next tab", silent = true })
vim.keymap.set("n", "[t", ":tabprevious<CR>", { desc = "Previous tab", silent = true })

-------------------------------------- Terminal -----------------------------------------
--- Terminal mode escape
--
vim.keymap.set("t", "<C-g>", "<C-\\><C-N>", { desc = "Terminal Escape terminal mode" })

--- Terminal Navigation
local function navigate_from_terminal(direction)
	return "<C-\\><C-N><C-w>" .. direction
end

vim.keymap.set("t", "<C-h>", navigate_from_terminal("h"))
vim.keymap.set("t", "<C-j>", navigate_from_terminal("j"))
vim.keymap.set("t", "<C-k>", navigate_from_terminal("k"))
vim.keymap.set("t", "<C-l>", navigate_from_terminal("l"))

--- }}}

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
		vim.lsp.config("*", {
			capabilities = require("blink.cmp").get_lsp_capabilities(),
		})
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
