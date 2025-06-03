return {
	"echasnovski/mini.nvim",
	config = function()
		-- Better Around/Inside textobjects
		require("mini.ai").setup({ n_lines = 500 })
		require("mini.align").setup()
		require("mini.comment").setup()
		require("mini.move").setup()
		require("mini.jump").setup()
		require("mini.surround").setup()
		require("mini.bracketed").setup()
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

		local disabled = {
			"help",
			"terminal",
		}

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "*",
			callback = function()
				if disabled[vim.bo.filetype] ~= nil or vim.bo.buftype ~= "" then
					vim.b.miniindentscope_disable = true
				end
			end,
		})

		vim.cmd([[highlight! link MiniIndentscopeSymbol Identifier]])
	end,
}
