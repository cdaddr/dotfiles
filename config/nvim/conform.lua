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
      python = { "isort", "black" },
      rust = { "rustfmt" },
      sql = { "sql_formatter" },
      json = { "prettier" },
      javascript = { "prettierd", "prettier", lsp_format = "fallback", stop_after_first = true },
      typescript = { "prettierd", "prettier", lsp_format = "fallback", stop_after_first = true },
      svelte = { "prettierd", "prettier", stop_after_first = true },
      ["*"] = { "codespell" },
      ["_"] = { "trim_whitespace" },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
    format_on_save = { lsp_format = "fallback", timeout_ms = 500 },
    -- init = function()
    --  -- If you want the formatexpr, here is the place to set it
    --  -- vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    --  vim.api.nvim_create_autocmd("BufWritePre", {
    --    pattern = "*",
    --    callback = function(args)
    --      require("conform").format({ bufnr = args.buf })
    --    end,
    --  })
    -- end,
  },
}
