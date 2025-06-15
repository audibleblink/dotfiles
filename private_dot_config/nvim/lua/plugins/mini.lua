return {
	"echasnovski/mini.nvim",
	config = function()
		-- Better Around/Inside textobjects
		require("mini.ai").setup({ n_lines = 500 })
		require("mini.align").setup()
		require("mini.bracketed").setup()
		require("mini.comment").setup()
		require("mini.diff").setup()
		require("mini.move").setup()
		require("mini.surround").setup()
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
		require("mini.bufremove").setup()
		vim.keymap.set("n", "<leader>bc", function()
			require("mini.bufremove").delete()
		end, { desc = "Close buffer, keep split" })

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
