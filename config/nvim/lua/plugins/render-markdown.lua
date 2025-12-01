return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },

  config = {
    heading = {
      border = true,
    },
    code = {
      conceal_delimiters = false,
      border = 'none',
      inline_pad = 1,
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
