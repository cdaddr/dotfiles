-- modified version of code from this config
-- https://github.com/fredrikaverpil/dotfiles/blob/main/nvim-fredrik/lua/fredrik/plugins/core/treesitter.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    event = "BufRead",
    branch = "main",
    build = ":TSUpdate",
    ---@class TSConfig
    opts = {
      -- custom handling of parsers
      ensure_installed =
      {
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
        "ssh_config",
        "svelte",
        "toml",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
        "zsh",
      }
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

          -- Skip if no filetype
          if filetype == "" then
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
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    lazy = false,
    keys = {
      {"<leader>xs", function() require("nvim-treesitter-textobjects.swap").swap_next "@parameter.inner" end, desc = "Swap with next node", mode = {'n'} },
      {"<leader>xS", function() require("nvim-treesitter-textobjects.swap").swap_previous "@parameter.inner" end, desc = "Swap with next node", mode = {'n'} },
      {"af", function() require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects") end, desc = "Select outer function", mode = { "x", "o" },},
      {"if", function() require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects") end, desc = "Select inner function", mode = { "x", "o" },},
      {"ac", function() require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects") end, desc = "Select outer class", mode = { "x", "o" },},
      {"ic", function() require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects") end, desc = "Select inner class", mode = { "x", "o" },},
      {"as", function() require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals") end, desc = "Select local scope", mode = { "x", "o" },},
    },
    ---@module "nvim-treesitter-textobjects"
    opts = { multiwindow = true },
  },
}
