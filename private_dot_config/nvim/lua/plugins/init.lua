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
		"audibleblink/i3tab.nvim",
		event = "TabNew",
		opts = {
			separator_style = "dot",
			theme_integration = { base46 = true },
			show_numbers = false,
			-- separators = { blah = { left = "", right = "" } },
			-- position = "center",
			-- padding = "",
			-- spacing = " ",
		},
		-- dir = vim.fn.expand("~/code/i3tab.nvim"), -- with expansion
		-- dev = true, -- optional: marks as development plugin
	},
}
