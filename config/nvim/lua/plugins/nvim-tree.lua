return {
  "nvim-tree/nvim-tree.lua",
  lazy = false,
  opts = {
    on_attach = function(bufnr)
      local api = require("nvim-tree.api")

      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end
      api.map.on_attach.default(bufnr)
      vim.keymap.set("n", "<C-[>", api.tree.change_root_to_parent, opts("Up"))
    end,
  },
    -- stylua: ignore
  keys = {
    { "<d-e>", function() require("nvim-tree.api").tree.toggle({ path = "." }) end, mode = { "n" }, desc = "nvim-tree: toggle (cwd)", },
    { "<d-E>", function() require("nvim-tree.api").tree.toggle({ path = vim.fn.expand('%:h') }) end, mode = { "n" }, desc = "nvim-tree: toggle (buffer dir)", },
  },
}
