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
            Pmenu = { bg = "none", fg = palette.oldWhite },
            PmenuExtra = { bg = "none" },
            PmenuThumb = { fg = palette.sumiInk3 },
            PmenuSbar = { bg = palette.sumiInk4 },
            PmenuSel = { link = "Visual" },
            Delimiter = { fg = palette.sumiInk4 },

            CursorLine = { bg = palette.sumiInk4 },
            LineNr = { bg = gutter_bg },
            CursorLineNr = { bg = gutter_bg, fg = palette.oniViolet },
            SignColumn = { bg = gutter_bg },
            WinSeparator = { bg = palette.sumiInk1, fg = palette.oniViolet },
            StatusLine = { bg = gutter_bg },
            StatusLineNC = { bg = gutter_bg },
            StatusColFold = { fg = palette.sumiInk5, bg = gutter_bg },
            Folded = { bg = palette.sumiInk1 },
            FoldColumn = { bg = gutter_bg },
            EndOfBuffer = { bg = palette.sumiInk1 },
            TabLineSel = { bg = palette.oniViolet, fg = palette.sumiInk0 },

            NormalDark = { fg = palette.oldWhite, bg = palette.sumiInk0 },

            BqfPreviewRange = { bg = palette.waveBlue1 },
            -- BqfPreviewBorder = { bg = palette.sumiInk1 },
            -- BqfPreviewTitle = { bg = palette.sumiInk1, fg = palette.oldWhite },

            GitSignsChange = { bg = gutter_bg },
            GitSignsAdd = { bg = gutter_bg },
            GitSignsUntracked = { bg = gutter_bg },
            GitSignsDelete = { bg = gutter_bg },

            LazyNormal = { bg = palette.sumiInk0, fg = palette.oldWhite },
            SnacksPickerCursorLine = { bg = normal_bg },
            TreesitterContextLineNumber = { fg = palette.sumiInk4, bg = palette.sumiInk0 },
            TreesitterContextLineNumberBottom = { bg = gutter_bg, sp = palette.sumiInk4, underline = true },
            TreesitterContextBottom = { bg = gutter_bg, sp = palette.sumiInk4, underline = true },
            TreesitterContextSeparator = { bg = gutter_bg, fg = palette.oniViolet },

            BlinkCmpMenuBorder = { bg = "none" },
            BlinkCmpMenuSelection = { link = "Visual" },
            BlinkCmpLabel = { link = "Pmenu" },
            BlinkCmpKindText = { fg = palette.oldWhite },

            RenderMarkdownCode = { bg = palette.sumiInk2 },
            RenderMarkdownCodeBorder = { bg = palette.sumiInk2 },
            RenderMarkdownH1 = { fg = palette.oniViolet },
            RenderMarkdownH2 = { fg = palette.oniViolet },
            RenderMarkdownH3 = { fg = palette.oniViolet },
            RenderMarkdownH4 = { fg = palette.oniViolet },
            RenderMarkdownH5 = { fg = palette.oniViolet },
            RenderMarkdownH6 = { fg = palette.oniViolet },
            RenderMarkdownH1Bg = { bg = palette.waveBlue1 },
            RenderMarkdownH2Bg = { bg = palette.waveBlue1 },
            RenderMarkdownH3Bg = { bg = palette.waveBlue1 },
            RenderMarkdownH4Bg = { bg = palette.waveBlue1 },
            RenderMarkdownH5Bg = { bg = palette.waveBlue1 },
            RenderMarkdownH6Bg = { bg = palette.waveBlue1 },
            DiffAdd = { fg = palette.springGreen },
            DiffChange = { fg = palette.springBlue },

            CodeDiffFiller = { fg = palette.oniViolet },
            MiniCursorword = { underdotted = true },
            MiniCursorwordCurrent = { underdotted = true },
            MiniJump = { link = "Search" },
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
