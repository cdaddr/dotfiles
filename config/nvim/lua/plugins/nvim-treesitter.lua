-- modified version of code from this config
-- https://github.com/fredrikaverpil/dotfiles/blob/main/nvim-fredrik/lua/fredrik/plugins/core/treesitter.lua
-- NOTES
-- Custom queries files go in $MYVIMRC/queries, NOT $MYVIMRC/after/queries.  Use `; extends` modeline to
--   extend files loaded later.
--
-- docs: https://tree-sitter.github.io/tree-sitter
--
-- finding query files:
--   :lua= vim.treesitter.query.get_files("sql", "highlights")
--
-- The gist: grammar maps nodes => descriptors, colorscheme maps descriptors => highlight groups
--   sql code `where bar = 123`
--   => parser gives (where (keyword_where) predicate: (binary_expression left: (field name: (identifier)) right: (literal))))))
--   => highlights.scm gives (field name: (identifier)) => @variable.member.sql for `bar`
--   => @variable.member.sql linked to @variable.member (not sure where???)
--   => colorscheme provides highlight for @variable.member
return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    event = "BufRead",
    branch = "main",
    build = ":TSUpdate",
    ---@class TSConfig
    opts = {
      ensure_installed = {
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
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsx",
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
      },
    },
    config = function(_, opts)
      -- install parsers from custom opts.ensure_installed
      if opts.ensure_installed and #opts.ensure_installed > 0 then
        require("nvim-treesitter").install(opts.ensure_installed)
        -- register and start parsers for filetypes
        for _, parser in ipairs(opts.ensure_installed) do
          local filetypes = parser -- In this case, parser is the filetype/language name
          vim.treesitter.language.register(parser, filetypes)

          vim.api.nvim_create_autocmd({ "FileType" }, {
            pattern = filetypes,
            callback = function(event)
              vim.treesitter.start(event.buf, parser)
              vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
          })
        end
      end

      -- Auto-install and start parsers for any buffer
      vim.api.nvim_create_autocmd({ "BufRead" }, {
        callback = function(event)
          local bufnr = event.buf
          local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

          local EXCLUDE = { csv = true, tsv = true }

          -- Skip if no filetype
          if filetype == "" or EXCLUDE[filetype] then
            return
          end

          -- Check if this filetype is already handled by explicit opts.ensure_installed config
          for _, filetypes in pairs(opts.ensure_installed) do
            local ft_table = type(filetypes) == "table" and filetypes or { filetypes }
            if vim.tbl_contains(ft_table, filetype) then
              return -- Already handled above
            end
          end

          -- Get parser name based on filetype
          local parser_name = vim.treesitter.language.get_lang(filetype) -- might return filetype (not helpful)
          if not parser_name then
            return
          end
          -- Try to get existing parser (helpful check if filetype was returned above)
          local parser_configs = require("nvim-treesitter.parsers")
          if not parser_configs[parser_name] then
            return -- Parser not available, skip silently
          end

          local parser_installed = pcall(vim.treesitter.get_parser, bufnr, parser_name)

          if not parser_installed then
            -- If not installed, install parser synchronously
            require("nvim-treesitter").install({ parser_name }):wait(30000)
          end

          -- let's check again
          parser_installed = pcall(vim.treesitter.get_parser, bufnr, parser_name)

          if parser_installed then
            -- Start treesitter for this buffer
            vim.treesitter.start(bufnr, parser_name)
          end
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufRead",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      event = "BufRead",
    },
    opts = {
      multiwindow = true,
      max_lines = 2,
      line_numbers = true,
      time_scope = "inner",
      mode = "cursor",
      separator = "─",
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    lazy = false,
    -- stylua: ignore
    keys = function(_)
      local swap = require("nvim-treesitter-textobjects.swap")
      return {
          { "<leader>xs", function() swap.swap_next("@parameter.inner") end, desc = "Swap with next param" },
          { "<leader>xS", function() swap.swap_previous("@parameter.inner") end, desc = "Swap with prev param" },
        }
    end,
    ---@module "nvim-treesitter-textobjects"
    opts = { multiwindow = true, lookahead = true },
  },
}
