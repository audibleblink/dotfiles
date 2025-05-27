return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		lsp = {
			-- signature = { enabled = false },
			-- hover = { enabled = false },
		},

		timeout = 2000,
		fps = 60,
		routes = {
			{
				filter = { find = "No information available" },
				view = "mini",
			},
			{
				filter = { find = "written" },
				view = "mini",
			},
		},
	},
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		-- {
		-- 	"rcarriga/nvim-notify",
		-- 	opts = {
		-- 		timeout = 2000,
		-- 		fps = 60,
		-- 		background_colour = "#000000",
		-- 	},
		-- },
	},
}
