return {
  "windwp/nvim-autopairs",
  config = function(opts)
    local npairs = require("nvim-autopairs")
    opts.check_ts = true
    opts.enable_check_bracket_line = true
    opts.ignored_next_char = "[%w%.]"
    opts.map_cr = true
    return opts
  end
}
