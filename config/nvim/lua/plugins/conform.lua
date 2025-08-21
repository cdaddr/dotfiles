return {
	"stevearc/conform.nvim",
	keys = {
		{
			-- Customize or remove this keymap to your liking
			"<leader>f",
			function()
				require("conform").format({ async = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			-- Conform will run multiple formatters sequentially
			python = { "isort", "black" },
			-- You can customize some of the format options for the filetype (:help conform.format)
			rust = { "rustfmt", lsp_format = "fallback" },
			-- Conform will run the first available formatter
			sql = { "sql_formatter" },
			json = { "prettier" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			svelte = { "prettierd", "prettier", stop_after_first = true },
		},
	},
	-- Set default options
	default_format_opts = {
		lsp_format = "fallback",
	},
	format_on_save = { timeout_ms = 500 },
	init = function()
		-- If you want the formatexpr, here is the place to set it
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function(args)
				require("conform").format({ bufnr = args.buf })
			end,
		})
	end,
}
