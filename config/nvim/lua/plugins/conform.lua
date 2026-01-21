return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				local conform = require("conform")
				local bufnr = vim.api.nvim_get_current_buf()

				-- Check if conform has formatters for this buffer
				local formatters = conform.list_formatters(bufnr)
				if #formatters > 0 then
					conform.format({ bufnr = bufnr, async = true })
					return
				end

				-- Fallback to LSP if available
				local clients = vim.lsp.get_clients({ bufnr = bufnr })
				for _, client in ipairs(clients) do
					if client.supports_method("textDocument/formatting") then
						vim.lsp.buf.format({ bufnr = bufnr, async = true })
						return
					end
				end

				-- Fallback to vim native formatting
				local view = vim.fn.winsaveview()
				vim.cmd("normal! gggqG")
				vim.fn.winrestview(view)
			end,
			mode = { "n", "v" },
			desc = "Format buffer",
		},
	},
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			rust = { "rustfmt" },
			sql = { "sql_formatter" },
			json = { "prettier" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			svelte = { "prettierd", "prettier", stop_after_first = true },
			["*"] = { "codespell" },
			["_"] = { "trim_whitespace" },
		},
		format_on_save = function(bufnr)
			local conform = require("conform")

			-- Check if conform has formatters
			local formatters = conform.list_formatters(bufnr)
			if #formatters > 0 then
				return { timeout_ms = 500 }
			end

			-- Check if LSP can format
			local clients = vim.lsp.get_clients({ bufnr = bufnr })
			for _, client in ipairs(clients) do
				if client.supports_method("textDocument/formatting") then
					return { timeout_ms = 500, lsp_format = "fallback" }
				end
			end

			-- No formatter available, skip format on save
			-- (vim native gq isn't appropriate for auto-save)
			return false
		end,
	},
}
