return {
	"echasnovski/mini.indentscope",
	version = false,
	lazy = false,
	config = function()
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
	end,
}
