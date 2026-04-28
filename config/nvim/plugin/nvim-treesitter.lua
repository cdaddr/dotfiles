-- modified version of code from this config
-- https://github.com/fredrikaverpil/dotfiles/blob/main/nvim-fredrik/lua/fredrik/plugins/core/treesitter.lua

vim.pack.add({
  { src = "git@github.com:cdaddr/ts-autotag.nvim.git", name = "ts-autotag" },
})
require("ts-autotag").setup({
  filetypes = { "typescript", "javascript", "xml", "html", "templ", "svelte" },
  auto_close = { enabled = true },
  auto_rename = { enabled = true },
})

-- run TSUpdate after install/update
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    if ev.data.spec.name == "nvim-treesitter" and ev.data.kind == "update" then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})

vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-context", name = "treesitter-context" },
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
    version = "main",
  },
})

local ensure_installed = {
  "bash",
  "c",
  "clojure",
  "comment",
  "css",
  "git_config",
  "gitcommit",
  "gitignore",
  "go",
  "gotmpl",
  "html",
  "javascript",
  "jsdoc",
  "json",
  "jsx",
  "just",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "nginx",
  "python",
  "regex",
  "ruby",
  "rust",
  "scss",
  "scheme",
  "sql",
  "ssh_config",
  "svelte",
  "toml",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
  "zsh",
}

-- install parsers from ensure_installed
if #ensure_installed > 0 then
  require("nvim-treesitter").install(ensure_installed)
  for _, parser in ipairs(ensure_installed) do
    vim.treesitter.language.register(parser, parser)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = parser,
      callback = function(event)
        vim.treesitter.start(event.buf, parser)
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end
end

-- auto-install and start parsers for any buffer
vim.api.nvim_create_autocmd("BufRead", {
  callback = function(event)
    local bufnr = event.buf
    local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

    local EXCLUDE = { csv = true, tsv = true }
    if filetype == "" or EXCLUDE[filetype] then
      return
    end

    for _, ft in ipairs(ensure_installed) do
      if ft == filetype then
        return
      end
    end

    local parser_name = vim.treesitter.language.get_lang(filetype)
    if not parser_name then
      return
    end

    local parser_configs = require("nvim-treesitter.parsers")
    if not parser_configs[parser_name] then
      return
    end

    local parser_installed = pcall(vim.treesitter.get_parser, bufnr, parser_name)
    if not parser_installed then
      require("nvim-treesitter").install({ parser_name }):wait(30000)
    end

    parser_installed = pcall(vim.treesitter.get_parser, bufnr, parser_name)
    if parser_installed then
      pcall(vim.treesitter.start, bufnr, parser_name)
    end
  end,
})

require("treesitter-context").setup({
  multiwindow = true,
  max_lines = 5,
  min_window_height = 10,
  line_numbers = false,
  trim_scope = "inner",
  mode = "cursor",
  separator = false,
})

local swap = require("nvim-treesitter-textobjects.swap")
require("nvim-treesitter-textobjects").setup({ multiwindow = true, lookahead = true })
vim.keymap.set("n", "<leader>xs", function()
  swap.swap_next("@parameter.inner")
end, { desc = "Swap with next param" })
vim.keymap.set("n", "<leader>xS", function()
  swap.swap_previous("@parameter.inner")
end, { desc = "Swap with prev param" })
