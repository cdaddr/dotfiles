-- deferred: AI completion (FIM ghost text) from a local llama-server, run by the
-- ca.carper.llama-server launch agent; suggestions begin a beat after the UI paints
later(function()
  -- plugin/llama.vim reads this when sourced, so it must be set before vim.pack.add
  vim.g.llama_config = {
    show_info = 0,
    -- two candidates per request so <D-g> has something to cycle to; costs ~0.2s and shorter suggestions
    n_cmpl = 2,
    -- accept/cycle maps are buffer-local and only exist while a suggestion is shown
    keymap_fim_accept_full = "<D-l>",
    keymap_fim_accept_line = "<D-L>",
    keymap_fim_next = "<D-g>",
    keymap_fim_prev = "<D-G>",
    -- everything else off: the defaults are <Tab>, <C-l>/<C-h> and <leader>ll* (the LSP group)
    keymap_fim_trigger = "",
    keymap_fim_accept_word = "",
    keymap_inst_trigger = "",
    keymap_inst_rerun = "",
    keymap_inst_continue = "",
    keymap_inst_accept = "",
    keymap_inst_cancel = "",
    keymap_debug_toggle = "",
  }
  vim.pack.add({ "https://github.com/ggml-org/llama.vim" })

  -- ghost text styled like a comment (as before); the plugin's orange default is lost on :colorscheme
  local function hl()
    vim.api.nvim_set_hl(0, "llama_hl_fim_hint", { link = "Comment" })
  end
  hl()
  vim.api.nvim_create_autocmd("ColorScheme", { group = vim.api.nvim_create_augroup("llama_hl", {}), callback = hl })
end)
