return {
	"3rd/image.nvim",
	enabled = false,
	build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
	ft = "markdown",
	opts = {
		tmux_show_only_in_active_window = true, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
		processor = "magick_cli", -- or "magick_cli"
	},
}
