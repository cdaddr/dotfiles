return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown", "lua" },

  opts = {
    heading = {
      border = true,
      -- 『1』『2』『3』『4』『5』『6』『7』『8』『9』『0』
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
      blink = { enabled = true },
    },
    sign = {
      enabled = false,
    },
  },
}
