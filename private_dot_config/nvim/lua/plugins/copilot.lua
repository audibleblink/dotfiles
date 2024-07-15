return {
	"github/copilot.vim",
	cmd = "Copilot",
	config = function()
		vim.cmd([[
    imap <silent><script><expr> <C-;> copilot#Accept("\<CR>")
    let g:copilot_no_tab_map = v:false
  ]])
	end,
}
