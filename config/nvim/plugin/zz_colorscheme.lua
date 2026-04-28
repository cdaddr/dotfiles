-- installs and applies the active theme from theme.lua only
local theme_file = vim.fn.stdpath("config") .. "/theme.lua"
local theme = vim.fn.filereadable(theme_file) == 1 and dofile(theme_file) or { nvim = "default", lualine = "auto" }
_G.cdaddr.theme = theme.nvim

-- map colorscheme name prefix to pack src
local packs = {
  kanagawa = "https://github.com/rebelot/kanagawa.nvim",
  catppuccin = { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
  tokyonight = "https://github.com/folke/tokyonight.nvim",
  nord = "https://github.com/gbprod/nord.nvim",
  nordic = "https://github.com/AlexvZyl/nordic.nvim",
}

local prefix = _G.cdaddr.theme:match("^([^%-]+)")
local pack = packs[prefix]
if pack then
  vim.pack.add({ pack })
end

if prefix == "kanagawa" then
  require("kanagawa").setup({
    compile = false,
    commentStyle = { italic = true },
    keywordStyle = { italic = false },
    overrides = function(colors)
      local palette = colors.palette
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

        DiffAdd = { bg = palette.winterGreen, fg = palette.springGreen },
        DiffChange = { bg = palette.winterBlue, fg = palette.springBlue },
        DiffText = { bg = palette.waveBlue2, fg = palette.lightBlue },
        Added = { fg = palette.springGreen },
        Changed = { fg = palette.springBlue },
        Removed = { fg = palette.springRed },

        CursorLine = { bg = palette.sumiInk4 },
        LineNr = { bg = gutter_bg },
        CursorLineNr = { bg = gutter_bg, fg = palette.oniViolet },
        SignColumn = { bg = gutter_bg },
        WinSeparator = { bg = palette.sumiInk1, fg = palette.sumiInk6 },
        StatusLine = { bg = gutter_bg },
        StatusLineNC = { bg = gutter_bg },
        StatusColFold = { fg = palette.sumiInk5, bg = gutter_bg },
        Folded = { bg = palette.sumiInk1 },
        FoldColumn = { bg = gutter_bg },
        EndOfBuffer = { bg = palette.sumiInk1 },
        TabLineSel = { bg = palette.oniViolet, fg = palette.sumiInk0 },

        NormalDark = { fg = palette.oldWhite, bg = palette.sumiInk0 },

        BqfPreviewRange = { bg = palette.waveBlue1 },

        GitSignsChange = { bg = gutter_bg },
        GitSignsAdd = { bg = gutter_bg },
        GitSignsUntracked = { bg = gutter_bg },
        GitSignsDelete = { bg = gutter_bg },

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

        CodeDiffFiller = { fg = palette.oniViolet },
        MiniCursorword = { underdotted = true },
        MiniCursorwordCurrent = { underdotted = true },
        MiniJump = { link = "Search" },
      }
    end,
  })
elseif prefix == "catppuccin" then
  require("catppuccin").setup({
    integrations = {
      treesitter = true,
      mini = { enabled = true, blink = true },
      notify = true,
      snacks = { enabled = true },
      which_key = true,
    },
  })
elseif prefix == "tokyonight" then
  require("tokyonight").setup({
    style = "night",
    dim_inactive = false,
  })
elseif prefix == "nord" then
  require("nord").setup({
    diff = { mode = "bg" },
    borders = true,
    errors = { mode = "bg" },
  })
end

vim.cmd.colorscheme(_G.cdaddr.theme)
