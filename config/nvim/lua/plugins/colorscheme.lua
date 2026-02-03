-- this installs a few themes; current colorscheme is selected in init.lua
-- ... via theme.rb templating, so don't change it manually
local util = require("util")
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
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
        },
      })
    end,
  },

  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night", -- storm, moon, night, day
        dim_inactive = false,
      })
    end,
  },

  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        compile = false,
        commentStyle = { italic = true },
        keywordStyle = { italic = false },
        overrides = function(colors)
          local palette = colors.palette
          local gutter_bg = palette.sumiInk1
          local gutter_bg = palette.sumiInk1
          local normal_bg = palette.sumiInk3
          return {
            NormalFloat = { bg = "none" },
            FloatBorder = { bg = "none" },
            FloatTitle = { bg = "none" },
            Pmenu = { bg = "none" },
            PmenuExtra = { bg = "none" },
            PmenuThumb = { bg = palette.springViolet1 },
            PmenuSbar = { bg = palette.sumiInk4 },
            Visual = { bg = palette.waveBlue2 },
            CursorLine = { bg = palette.sumiInk4 },
            LineNr = { bg = gutter_bg },
            CursorLineNr = { bg = gutter_bg },
            SignColumn = { bg = gutter_bg },
            GitSignsChange = { bg = gutter_bg },
            GitSignsAdd = { bg = gutter_bg },
            GitSignsUntracked = { bg = gutter_bg },
            GitSignsDelete = { bg = gutter_bg },
            WinSeparator = { bg = palette.sumiInk4, fg = palette.oniViolet },
            StatusLine = { bg = gutter_bg },
            StatusLineNC = { bg = gutter_bg },
            Folded = { bg = palette.sumiInk1 },
            FoldColumn = { bg = gutter_bg },

            -- Save an hlgroup with dark background and dimmed foreground
            -- so that you can use it where your still want darker windows.
            -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
            NormalDark = { fg = palette.oldWhite, bg = palette.sumiInk0 },

            -- Popular plugins that open floats will link to NormalFloat by default;
            -- set their background accordingly if you wish to keep them dark and borderless
            LazyNormal = { bg = palette.sumiInk0, fg = palette.oldWhite },
            MasonNormal = { bg = palette.sumiInk0, fg = palette.oldWhite },
            SnacksPickerCursorLine = { bg = normal_bg },
            BlinkCmpMenuBorder = { bg = "none" },
            TreesitterContextLineNumber = { bg = gutter_bg },
            TreesitterContextLineNumberBottom = { bg = gutter_bg },

            RenderMarkdownH1Bg = { bg = palette.waveBlue1, fg = palette.oldWhite },
            RenderMarkdownH2Bg = { bg = palette.waveBlue1, fg = palette.oldWhite },
            RenderMarkdownH3Bg = { bg = palette.waveBlue1, fg = palette.oldWhite },
            RenderMarkdownH4Bg = { bg = palette.waveBlue1, fg = palette.oldWhite },
            RenderMarkdownH5Bg = { bg = palette.waveBlue1, fg = palette.oldWhite },
            RenderMarkdownH6Bg = { bg = palette.waveBlue1, fg = palette.oldWhite },
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
  { "AlexvZyl/nordic.nvim" },
}
