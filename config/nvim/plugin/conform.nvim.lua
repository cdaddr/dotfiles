vim.pack.add({ 'https://github.com/stevearc/conform.nvim' })

local toggleFormatOnSave = function()
  vim.b.disable_format_on_save = not vim.b.disable_format_on_save
  vim.notify((vim.b.disable_format_on_save and "Disabled" or "Enabled") .. " format-on-save")
end
vim.api.nvim_create_user_command("FormatDisable", toggleFormatOnSave, { desc = "Toggle Format-on-save" })
vim.keymap.set("n", "\\f", toggleFormatOnSave, { desc = "Toggle Format-on-save" })

-- A dedicated conform formatter for the filetype (lua, python, rust, ...) wins.
-- Otherwise, if an LSP advertises formatting (e.g. roslyn for C#), run it. The
-- universal "*" (codespell) and "_" (trim_whitespace) entries match every
-- buffer, so conform.list_formatters() is never empty and the LSP would never
-- get a turn -- check the dedicated filetype key directly instead.
local function wants_lsp_format(bufnr)
  if require("conform").formatters_by_ft[vim.bo[bufnr].filetype] then
    return false
  end
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    if client:supports_method("textDocument/formatting") then
      return true
    end
  end
  return false
end

vim.keymap.set({ "n", "v" }, "<leader>xf", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local opts = { bufnr = bufnr, async = true }
  if wants_lsp_format(bufnr) then
    opts.lsp_format = "first"
  end
  require("conform").format(opts)
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
    css = { "prettierd", "prettier", stop_after_first = true },
    ["*"] = { "codespell" },
    ["_"] = { "trim_whitespace" },
  },
  format_on_save = function(bufnr)
    if vim.b.disable_format_on_save then return false end
    local opts = { timeout_ms = 1500, undojoin = true }
    if wants_lsp_format(bufnr) then
      opts.lsp_format = "first"
      opts.timeout_ms = 2000
    end
    return opts
  end,
})
