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
  init = function()
    local toggleFormatOnSave = function()
      vim.b.disable_format_on_save = not vim.b.disable_format_on_save
      vim.notify((vim.b.disable_format_on_save and "Disabled" or "Enabled") .. " format-on-save")
    end
    vim.api.nvim_create_user_command("FormatDisable", toggleFormatOnSave, { desc = "Toggle Format-on-save" })
    vim.keymap.set("n", "<leader>uf", toggleFormatOnSave, { desc = "Toggle Format-on-save" })
    vim.keymap.set("n", "<leader>xf", function()
      require("conform").format()
    end, { desc = "Format file" })
  end,
  opts = {
    undojoin = true,
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      rust = { "rustfmt" },
      sql = { "pg_format" },
      json = { "prettierd", "prettier" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      svelte = { "prettierd", "prettier", stop_after_first = true },
      ["*"] = { "codespell" },
      ["_"] = { "trim_whitespace" },
    },
    format_on_save = function(bufnr)
      local conform = require("conform")
      if vim.b.disable_format_on_save then
        return false
      end

      local formatters = conform.list_formatters(bufnr)
      if #formatters > 0 then
        return { timeout_ms = 500 }
      end

      local clients = vim.lsp.get_clients({ bufnr = bufnr })
      for _, client in ipairs(clients) do
        if client.supports_method("textDocument/formatting") then
          return { timeout_ms = 500, lsp_format = "fallback" }
        end
      end

      return false
    end,
  },
}
