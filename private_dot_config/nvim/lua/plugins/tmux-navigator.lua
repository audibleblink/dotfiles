return {
	"alexghergh/nvim-tmux-navigation",
	keys = { "<C-h>", "<C-j>", "<C-k>", "<C-l>" },
	config = function()
		require("nvim-tmux-navigation").setup({
			disable_when_zoomed = true,
			keybindings = {
				left = "<C-h>",
				down = "<C-j>",
				up = "<C-k>",
				right = "<C-l>",
				last_active = "<C-\\>",
				next = "<C-Space>",
			},
		})
	end,
}
