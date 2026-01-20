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
      border = 'thick',
      inline_pad = 1,
      language_border = '',
    },
    anti_conceal = {
      ignore = {
        code_border = true,
      }
    },
    completions = {
      blink = { enabled = true },
    },
  }
}
