-- note to self: nvim-lspconfig server names, lsp commands (execuatables), and Mason package names can differ.
local servers = {
  "bashls",
  "shfmt",
  "stylua",
  "rubocop",
  "lua_ls",
  "ruby_lsp",
  "jsonls",
  "pyright",
  "ruff",
  "vtsls", --typescript
  "svelte",
  "yamlls",
  "taplo", --toml
  -- "djlsp",
  "html",
}

for _, server in ipairs(servers) do
  vim.lsp.enable(server)
end

local t = vim.lsp.config['html'].filetypes
t[#t+1] = 'htmldjango'

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup("my.lsp", {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local bufnr = args.buf
    local filetype = vim.api.nvim_get_option_value("filetype", {buf=bufnr})

    -- this would enable auto-format buffer on save
    -- if client:supports_method('textDocument/formatting', bufnr) then
    --   vim.api.nvim_create_autocmd("BufWritePre", {
    --     group = vim.api.nvim_create_augroup("my.lsp.format", { clear = false }),
    --     buffer = bufnr,
    --     callback = function()
    --       vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 1000 })
    --     end,
    --   })
    -- end
    if client:supports_method('textDocument/formatting') then
    end

    -- Enable LSP-based folding if supported
    if client.server_capabilities.foldingRangeProvider then
      vim.wo[0][0].foldmethod = 'expr'
      vim.wo[0][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
    end

    vim.bo[bufnr].formatexpr = 'v:lua.vim.lsp.formatexpr(#{timeout_ms:250})'

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {buffer = true})
    vim.keymap.set('n', '<f1>', function() require('pretty_hover').hover() end, {buffer=true})
    vim.keymap.set('n', 'K', function() require('pretty_hover').hover() end, {buffer=true})
    vim.keymap.set('n', '<s-f1>', vim.diagnostic.open_float, {noremap = true, buffer = true})

    vim.keymap.set('n', '<leader>lK', function() require('pretty_hover').hover() end, {buffer=true, desc = "Pretty hover"})
    vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, {buffer=true, desc = "Code_action"})
    vim.keymap.set('n', '<leader>ls', vim.lsp.buf.document_symbol, {buffer=true, desc = "Document_symbol"})
    vim.keymap.set('n', '<leader>lS', vim.lsp.buf.workspace_symbol, {buffer=true, desc = "Workspace symbol"})
    vim.keymap.set('n', '<leader>ld', vim.lsp.buf.declaration, {buffer = true, desc = "Declaration"})
    vim.keymap.set('n', '<leader>lD', vim.lsp.buf.definition, {buffer = true, desc = "Definition"})
    vim.keymap.set('n', '<leader>lt', vim.lsp.buf.type_definition, {buffer = true, desc = "Type definition"})
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.references, {buffer = true, desc = "References"})
    vim.keymap.set('n', '<leader>le', vim.diagnostic.open_float, {noremap = true, buffer = true, desc = "Diagnostic float"})
    vim.keymap.set('n', '<leader>K', vim.diagnostic.open_float, {noremap = true, buffer = true, desc = "Diagnostic float"})
    for _, key in ipairs({'<leader>lE', '<F2>'}) do
      vim.keymap.set('n', key, function()
        vim.diagnostic.setqflist({open = false})
        require'quicker'.open({focus = true})
      end, {noremap = true, buffer = true, desc = "Diagnostic to quickfix"})
    end

    vim.keymap.set('n', '<leader>llf', vim.lsp.buf.format, {noremap = true, buffer = true, desc="Format buffer"})
    vim.keymap.set('n', '<leader>llr', vim.lsp.buf.rename, {noremap = true, buffer = true, desc="Rename file"})
  end
})

