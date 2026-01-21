-- this installs a few themes; current colorscheme is selected in init.lua
-- ... via theme.rb templating, so don't change it manually
return {
  {
    "catppuccin/nvim", name = "catppuccin", priority = 1000,
    config = function()
      require ('catppuccin').setup{
        -- dim_inactive = {
        --   enabled = false,
        --   shade = "dark",
        --   percentage = 0.20,
        -- },
        integrations = {
          treesitter = true,
          mini = {
            enabled = true,
            blink = true,
          },
          notify = true,
          snacks = {
            enabled = true,
          },
          which_key = true,
        }
      }
    end
  },

  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night", -- storm, moon, night, day
        dim_inactive = false,
      })
    end
  },

  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    prority = 1000,
    config = function()
      require("kanagawa").setup({
        compile = false,
        commentStyle = { italic = true },
        keywordStyle = {italic = false },
        overrides = function(colors)
          local theme = colors.theme
          local palette = colors.palette
          local gutter_bg = theme.ui.bg_dim

          return {
            NormalFloat = { bg = gutter_bg },
            FloatBorder = { bg = gutter_bg },
            FloatTitle = { bg = gutter_bg },
            Visual = { bold = true },
            CursorLine = { bg = theme.ui.bg_p1},
            LineNr = { bg = gutter_bg },
            CursorLineNr = { bg = gutter_bg },
            SignColumn = { bg = gutter_bg },
            GitSignsChange = { bg = gutter_bg },
            GitSignsAdd = { bg = gutter_bg },
            GitSignsUntracked = { bg = gutter_bg },
            GitSignsDelete = { bg = gutter_bg },
            WinSeparator = { bg = theme.ui.bg, fg = theme.ui.bg },
            StatusLine = { bg = gutter_bg },
            StatusLineNC = { bg = gutter_bg },
            Folded = { bg = theme.ui.bg_m1, fg = theme.syn.special2 },
            FoldColumn = { bg = gutter_bg },

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
    "gbprod/nord.nvim",
    priority = 1000,
    config = function()
      require("nord").setup({
        diff = { mode = "bg" },
        borders = true,
        errors = { mode = "bg" },
      })
    end,
  },
  { "AlexvZyl/nordic.nvim", }
}
