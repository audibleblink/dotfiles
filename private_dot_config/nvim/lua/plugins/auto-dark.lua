local function set_theme(name)
	require("nvconfig").base46.theme = name
	require("base46").compile()
	require("base46").load_all_highlights()
end

return {
	"f-person/auto-dark-mode.nvim",
	event = "VeryLazy",
	config = {
		update_interval = 500,
		set_dark_mode = function()
			set_theme("catppuccin-macchiato")
		end,
		set_light_mode = function()
			set_theme("catppuccin-latte")
		end,
	},
}
