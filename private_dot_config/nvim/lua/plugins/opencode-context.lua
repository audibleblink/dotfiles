return {
	"audibleblink/opencode-context.nvim",
	opts = {
		-- tmux_target = "LOCAL:5.0", -- Manual override: "session:window.pane"
		tmux_target = nil, -- Manual override: "session:window.pane"
		auto_detect_pane = true, -- Auto-detect opencode pane in current window
	},
	keys = {
		{ "<leader>oc", "<cmd>OpencodeSend<cr>", desc = "Send prompt to opencode" },
		{ "<leader>oc", "<cmd>OpencodeSend<cr>", mode = "v", desc = "Send prompt to opencode" },
		{ "<leader>ot", "<cmd>OpencodeSwitchMode<cr>", desc = "Toggle opencode mode" },
		{ "<leader>op", "<cmd>OpencodePrompt<cr>", desc = "Open opencode persistent prompt" },
	},
	cmd = { "OpencodeSend", "OpencodeSwitchMode" },
}
