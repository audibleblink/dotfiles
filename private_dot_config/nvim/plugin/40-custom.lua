-- vim: foldmarker={{{,}}} foldlevel=0 foldmethod=marker

-- Breadcrumbs {{{

local BREADCRUMB_CONFIG = {
	file_separator = " / ",
	separator = "  ",
	debounce_ms = 200,
	enabled = false,
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
	local hl_comment = vim.api.nvim_get_hl(0, { name = "Comment" })
	local hl_statusline = vim.api.nvim_get_hl(0, { name = "StatusLine" })

	return {
		file = hl_comment.fg and string.format("#%06x", hl_comment.fg),
		separator = hl_comment.fg and string.format("#%06x", hl_comment.fg),
		background = hl_statusline.bg and string.format("#%06x", hl_statusline.bg),
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

--- Check if a position is within a range (uses positive logic for clarity)
local function range_contains_pos(range, line, char)
	local start_line, start_char = range.start.line, range.start.character
	local end_line, end_char = range["end"].line, range["end"].character

	if line < start_line or line > end_line then
		return false
	end
	if line == start_line and char < start_char then
		return false
	end
	if line == end_line and char > end_char then
		return false
	end
	return true
end

--- Find the symbol path at a given position (optimized to stop after first match)
local function find_symbol_path(symbol_list, line, char, path)
	if not symbol_list then
		return false
	end

	for _, symbol in ipairs(symbol_list) do
		if range_contains_pos(symbol.range, line, char) then
			table.insert(path, { name = symbol.name, kind = symbol.kind })
			-- Recurse into children if they exist
			if symbol.children then
				find_symbol_path(symbol.children, line, char, path)
			end
			return true -- Stop searching siblings once we find a match
		end
	end
	return false
end

--- LSP callback for document symbols (config param required by LSP API but unused)
---@diagnostic disable-next-line: unused-local
local function lsp_callback(err, symbols, ctx, _config)
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

	for _, symbol in ipairs(symbols_path) do
		-- Add separator before each symbol (except the very first breadcrumb)
		if #breadcrumbs > 0 then
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

--- Update breadcrumbs with debouncing and proper cleanup
local function breadcrumbs_set()
	-- Check if breadcrumbs are enabled (buffer-local takes precedence)
	local enabled = vim.b.breadcrumbs_enabled
	if enabled == nil then
		enabled = BREADCRUMB_CONFIG.enabled
	end

	if not enabled then
		return
	end

	-- Capture current buffer and window to avoid race conditions
	local bufnr = vim.api.nvim_get_current_buf()
	local win = vim.api.nvim_get_current_win()

	-- Reuse timer instead of creating new ones
	if not breadcrumb_timer then
		breadcrumb_timer = vim.uv.new_timer()
	else
		-- Just stop and restart the existing timer
		breadcrumb_timer:stop()
	end

	breadcrumb_timer:start(
		BREADCRUMB_CONFIG.debounce_ms,
		0,
		vim.schedule_wrap(function()
			-- Verify buffer and window are still valid
			if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_win_is_valid(win) then
				return
			end

			-- Check if any LSP client supports documentSymbol
			local clients = vim.lsp.get_clients({ bufnr = bufnr })
			local has_document_symbol = false
			for _, client in ipairs(clients) do
				if client.server_capabilities.documentSymbolProvider then
					has_document_symbol = true
					break
				end
			end

			if not has_document_symbol then
				return
			end

			local params = vim.lsp.util.make_text_document_params(bufnr)
			if params.uri then
				vim.lsp.buf_request(bufnr, "textDocument/documentSymbol", { textDocument = params }, lsp_callback)
			end
		end)
	)
end

local breadcrumbs_augroup = vim.api.nvim_create_augroup("Breadcrumbs", { clear = true })

vim.api.nvim_create_autocmd("CursorMoved", {
	group = breadcrumbs_augroup,
	callback = breadcrumbs_set,
	desc = "Set breadcrumbs",
})

--- Toggle breadcrumbs globally
local function toggle_breadcrumbs()
	BREADCRUMB_CONFIG.enabled = not BREADCRUMB_CONFIG.enabled

	if BREADCRUMB_CONFIG.enabled then
		breadcrumbs_set()
		vim.notify("Breadcrumbs enabled", vim.log.levels.INFO)
	else
		-- Clear winbar in current window and stop timer
		if breadcrumb_timer then
			breadcrumb_timer:stop()
			breadcrumb_timer:close()
			breadcrumb_timer = nil
		end
		vim.api.nvim_set_option_value("winbar", "", { win = vim.api.nvim_get_current_win() })
		vim.notify("Breadcrumbs disabled", vim.log.levels.INFO)
	end
end

vim.keymap.set("n", "<leader>tb", toggle_breadcrumbs, { desc = "Toggle Breadcrumbs" })

--- }}}
