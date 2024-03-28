-- vim: ft=lua foldmarker=[[[,]]] foldlevelstart=0 foldmethod=marker spell:

return {
	{ "tpope/vim-fugitive" },
	{ "someone-stole-my-name/yaml-companion.nvim" },
	{ "tpope/vim-sleuth", lazy = false },
	{ "tpope/vim-surround", lazy = false },
	{ "justinmk/vim-sneak", lazy = false },
	{ "jiangmiao/auto-pairs", lazy = false },
	{ "ellisonleao/glow.nvim", config = true, cmd = "Glow" },
	{ "christoomey/vim-tmux-navigator", lazy = false },
}
