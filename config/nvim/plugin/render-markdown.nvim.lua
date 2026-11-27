-- see colorscheme.lua for highlights
-- deferred: markdown rendering; only relevant in markdown buffers
later(function()
  -- config goes in via this global rather than setup(): the plugin/ file sourced
  -- by vim.pack.add calls setup(vim.g.render_markdown_config) and immediately
  -- renders already-open buffers, so a setup() after it flashes the defaults
  vim.g.render_markdown_config = {
    render_modes = { "n", "c", "v", "V", "Vs", "", "i", "R", "Rv" },
    heading = {
      border = true,
      above = "▂",
      below = "▀🮂",
      border_virtual = true,
      -- default 'overlay' left-pads the icon to fill the '#' markers' width, so
      -- deeper headings get indented while h1/h2 (markers <= icon width) don't
      position = "inline",
      -- md-pound; the space after each lets kitty draw it 2 cells wide
      icons = { " 󰐣  ", " 󰐣 󰐣  ", " 󰐣 󰐣 󰐣  ", " 󰐣 󰐣 󰐣 󰐣  ", " 󰐣 󰐣 󰐣 󰐣 󰐣  ", " 󰐣 󰐣 󰐣 󰐣 󰐣 󰐣  " },
    },
    bullet = {
      icons = { "•", "○", "◆", "◇" },
    },
    code = {
      border = "thin",
      position = "left",
      disable_background = { "diff" },
      width = "block",
    },
    anti_conceal = {
      ignore = { code_border = false },
    },
    completions = {
      lsp = { enabled = true },
      blink = { enabled = true },
    },
    quote = { repeat_linebreak = true },
    sign = { enabled = false },
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
      showbreak = { default = vim.o.showbreak, rendered = "  " },
      breakindent = { default = vim.o.breakindent, rendered = true },
      breakindentopt = { default = vim.o.breakindentopt, rendered = "" },
    },
  }
  vim.pack.add({ "https://github.com/MeanderingProgrammer/render-markdown.nvim" })
end)
