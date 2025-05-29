-- Main mappings file that requires all other mapping modules

local M = {}

function M.load()
	-- Load all mapping modules
	require("mappings.general")
	require("mappings.lsp")
	require("mappings.terminal")
end

return M
