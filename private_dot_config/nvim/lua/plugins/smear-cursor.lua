return {
	"sphamba/smear-cursor.nvim",
	-- enabled = not vim.g.neovide,
	enabled = false,
	event = "VeryLazy",
	opts = {

		-- Smear cursor when switching buffers or windows.
		smear_between_buffers = true,

		-- Smear cursor when moving within line or to neighbor lines.
		-- Use `min_horizontal_distance_smear` and `min_vertical_distance_smear` for finer control
		smear_between_neighbor_lines = true,

		-- Draw the smear in buffer space instead of screen space when scrolling
		scroll_buffer_space = true,

		-- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
		-- Smears will blend better on all backgrounds.
		legacy_computing_symbols_support = false,
	},
}
