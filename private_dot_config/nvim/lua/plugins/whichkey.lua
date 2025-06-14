return {
	"folke/which-key.nvim",
	opts = function()
		dofile(vim.g.base46_cache .. "whichkey")
		return {
			preset = "helix",
		}
	end,
}
