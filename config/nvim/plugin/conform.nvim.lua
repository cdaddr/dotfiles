vim.pack.add({ 'https://github.com/stevearc/conform.nvim' })

local toggleFormatOnSave = function()
  vim.b.disable_format_on_save = not vim.b.disable_format_on_save
  vim.notify((vim.b.disable_format_on_save and "Disabled" or "Enabled") .. " format-on-save")
end
vim.api.nvim_create_user_command("FormatDisable", toggleFormatOnSave, { desc = "Toggle Format-on-save" })
vim.keymap.set("n", "\\f", toggleFormatOnSave, { desc = "Toggle Format-on-save" })

vim.keymap.set({ "n", "v" }, "<leader>xf", function()
  local conform = require("conform")
  local bufnr = vim.api.nvim_get_current_buf()

  local formatters = conform.list_formatters(bufnr)
  if #formatters > 0 then
    conform.format({ bufnr = bufnr, async = true })
    return
  end

  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    if client.supports_method("textDocument/formatting") then
      vim.lsp.buf.format({ bufnr = bufnr, async = true })
      return
    end
  end

  local view = vim.fn.winsaveview()
  vim.cmd("normal! gggqG")
  vim.fn.winrestview(view)
end, { desc = "Format buffer" })

require('conform').setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },
    rust = { "rustfmt" },
    sql = { "pg_format" },
    json = { "prettierd", "prettier", stop_after_first = true },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    svelte = { "prettierd", "prettier", stop_after_first = true },
    ["*"] = { "codespell" },
    ["_"] = { "trim_whitespace" },
  },
  format_on_save = function(bufnr)
    local conform = require("conform")
    if vim.b.disable_format_on_save then return false end

    local formatters = conform.list_formatters(bufnr)
    if #formatters > 0 then
      return { timeout_ms = 1500, undojoin = true }
    end

    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    for _, client in ipairs(clients) do
      if client.supports_method("textDocument/formatting") then
        return { timeout_ms = 500, lsp_format = "fallback", undojoin = true }
      end
    end

    return false
  end,
})
