return {
	"audibleblink/i3tab.nvim",
	event = "TabNewEntered",
	opts = {
		separator_style = "dot",
		theme_integration = { base46 = true },
		show_numbers = false,
		-- separators = { blah = { left = "", right = "" } },
		-- position = "center",
		-- padding = "",
		-- spacing = " ",
	},

	config = function(_, opts)
		require("i3tab").setup(opts)
		require("base46").load_all_highlights()
	end,
	-- dir = vim.fn.expand("~/code/i3tab.nvim"), -- with expansion
	-- dev = true, -- optional: marks as development plugin
}
