-- vim: foldmarker={{{,}}} foldlevel=1 foldmethod=marker
---@diagnostic disable: missing-fields, param-type-mismatch, undefined-field

-- Plugin Init and Config {{{

--- Plugin Declaration {{{
vim.pack.add({
	-- Deps and Extensions
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/nvzone/volt" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	-- Core
	{ src = "https://github.com/audibleblink/i3tab.nvim" },
	{ src = "https://github.com/audibleblink/floaterm" },
	{ src = "https://github.com/alexghergh/nvim-tmux-navigation" },
	{ src = "https://github.com/catppuccin/nvim" },
	{ src = "https://github.com/f-person/auto-dark-mode.nvim" },
	{ src = "https://github.com/folke/lazydev.nvim" },
	{ src = "https://github.com/folke/noice.nvim" },
	{ src = "https://github.com/folke/snacks.nvim" },
	{ src = "https://github.com/folke/sidekick.nvim" },
	{ src = "https://github.com/folke/trouble.nvim" },
	{ src = "https://github.com/jiaoshijie/undotree" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/linrongbin16/lsp-progress.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/nvim-mini/mini.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.7") },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/xvzc/chezmoi.nvim" },
}, { load = true, confirm = false })

--- }}} End: Plugin Declaration

--- auto-dark-mode {{{
require("auto-dark-mode").setup({
	set_dark_mode = function()
		vim.cmd.colorscheme("catppuccin-macchiato")
	end,
	set_light_mode = function()
		vim.cmd.colorscheme("catppuccin-latte")
	end,
	update_interval = 500,
	fallback = "dark",
})
--- }}}

--- blink.cmp {{{
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
--- }}}

--- chezmoi.nvim {{{
require("chezmoi").setup({ edit = { watch = true } })
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

--- i3tab {{{
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		require("i3tab").setup({
			separator_style = "dot",
			show_numbers = false,
			colors = {
				active = {
					fg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg,
					bg = vim.api.nvim_get_hl(0, { name = "TabLineSel" }).bg,
				},
				inactive = {
					fg = vim.api.nvim_get_hl(0, { name = "Normal" }).fg,
					bg = vim.api.nvim_get_hl(0, { name = "TabLineSel" }).fg,
				},
			},
		})
	end,
})
vim.cmd.colorscheme("catppuccin-macchiato")
--- }}}

--- floaterm {{{
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

--- lazydev.nvim {{{
require("lazydev").setup({
	library = {
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
	},
})
--}}}

--- lualine.nvim {{{
--

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
		config = { anchor = "NE", row = "auto", col = "auto" },
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
		last_active = "<C-\\>",
		next = "<C-Space>",
	},
})
--- }}}

--- render-markdown.nvim {{{
require("render-markdown").setup({
	completions = { lsp = { enabled = true } },
	render_modes = true, -- Render in ALL modes

	heading = {
		backgrounds = {
			"RenderMarkdownH5Bg",
			"RenderMarkdownH4Bg",
			"RenderMarkdownH3Bg",
			"RenderMarkdownH2Bg",
			"RenderMarkdownH1Bg",
			"RenderMarkdownH6Bg",
		},
		border = true,
	},
	sign = {
		enabled = false, -- Turn off in the status column },
	},
	latex = { enabled = false },
})
--- }}}

--- sidekick.nvim {{{
require("sidekick").setup({
	nes = {
		enabled = false,
	},
	cli = {
		mux = {
			backend = "tmux",
			enabled = true,
		},
	},
})

vim.keymap.set("n", "<leader>ai", function()
	require("sidekick.cli").toggle()
end, { desc = "Sidekick: Toggle" })

vim.keymap.set("n", "<leader>ap", function()
	require("sidekick.cli").prompt()
end, { desc = "Sidekick: Prompt" })

vim.keymap.set({ "n", "x" }, "<leader>at", function()
	require("sidekick.cli").send({ msg = "{this}" })
end, { desc = "Sidekick: Send Reference" })

vim.keymap.set("n", "<leader>af", function()
	require("sidekick.cli").send({ msg = "{file}" })
end, { desc = "Sidekick: Send File" })

vim.keymap.set("x", "<leader>av", function()
	require("sidekick.cli").send({ msg = "{selection}" })
end, { desc = "Sidekick: Send Literal Selection" })

vim.keymap.set("n", "<leader>an", function()
	local nes = require("sidekick.nes")
	nes.toggle()
	vim.notify("NES is " .. (nes.enabled and "on" or "off"), vim.log.levels.INFO, { title = "Sidekick" })
end, { desc = "Sidekick: Toggle NES" })

vim.keymap.set({ "n", "x" }, "<tab>", function()
	if not require("sidekick").nes_jump_or_apply() then
		return "<Tab>" -- fallback to normal tab
	end
end, { desc = "Sidekick: Next Edit", expr = true })

--- }}}

--- snacks.nvim {{{

---- snacks.setup {{{
require("snacks").setup({
	picker = {
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
					icon = " ",
					key = "c",
					desc = "Neovim Configs",
					action = ":ChezmoiEdit " .. vim.fn.stdpath("config") .. "/init.lua",
				},
				{
					icon = " ",
					key = "d",
					desc = "Dotfiles",
					action = ":lua Snacks.dashboard.pick('files', {cwd = '~/.local/share/chezmoi'})",
				},
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
vim.keymap.set("n", "<leader>cm", function()
	Snacks.dashboard.pick("files", { cwd = "~/.local/share/chezmoi" })
end, { desc = "Source current file" })
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

--- trouble.nvim {{{
require("trouble").setup({
	icons = {
		indent = {
			ws = " ",
			top = "│ ",
			middle = "├╴",
			last = "└╴",
			-- last          = "-╴",
			-- last       = "╰╴", -- rounded
			fold_open = " ",
			fold_closed = " ",
		},
		folder_closed = "",
		folder_open = "",
		kinds = {
			Array = "",
			Boolean = "󰨙",
			Class = "",
			Constant = "󰏿",
			Constructor = "",
			Enum = "",
			EnumMember = "",
			Event = "",
			Field = "",
			File = "",
			Function = "󰊕",
			Interface = "",
			Key = "",
			Method = "󰊕",
			Module = "",
			Namespace = "󰦮",
			Null = "",
			Number = "󰎠",
			Object = "",
			Operator = "",
			Package = "",
			Property = "",
			String = "",
			Struct = "󰆼",
			TypeParameter = "",
			Variable = "󰀫",
		},
	},
	modes = {
		symbols = {
			focus = false,
			win = { position = "left" },
			mode = "lsp_document_symbols",
		},
	},
})

local trouble = require("trouble")

vim.keymap.set("n", "<M-n>", function()
	trouble.toggle({ mode = "symbols" })
end, { desc = "Symbols Outline" })

vim.keymap.set("n", "<leader>xq", function()
	trouble.toggle({ mode = "qflist" })
end, { desc = "Quickfix List (Trouble)" })

vim.keymap.set("n", "<leader>xX", function()
	trouble.toggle({ mode = "diagnostics" })
end, { desc = "Diagnostic List (Trouble)" })

vim.keymap.set("n", "<leader>xx", function()
	trouble.toggle({ mode = "diagnostics", filter = { buf = 0 } })
end, { desc = "Location List (Trouble)" })
--- }}}

--- undotree {{{
require("undotree").setup()
vim.keymap.set("n", "<leader>u", require("undotree").toggle, { noremap = true, silent = true, desc = "UndoTree" })
--- }}}

--- LSP Servers and Configs {{{
require("mason").setup({ max_concurrent_installers = 8 })
require("mason-lspconfig").setup({ ensure_installed = _G.lang_servers })

--- Register completion capabilities universally
vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
})
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
