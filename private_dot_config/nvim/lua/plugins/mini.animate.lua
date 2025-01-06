return {
	"echasnovski/mini.animate",
	version = false,
	lazy = false,
	config = function()
		local mini = require("mini.animate")
		mini.setup({
			scroll = {
				timing = mini.gen_timing.exponential({
					easing = "out",
					duration = 4,
					unit = "step",
				}),
			},
			cursor = {
				-- enable = false,
				timing = mini.gen_timing.quartic({
					easing = "out",
					duration = 180,
					unit = "total",
				}),
			},
		})
	end,
}
