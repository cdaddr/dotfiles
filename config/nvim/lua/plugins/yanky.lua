return {
  "gbprod/yanky.nvim",
  config = function ()
    vim.keymap.set({"n","x"}, "p", "<Plug>(YankyPutAfter)")
    vim.keymap.set({"n","x"}, "P", "<Plug>(YankyPutBefore)")
    vim.keymap.set({"n","x"}, "gp", "<Plug>(YankyGPutAfter)")
    vim.keymap.set({"n","x"}, "gP", "<Plug>(YankyGPutBefore)")

    vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
    vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")

    vim.keymap.set("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)")
    vim.keymap.set("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)")
    vim.keymap.set("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)")
    vim.keymap.set("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)")
    require'yanky'.setup {

    }
  end
}
