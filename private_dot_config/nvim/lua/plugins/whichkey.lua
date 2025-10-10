return {
	"folke/which-key.nvim",
	event = "CursorMoved",
	opts = function()
		dofile(vim.g.base46_cache .. "whichkey")
		return {
			preset = "helix",
		}
	end,
}
