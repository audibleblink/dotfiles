local function my_on_attach(bufnr)
	local api = require("nvim-tree.api")
	local map = vim.keymap.set

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	local function edit_or_open()
		local node = api.tree.get_node_under_cursor()
		if node.nodes ~= nil then
			api.node.open.edit()
		else
			api.node.open.edit()
			api.tree.close()
		end
	end

	local function close_node()
		local node = api.tree.get_node_under_cursor()
		if node.nodes ~= nil then
			api.node.open.edit()
		end
	end

	api.config.mappings.default_on_attach(bufnr)

	map("n", "l", edit_or_open, opts("Edit or Open"))
	map("n", "h", close_node, opts("Collapse node"))
	map("n", "]g", api.node.navigate.git.next_recursive, opts("Next Git"))
	map("n", "[g", api.node.navigate.git.prev_recursive, opts("Prev Git"))
	map("n", "]d", api.node.navigate.diagnostics.next_recursive, opts("Next Diag"))
	map("n", "[d", api.node.navigate.diagnostics.prev_recursive, opts("Prev Diag"))
end

return {
	"nvim-tree/nvim-tree.lua",
	keys = { { "<C-n>", "<cmd>NvimTreeFindFileToggle<CR>", desc = "Toggle NvimTree" } },
	opts = {
		on_attach = my_on_attach,
		view = {
			centralize_selection = true,
			side = "right",
			float = {
				quit_on_focus_loss = true,
				enable = false,
				open_win_config = function()
					-- open top right of current window
					local win_width = vim.api.nvim_win_get_width(0)
					local win_height = vim.api.nvim_win_get_height(0)
					local width = math.min(30, win_width)
					local height = math.min(40, win_height)
					return {
						relative = "win",
						border = "rounded",
						width = width,
						height = height,
						row = 2,
						col = win_width,
						anchor = "NE",
					}
				end,
			},
		},
		diagnostics = {
			enable = true,
		},
	},
	config = function(_, opts)
		require("nvim-tree").setup(opts)

		local map = vim.keymap.set
		local api = require("nvim-tree.api")
		map("n", "<leader>e", api.tree.focus, { desc = "Nvimtree Focus window" })
	end,
}
