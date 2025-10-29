---@diagnostic disable: param-type-mismatch, undefined-field,  missing-fields
-- vim: foldmarker={{{,}}} foldlevel=1 foldmethod=marker

-- Plugin Specs {{{

local plugins = {

	--- Dependencies & Libraries {{{
	{ "MunifTanjim/nui.nvim", lazy = true },
	{ "nvim-lua/plenary.nvim", lazy = true },
	{ "nvzone/volt", lazy = true },
	-- }}}

	--- Auto Dark Mode {{{
	{
		"f-person/auto-dark-mode.nvim",
		event = "BufReadPost",
		opts = {
			set_dark_mode = function()
				vim.cmd.colorscheme("catppuccin-macchiato")
			end,
			set_light_mode = function()
				vim.cmd.colorscheme("catppuccin-latte")
			end,
			update_interval = 200,
			fallback = "dark",
		},
	},
	-- }}}

	--- Blink.cmp {{{
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },
		version = "1.7.*",
		event = { "InsertEnter", "CmdlineEnter" },
		opts = {
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
					auto_show_delay_ms = 600,
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
				preset = "default",
				["<C-l>"] = { "accept" },
				["<Tab>"] = {
					"snippet_forward",
					function()
						return require("sidekick").nes_jump_or_apply()
					end,
					function()
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
		},
	},
	-- }}}

	--- Catppuccin {{{
	{
		"catppuccin/nvim",
		name = "catppuccin-macchiato",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("catppuccin-macchiato")
		end,
	},
	-- }}}

	--- Chezmoi {{{
	{
		"xvzc/chezmoi.nvim",
		cmd = { "ChezmoiEdit" },
		opts = { edit = { watch = true } },
	},
	-- }}}

	--- Conform {{{
	{
		"stevearc/conform.nvim",
		event = "BufReadPost",
		opts = {
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
				timeout_ms = 2000,
				lsp_format = "fallback",
			},
		},
		config = function(_, opts)
			require("conform").setup(opts)
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
			vim.keymap.set("n", "gm", function()
				require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 10000 })
			end, { desc = "Format Files" })
		end,
	},
	-- }}}

	--- Diffview  {{{
	{
		"sindrets/diffview.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = { "DiffviewOpen", "DiffviewFileHistory" },
		opts = {
			view = {
				merge_tool = {
					layout = "diff3_mixed",
					disable_diagnostics = false,
				},
			},
		},
	},
	-- }}}

	--- Floaterm {{{
	{
		"audibleblink/floaterm",
		opts = {
			mappings = {
				term = function(buf)
					vim.keymap.set({ "n", "t" }, "``", function()
						require("floaterm").toggle()
					end, { buffer = buf })

					vim.keymap.set({ "n", "t" }, "kj", function()
						require("floaterm").toggle()
					end, { buffer = buf })
				end,
			},
		},
		keys = {
			{
				"``",
				function()
					require("floaterm").toggle()
				end,
				{ desc = "Floaterm: Toggle", mode = { "n", "t" } },
			},
			{
				"ghP",
				function()
					require("floaterm.api").open_and_run({ name = "Git", cmd = "git push" })
				end,
				{ desc = "Floaterm: Git Push" },
			},
			{
				"ghl",
				function()
					require("floaterm.api").open_and_run({
						name = "Git",
						cmd = [[git log --graph --decorate --all --pretty=format:"%C(cyan)%h%Creset %C()%s%Creset%n%C(dim italic white)      └─ %ar by %an %C(auto)  %D%n"]],
					})
				end,
				{ desc = "Floaterm: Git Log" },
			},
		},
	},
	-- }}}

	--- Gitsigns {{{
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPost",
		config = function()
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
		end,
	},
	-- }}}

	--- i3tab {{{
	{ "audibleblink/i3tab.nvim", event = "TabNew", opts = { separator_style = "dot" } },
	-- }}}

	--- Lazydev  {{{
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	-- }}}

	--- Lualine & LSP Progress {{{
	{
		"nvim-lualine/lualine.nvim",
		event = "InsertEnter",

		opts = function()
			return {
				options = {
					icons_enabled = true,
					theme = "auto",
					component_separators = "",
					section_separators = { left = "", right = "" },
					globalstatus = true,

					refresh = {
						statusline = 100,
						refresh_time = 60, -- ~60fps
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
			}
		end,
		config = function(_, opts)
			require("lualine").setup(opts)

			-- listen lsp-progress event and refresh lualine
			vim.api.nvim_create_autocmd("User", {
				desc = "ReDraw the lsp_progress in lualine",
				group = vim.api.nvim_create_augroup("lualine_augroup", { clear = true }),
				pattern = "LspProgressStatusUpdated",
				callback = function()
					require("lualine").refresh()
				end,
			})
		end,
	},
	-- }}}

	--- Mason & LSP {{{
	{
		"neovim/nvim-lspconfig",
		enabled = not vim.g.vscode,
		event = { "BufReadPre", "BufNewFile" },
		-- not really deps, but nice to have in one spec
		dependencies = { "mason-org/mason.nvim", "mason-org/mason-lspconfig.nvim" },
		config = function()
			require("mason").setup({ max_concurrent_installers = 8 })
			require("mason-lspconfig").setup({ ensure_installed = _G.lang_servers })

			-- Register LSP configs
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
								disableOrganizeImports = true,
								typeCheckingMode = "off",
								diagnosticMode = "workspace",
								useLibraryCodeForTypes = true,
							},
						},
					},
				},
				denols = {
					filetypes = vim.tbl_extend("keep", { "json", "jsonc" }, vim.lsp.config.denols.filetypes),
				},
			}
			for server, config in pairs(custom) do
				vim.lsp.config(server, config)
			end
		end,
	},
	-- }}}

	--- MDEval.nvim {{{
	{
		"audibleblink/mdeval.nvim",
		ft = "markdown",
		-- dir = "~/Code/mdeval.nvim",
		opts = { require_confirmation = false },
		keys = {
			{
				"<leader>e",
				function()
					require("mdeval").eval_code_block()
				end,
				{ desc = "MDEval" },
			},
			{
				"<leader>E",
				function()
					require("mdeval").clean()
				end,
				{ desc = "MDEvalClean" },
			},
		},
	},
	--- }}}

	--- Mini.nvim Suite {{{
	{
		"nvim-mini/mini.nvim",
		config = function()
			require("mini.align").setup()
			require("mini.bracketed").setup()
			require("mini.comment").setup()
			require("mini.icons").setup()
			require("mini.move").setup()
			require("mini.pairs").setup()
			require("mini.surround").setup()
			require("mini.bufremove").setup()
			vim.keymap.set("n", "<leader>q", require("mini.bufremove").delete, { desc = "Close buffer, keep split" })

			-- mini.ai
			local spec_treesitter = require("mini.ai").gen_spec.treesitter
			require("mini.ai").setup({
				n_lines = 500,
				custom_textobjects = {
					f = spec_treesitter({
						a = "@function.outer",
						i = "@function.inner",
					}),
					m = {
						{ "%b()", "%b[]", "%b{}" },
						"^.().*().$",
					},
				},
			})

			-- mini.clue
			require("mini.clue").setup({
				triggers = {
					{ mode = "n", keys = "<Leader>" },
					{ mode = "x", keys = "<Leader>" },
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
					{ mode = "n", keys = '"' },
					{ mode = "x", keys = '"' },
					{ mode = "i", keys = "<C-r>" },
					{ mode = "c", keys = "<C-r>" },
					{ mode = "n", keys = "<C-w>" },
					{ mode = "n", keys = "z" },
					{ mode = "x", keys = "z" },
				},
				clues = {
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

			-- mini.files
			require("mini.files").setup()
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

					vim.keymap.set("n", "<cr>", function()
						require("mini.files").go_in({ close_on_file = true })
					end, { buffer = buf_id })
					vim.keymap.set("n", "l", function()
						require("mini.files").go_in({ close_on_file = true })
					end, { buffer = buf_id })
					vim.keymap.set("n", "<C-d>", function()
						local cur_directory = vim.fs.dirname(MiniFiles.get_fs_entry().path)
						vim.cmd.tcd(cur_directory)
						vim.notify("TCD: " .. cur_directory, vim.log.levels.INFO)
					end, { buffer = buf_id })
				end,
			})

			-- mini.indentscope
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

			vim.api.nvim_create_autocmd("BufEnter", {
				callback = function()
					if vim.tbl_contains({ "terminal", "help", "nofile" }, vim.bo.buftype) then
						vim.b.miniindentscope_disable = true
					end
				end,
			})

			vim.cmd([[highlight! link MiniIndentscopeSymbol Identifier]])

			-- mini.hipatterns
			require("mini.hipatterns").setup({
				highlighters = {
					fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
					hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
					todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
					note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
					fold1 = { pattern = "%-%-().*(){{%{", group = "Function" },
					fold2 = { pattern = "%-%-%-().*(){{%{", group = "NeogitBranch" },
					fold3 = { pattern = "%-%-%-%-().*(){{%{", group = "Error" },
					hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
				},
			})

			-- mini.snippets
			require("mini.snippets").setup({
				snippets = {
					require("mini.snippets").gen_loader.from_lang(),
				},
			})
		end,
	},
	-- }}}

	--- Noice {{{
	{
		"folke/noice.nvim",
		event = "CmdlineEnter",
		opts = {
			popupmenu = { enabled = true },
			notify = { enabled = true },
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
			timeout = 2000,
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
					filter = { find = "Diagnosing" },
					opts = { skip = true },
				},
				{
					filter = { find = "Successfully applied" },
					view = "mini",
				},
			},
		},
	},
	-- }}}

	--- Render Markdown {{{
	{ "MeanderingProgrammer/render-markdown.nvim", ft = "markdown" },
	-- }}}

	--- Sidekick {{{
	{
		"folke/sidekick.nvim",
		event = "BufReadPost",
		keys = { "<leader>ai" },
		opts = {
			nes = { enabled = false },
			cli = {
				win = {
					keys = {
						hide_n = { "kj", "hide", mode = "t" },
						buffers = { "<leader>b", "buffers", mode = "n", desc = "open buffer picker" },
						prompt = { "<leader>p", "prompt", mode = "n", desc = "insert prompt or context" },
					},
				},
				mux = {
					enabled = true,
					backend = "tmux",
				},
				prompts = {
					commit = function()
						local git_dir = vim.fn.system("git rev-parse --git-dir"):gsub("\n", "")
						git_dir = vim.fs.normalize(git_dir)
						return "/commit @"
							.. git_dir
							.. "/COMMIT_EDITMSG\nEdit that file with the generated commit message"
					end,
				},
			},
		},

		config = function(_, opts)
			require("sidekick").setup(opts)

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
					return "<Tab>"
				end
			end, { desc = "Sidekick: Next Edit", expr = true })
		end,
	},
	-- }}}

	--- Snacks {{{
	{
		"folke/snacks.nvim",
		priority = 1000,
		opts = {
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
						{
							icon = " ",
							key = "f",
							desc = "Find File",
							action = ":lua Snacks.dashboard.pick('files')",
						},
						{
							icon = " ",
							key = "g",
							desc = "Find Text",
							action = ":lua Snacks.dashboard.pick('live_grep')",
						},
						{
							icon = " ",
							key = "r",
							desc = "Recent Files",
							action = ":lua Snacks.dashboard.pick('oldfiles')",
						},
						{
							icon = " ",
							key = "c",
							desc = "Neovim Configs",
							action = ":ChezmoiEdit " .. vim.fn.stdpath("config"),
						},
						{
							icon = " ",
							key = "d",
							desc = "Dotfiles",
							action = ":lua Snacks.dashboard.pick('files', {cwd = '~/.local/share/chezmoi'})",
						},
						{
							icon = "󰒲 ",
							key = "L",
							desc = "Lazy",
							action = ":Lazy",
						},
						{
							icon = " ",
							key = "s",
							desc = "Scratch Buffer",
							action = ":enew | setlocal buftype=nofile bufhidden=hide noswapfile",
						},
						{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
					},
				},
			},
			notifier = {
				style = "fancy",
				timeout = 2000,
			},
			input = { enabled = true },
			quickfile = { enabled = true },
			scroll = {
				animate = {
					easing = "outSine",
				},
			},
			statuscolumn = {
				left = { "sign", "mark" },
				right = { "fold", "git" },
				folds = { open = false, git_hl = true },
			},
			zen = { enabled = true },
		},
		config = function(_, opts)
			require("snacks").setup(opts)

			-- Keymaps
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
				Snacks.picker.files({ dirs = { vim.fn.stdpath("data") .. "/lazy" } })
			end, { desc = "Snacks: Plugins" })
			vim.keymap.set("n", "<leader>fpa", function()
				Snacks.picker.grep({ dirs = { vim.fn.stdpath("data") .. "/lazy" } })
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
		end,
	},
	-- }}}

	--- Tmux Navigation {{{
	{
		"alexghergh/nvim-tmux-navigation",
		keys = { "<C-h>", "<C-j>", "<C-k>", "<C-l>" },
		opts = {
			keybindings = {
				left = "<C-h>",
				down = "<C-j>",
				up = "<C-k>",
				right = "<C-l>",
			},
		},
	},
	-- }}}

	--- Trouble {{{
	{
		"folke/trouble.nvim",

		keys = {
			{
				"<M-n>",
				function()
					require("trouble").toggle({ mode = "symbols" })
				end,
				desc = "Symbols Outline",
			},
			{
				"<leader>xq",
				function()
					require("trouble").toggle({ mode = "qflist" })
				end,
				desc = "Quickfix List (Trouble)",
			},
			{
				"<leader>xX",
				function()
					require("trouble").toggle({ mode = "diagnostics" })
				end,
				desc = "Diagnostic List (Trouble)",
			},
			{
				"<leader>xx",
				function()
					require("trouble").toggle({ mode = "diagnostics", filter = { buf = 0 } })
				end,
				desc = "Location List (Trouble)",
			},
		},
		opts = {
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
		},
	},
	-- }}}

	--- Treesitter {{{

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		branch = "main",
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		branch = "main",

		config = function()
			local ts_lang = {
				"html",
				"css",
				"javascript",
				"typescript",
				"tsx",
				"json",
				"vue",
				"svelte",
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
					vim.treesitter.start()
				end,
			})
		end,
	},
	-- }}}

	--- Undotree {{{
	{
		"jiaoshijie/undotree",
		cmd = "UndotreeToggle",
		keys = {
			{
				"<leader>u",
				function()
					require("undotree").toggle()
				end,
				desc = "UndoTree",
			},
		},
	},
	-- }}}
}

-- }}}

-- Bootstrap lazy.nvim
vim.pack.add({ "https://github.com/folke/lazy.nvim" }, { load = true, confirm = false })
vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/site/pack/core/opt/lazy-nvim")

if not vim.g.lazy_did_setup then
	require("lazy").setup(plugins, {
		lockfile = "~/.local/share/chezmoi/private_dot_config/nvim/lazy.lock",
	})
end
