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
  "c_sharp",
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
  "xml", -- .csproj/.props/.targets
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

-- `.cs` files get filetype `cs`, but the parser is named `c_sharp`. The loop
-- above keys the FileType autocmd off the parser name, so it misses cs buffers.
vim.treesitter.language.register("c_sharp", "cs")
vim.api.nvim_create_autocmd("FileType", {
  pattern = "cs",
  callback = function(event)
    vim.treesitter.start(event.buf, "c_sharp")
    -- NB: nvim-treesitter (main) ships no `indents.scm` for c_sharp, so the
    -- treesitter indentexpr returns 0 for every line (<CR> jumps to col 0).
    -- Leave indentexpr alone so the built-in `indent/cs.vim` (cindent-based
    -- GetCSIndent) handles auto-indent.
  end,
})

-- nvim-treesitter's html/svelte/css indent queries deliberately leave the body
-- of <script>/<style> at column 0 (upstream: "script/style elements aren't
-- indented"). With content present, treesitter anchors to the first body line's
-- indent and keeps things correct; it only falls to 0 on the *first* body line of
-- an empty block, so `<script lang="ts"><CR>` lands at column 0. prettier
-- (svelteIndentScriptAndStyle, on by default) indents the body one level, so bump
-- just that first-line case. Registered after the loop above to override the plain
-- indentexpr set there.
local ts_indent = require("nvim-treesitter.indent")

function _G.SvelteIndent()
  local lnum = vim.v.lnum
  local indent = ts_indent.get_indent(lnum) or 0
  if indent < 0 then
    return indent
  end
  -- only when the previous non-blank line is the opening <script>/<style> tag
  -- (i.e. we're on the first body line) and the current line is still inside it
  local prevlnum = vim.fn.prevnonblank(lnum)
  if prevlnum >= 1 then
    local ok, parser = pcall(vim.treesitter.get_parser, 0, "svelte")
    if ok and parser then
      local root = parser:parse()[1]:root()
      local pcol = (vim.fn.getline(prevlnum):find("%S") or 1) - 1
      local node = root:named_descendant_for_range(prevlnum - 1, pcol, prevlnum - 1, pcol)
      while node do
        local t = node:type()
        if t == "script_element" or t == "style_element" then
          local srow, _, erow = node:range()
          if (prevlnum - 1) == srow and (lnum - 1) > srow and (lnum - 1) < erow then
            return indent + vim.fn.shiftwidth()
          end
          break
        end
        node = node:parent()
      end
    end
  end
  return indent
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "svelte",
  callback = function()
    vim.bo.indentexpr = "v:lua.SvelteIndent()"
  end,
})

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
