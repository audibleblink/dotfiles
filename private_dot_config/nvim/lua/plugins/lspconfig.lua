return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			require("configs.null-ls")
		end,
	},
	config = function()
		require("nvchad.configs.lspconfig").defaults()
		require("configs.lspconfig")
	end,
}
