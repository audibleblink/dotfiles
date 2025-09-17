return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	opts = {

		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff", "isort", "black" },
			rust = { "rustfmt", lsp_format = "fallback" },
			javascript = { "deno", stop_after_first = true },
			go = { "gofumpt", "golines", "goimport-reviser" },
			sh = { "shfmt" },
			lisp = { "cljfmt" },
		},

		format_on_save = {
			-- These options will be passed to conform.format()
			timeout_ms = 500,
			lsp_format = "fallback",
		},
	},

	config = function(_, opts)
		require("conform").setup(opts)
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		vim.keymap.set("n", "gm", function()
			require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 10000 })
		end, { desc = "Format Files" })
	end,
}
