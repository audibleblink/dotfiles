-- vim: foldmarker={{{,}}} foldlevel=0 foldmethod=marker

-- Breadcrumbs {{{

--- Global state for breadcrumbs
_G.breadcrumbs_enabled = true

local BREADCRUMB_CONFIG = {
	file_separator = " / ",
	separator = "  ",
}

--- LSP SymbolKind to TreeSitter highlight group mapping
--- Based on LSP specification: https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#symbolKind
local SYMBOL_KIND_TO_TS_GROUP = {
	[1] = "@variable", -- File
	[2] = "@module", -- Module
	[3] = "@namespace", -- Namespace
	[4] = "@module", -- Package
	[5] = "@type", -- Class
	[6] = "@function.method", -- Method
	[7] = "@property", -- Property
	[8] = "@variable.member", -- Field
	[9] = "@constructor", -- Constructor
	[10] = "@type", -- Enum
	[11] = "@type", -- Interface
	[12] = "@function", -- Function
	[13] = "@variable", -- Variable
	[14] = "@constant", -- Constant
	[15] = "@string", -- String
	[16] = "@number", -- Number
	[17] = "@boolean", -- Boolean
	[18] = "@variable", -- Array
	[19] = "@variable", -- Object
	[20] = "@variable", -- Key
	[21] = "@variable", -- Null
	[22] = "@constant", -- EnumMember
	[23] = "@type", -- Struct
	[24] = "@variable", -- Event
	[25] = "@variable", -- Operator
	[26] = "@type.definition", -- TypeParameter
}

--- Icons for common symbol types (requires Nerd Fonts)
--- Only most frequently navigated symbols get icons
local SYMBOL_KIND_TO_ICON = {
	[1] = " ", -- File
	[2] = " ", -- Module
	[3] = "󰦮 ", -- Namespace
	[4] = " ", -- Package
	[5] = " ", -- Class
	[6] = "󰊕 ", -- Method
	[7] = " ", -- Property
	[8] = " ", -- Field
	[9] = " ", -- Constructor
	[10] = " ", -- Enum
	[11] = " ", -- Interface
	[12] = "󰊕 ", -- Function
	[13] = "󰀫 ", -- Variable
	[14] = "󰏿 ", -- Constant
	[15] = " ", -- String
	[16] = "󰎠 ", -- Number
	[17] = "󰨙 ", -- Boolean
	[18] = " ", -- Array
	[19] = " ", -- Object
	[20] = " ", -- Key
	[21] = " ", -- Null
	[22] = " ", -- EnumMember
	[23] = "󰆼 ", -- Struct
	[24] = " ", -- Event
	[25] = " ", -- Operator
	[26] = " ", -- TypeParameter
}

--- Get colors from active colorscheme with fallbacks
local function get_theme_colors()
	-- Try to extract from existing highlight groups
	local hl_filepath = vim.api.nvim_get_hl(0, { name = "Comment" })
	local hl_sep = vim.api.nvim_get_hl(0, { name = "Comment" })
	local hl_winbar_bg = vim.api.nvim_get_hl(0, { name = "StatusLine" })

	return {
		file = hl_filepath.fg and string.format("#%06x", hl_filepath.fg),
		separator = hl_sep.fg and string.format("#%06x", hl_sep.fg),
		background = hl_winbar_bg.bg and string.format("#%06x", hl_winbar_bg.bg),
	}
end

local function setup_breadcrumb_highlights()
	local colors = get_theme_colors()
	vim.api.nvim_set_hl(0, "WinBar", { bg = colors.background })
	vim.api.nvim_set_hl(0, "BreadcrumbFile", { fg = colors.file, bg = colors.background, italic = true })
	vim.api.nvim_set_hl(0, "BreadcrumbSeparator", { fg = colors.separator, bg = colors.background })
end

-- Setup highlights on load and colorscheme change
setup_breadcrumb_highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("BreadcrumbHighlights", { clear = true }),
	callback = setup_breadcrumb_highlights,
	desc = "Update breadcrumb highlights on colorscheme change",
})

local function range_contains_pos(range, line, char)
	local start_line, start_char = range.start.line, range.start.character
	local end_line, end_char = range["end"].line, range["end"].character

	return not (
		line < start_line
		or line > end_line
		or (line == start_line and char < start_char)
		or (line == end_line and char > end_char)
	)
end

local function find_symbol_path(symbol_list, line, char, path)
	if not symbol_list then
		return false
	end

	for _, symbol in ipairs(symbol_list) do
		if range_contains_pos(symbol.range, line, char) then
			table.insert(path, { name = symbol.name, kind = symbol.kind })
			find_symbol_path(symbol.children, line, char, path)
			return true
		end
	end
	return false
end

---@diagnostic disable-next-line: unused-local
local function lsp_callback(err, symbols, ctx, config)
	-- Ensure we're setting the winbar for the correct window
	local win = vim.fn.bufwinid(ctx.bufnr)
	if win == -1 or not vim.api.nvim_win_is_valid(win) then
		return
	end

	if err or not symbols then
		vim.api.nvim_set_option_value("winbar", "", { win = win })
		return
	end

	local file_path = vim.fn.bufname(ctx.bufnr)
	if file_path == "" then
		vim.api.nvim_set_option_value("winbar", "[No Name]", { win = win })
		return
	end

	-- Get cursor position for this specific window
	local pos = vim.api.nvim_win_get_cursor(win)
	local breadcrumbs = {}

	-- Get relative path from LSP root
	local clients = vim.lsp.get_clients({ bufnr = ctx.bufnr })
	if #clients > 0 and clients[1].root_dir then
		local file = vim.fn.fnamemodify(file_path, ":~:."):gsub("/", BREADCRUMB_CONFIG.file_separator)
		breadcrumbs[1] = "  %#BreadcrumbFile#" .. file .. "%*"
	end

	-- Add symbol path
	local symbols_path = {}
	find_symbol_path(symbols, pos[1] - 1, pos[2], symbols_path)

	for i, symbol in ipairs(symbols_path) do
		if i > 1 or #breadcrumbs > 0 then
			table.insert(breadcrumbs, " %#BreadcrumbSeparator#" .. BREADCRUMB_CONFIG.separator .. " %*")
		end
		-- Get TreeSitter highlight group for this symbol kind
		local ts_group = SYMBOL_KIND_TO_TS_GROUP[symbol.kind] or "@text"
		local icon = SYMBOL_KIND_TO_ICON[symbol.kind] or ""
		table.insert(breadcrumbs, "%#" .. ts_group .. "#" .. icon .. symbol.name .. "%*")
	end

	vim.api.nvim_set_option_value("winbar", #breadcrumbs > 0 and table.concat(breadcrumbs, "") or " ", { win = win })
end

-- Debounce timer to avoid excessive LSP requests
local breadcrumb_timer = nil
local function breadcrumbs_set()
	-- Check buffer-local variable first, then fall back to global
	if not vim.b.breadcrumbs_enabled then
		return
	end

	if not _G.breadcrumbs_enabled then
		return
	end

	if breadcrumb_timer then
		breadcrumb_timer:stop()
	end

	breadcrumb_timer = vim.defer_fn(function()
		local bufnr = vim.api.nvim_get_current_buf()
		local params = vim.lsp.util.make_text_document_params(bufnr)

		if params.uri then
			vim.lsp.buf_request(bufnr, "textDocument/documentSymbol", { textDocument = params }, lsp_callback)
		end
	end, 200)
end

local breadcrumbs_augroup = vim.api.nvim_create_augroup("Breadcrumbs", { clear = true })

vim.api.nvim_create_autocmd("CursorMoved", {
	group = breadcrumbs_augroup,
	callback = breadcrumbs_set,
	desc = "Set breadcrumbs",
})

--- Toggle breadcrumbs
local function toggle_breadcrumbs()
	_G.breadcrumbs_enabled = not _G.breadcrumbs_enabled
	if _G.breadcrumbs_enabled then
		breadcrumbs_set()
		vim.notify("Breadcrumbs enabled", vim.log.levels.INFO)
	else
		-- Clear winbar in current window
		vim.api.nvim_set_option_value("winbar", "", { win = vim.api.nvim_get_current_win() })
		vim.notify("Breadcrumbs disabled", vim.log.levels.INFO)
	end
end

vim.keymap.set("n", "<leader>tb", toggle_breadcrumbs, { desc = "Toggle Breadcrumbs" })

--- }}}
