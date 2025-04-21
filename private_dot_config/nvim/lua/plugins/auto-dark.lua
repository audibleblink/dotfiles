local function set_theme(name)
	local cur_theme = require("nvconfig").base46.theme
	require("nvchad.utils").replace_word(cur_theme, name)
	require("nvconfig").base46.theme = name
	require("base46").load_all_highlights()
end

return {
	"f-person/auto-dark-mode.nvim",
	lazy = false,
	update_interval = 1000,
	fallback = "dark",
	opts = {
		set_dark_mode = function()
			set_theme("catppuccin")
		end,
		set_light_mode = function()
			set_theme("one_light")
		end,
	}
}
