return {
	{
		"MeanderingProgrammer/render-markdown.nvim", -- Make Markdown buffers look beautiful
		ft = { "markdown", "codecompanion" },
		opts = {
			render_modes = true, -- Render in ALL modes
			sign = {
				enabled = false, -- Turn off in the status column
			},
			latex = { enabled = false },
			overrides = {
				filetype = {
					codecompanion = {
						html = {
							tag = {
								buf = { icon = " ", highlight = "CodeCompanionChatIcon" },
								file = { icon = " ", highlight = "CodeCompanionChatIcon" },
								group = { icon = " ", highlight = "CodeCompanionChatIcon" },
								help = { icon = "󰘥 ", highlight = "CodeCompanionChatIcon" },
								image = { icon = " ", highlight = "CodeCompanionChatIcon" },
								symbols = { icon = " ", highlight = "CodeCompanionChatIcon" },
								tool = { icon = "󰯠 ", highlight = "CodeCompanionChatIcon" },
								url = { icon = "󰌹 ", highlight = "CodeCompanionChatIcon" },
							},
						},
					},
				},
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		branch = "main",
		build = ":TSUpdate",
		opts = {
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
			"base",
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
		},

		config = function(_, opts)
			require("nvim-treesitter").install(opts)
			require("nvim-treesitter").setup()

			-- Auto load tree-sitter if we have parser
			vim.api.nvim_create_autocmd("FileType", {
				desc = "Load tree-sitter for supported file types",
				pattern = opts,
				callback = function()
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					vim.treesitter.start()
				end,
			})
		end,
	},
}
