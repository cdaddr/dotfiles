return {
  "monkoose/neocodeium",
  event = "VeryLazy",
  opts = {
    show_label = false,
    silent = true,
    disable_in_special_buftypes = true,
    single_line = { enabled = false },
    filter = function(bufnr)
      if vim.endswith(vim.api.nvim_buf_get_name(bufnr), ".env") then
        return false
      end
      return true
    end,
  },
  -- stylua: ignore
  keys = {
    { "<D-l>", function() require'neocodeium'.accept() end, mode = "i", desc = "Accept neocodeium" },
    { "<D-L>", function() require'neocodeium'.accept_line() end, mode = "i", desc = "Accept neocodeium line" },
    { "<D-g>", function() require'neocodeium'.cycle() end, mode = "i", desc = "Next neocodeium suggestion" },
    { "<D-G>", function() require'neocodeium'.cycle(-1) end, mode = "i", desc = "Prev neocodeium suggestion" },
  },
}
