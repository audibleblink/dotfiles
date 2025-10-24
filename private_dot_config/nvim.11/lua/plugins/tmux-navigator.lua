return {
	"alexghergh/nvim-tmux-navigation",
	keys = { "<C-h>", "<C-j>", "<C-k>", "<C-l>" },
	opts = {
		disable_when_zoomed = false,
		keybindings = {
			left = "<C-h>",
			down = "<C-j>",
			up = "<C-k>",
			right = "<C-l>",
			last_active = "<C-\\>",
			next = "<C-Space>",
		},
	},
}
