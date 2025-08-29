return {
	{
		"nvchad/ui",
		config = function()
			require("nvchad")
		end,
	},

	{
		"nvchad/base46",
		lazy = true,
		build = function()
			require("base46").load_all_highlights()
		end,
	},

	{
		"nvzone/typr",
		dependencies = "nvzone/volt",
		opts = {},
		cmd = { "Typr", "TyprStats" },
	},
	{
		"nvzone/timerly",
		dependencies = "nvzone/volt",
		cmd = "TimerlyToggle",
		opts = {}, -- optional
	},
	{
		"chomosuke/typst-preview.nvim",
		ft = "typst",
		version = "1.*",
	},

	{
		"i3tab",
		dir = vim.fn.expand("~/Code/pill-tabline.nvim"), -- with expansion
		dev = true, -- optional: marks as development plugin
		opts = {},
	},
}
