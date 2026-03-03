return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown", "lua" },

  -- see colorscheme.lua for highlights
  opts = {
    render_modes = { "n", "c", "v", "V", "Vs", "", "i", "R", "Rv" },
    heading = {
      border = true,
      above = "▂",
      below = "▀🮂",
      border_virtual = true,
      icons = {
        "󰉫 ",
        "󰉬 ",
        "󰉭 ",
        "󰉮 ",
        "󰉯 ",
        "󰉰 ",
      },
    },
    code = {
      border = "thin",
      -- inline_pad = 1,
      position = "left",
      -- language_border = "",
      -- highlight_language = "Comment",
      -- highlight_border = "Constant",
      disable_background = { "diff" },
      width = "block",
    },
    anti_conceal = {
      ignore = {
        code_border = false,
      },
    },
    completions = {
      lsp = { enabled = true },
      blink = { enabled = true },
    },
    quote = {
      repeat_linebreak = true, -- this might not do anything?
    },
    sign = {
      enabled = false,
    },
    patterns = {
      markdown = {
        disable = true,
        directives = {
          { id = 17, name = "conceal_lines" },
          { id = 18, name = "conceal_lines" },
        },
      },
    },
    win_options = {
      showbreak = {
        default = vim.o.showbreak,
        rendered = "  ",
      },
      breakindent = {
        default = vim.o.breakindent,
        rendered = true,
      },
      breakindentopt = {
        default = vim.o.breakindentopt,
        rendered = "",
      },
    },
  },
}
