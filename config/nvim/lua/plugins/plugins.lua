return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,

    opts = function(_, opts)
      -- input = { enabled = false },
      -- scope = { enabled = false },
      opts.dashboard = { enabled = false }
      opts.scroll = {
        enabled = true,
        animate = {
          enabled = false,
          duration = { step = 5, total = 200 },
          easing = "outExpo",
        },
        animate_repeat = {
          delay = 100, -- delay in ms before using the repeat animation
          duration = { step = 5, total = 100 },
          easing = "outExpo",
        },
      }
      opts.picker = {
        win = {
          input = {
            keys = {
              -- ["<S-CR>"] = { "edit_vsplit", mode = { "i", "n" } },
              -- ["<C-h>"] = { { "edit_split", mode = { "i", "n" } } },
            }
          },
          list = {
            keys = {
              -- ["<S-CR>"] = { { "edit_vsplit" } },
              -- ["<C-h>"] = { { "edit_split" } },
            }
          }
        }
      }
    end,
    keys = function(_, keys)
      keys[#keys + 1] = {
        "<leader>p",
        function()
          local opts = {}
          vim.fn.system("git rev-parse --is-inside-work-tree")
          if vim.v.shell_error == 0 then
            Snacks.picker.git_files()
          else
            Snacks.picker.files({ root = false })
          end
        end,
        desc = "Find Files (Root Dir)",
      }
      return keys
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    prority = 1000,
    config = function()
      vim.cmd.colorscheme("kanagawa")
      local colors = require("kanagawa.colors").setup({ theme = "wave" })
      local palette_colors = colors.palette
      require("kanagawa").setup({
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = palette_colors.sumiInk2,
              },
            },
          },
        },
        overrides = function(colors)
          local theme = colors.theme
          local palette = require("kanagawa.colors").setup({ theme = "wave" }).palette

          return {
            NormalFloat = { bg = "none" },
            FloatBorder = { bg = "none" },
            FloatTitle = { bg = "none" },
            Visual = { bold = true },

            -- Save an hlgroup with dark background and dimmed foreground
            -- so that you can use it where your still want darker windows.
            -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

            -- Popular plugins that open floats will link to NormalFloat by default;
            -- set their background accordingly if you wish to keep them dark and borderless
            LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
          }
        end,
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa",
    },
  },
  { "geigerzaehler/tree-sitter-jinja2" },
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = function(_, opts)
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "]]", false }
      keys[#keys + 1] = { "[[", false }
      -- opts.servers.pyright = {}
      -- opts.servers.rubocop = {}
    end,
  },
  { "rafamadriz/friendly-snippets" },
  { "windwp/nvim-ts-autotag" },
  { "stevearc/oil.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
  },
}
