return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown", "lua" },

  opts = {
    render_modes = { "n", "c", "t", "i" },
    heading = {
      border = true,
      above = "▂",
      below = "▀🮂",
      border_virtual = true,
      -- 『1』『2』『3』『4』『5』『6』『7』『8』『9』『0』
      icons = {
        "⒈ ",
        "⒉ ",
        "⒊ ",
        "⒋ ",
        "⒌ ",
        "⒍ ",
        "⒎ ",
        "⒏ ",
        "⒐ ",
        "⒑ ",
      },
    },
    code = {
      conceal_delimiters = true,
      border = "thick",
      inline_pad = 1,
      position = "right",
      language_border = "",
      highlight_language = "Comment",
      highlight_border = "Constant",
      disable_background = true,
    },
    anti_conceal = {
      ignore = {
        code_border = true,
      },
    },
    completions = {
      lsp = { enabled = true },
      blink = { enabled = true },
    },
    sign = {
      enabled = false,
    },
    patterns = {
      markdown = { disable = false },
    },
  },
}
