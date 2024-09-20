return {
	"echasnovski/mini.indentscope",
	version = false,
	lazy = false,
	opts = {
		symbol = "│",
		draw = {
			priority = 2,
			animation = function(s, n)
				return s / n * 20
			end,
		},
	},
}
