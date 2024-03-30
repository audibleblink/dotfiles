return {
	"okuuva/auto-save.nvim",
	-- cmd = "ASToggle", -- optional for lazy loading on command
	enabled = false,
	event = { "InsertLeave" }, -- optional for lazy loading on trigger events
	opts = {
		trigger_events = {
			immediate_save = { "BufLeave" }, -- vim events that trigger an immediate save
			-- defer_save = { "InsertLeave" }, -- vim events that trigger a deferred save (saves after `debounce_delay`)
		},
		debounce_delay = 2000,
	},
}
