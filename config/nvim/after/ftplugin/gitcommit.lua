vim.b.minihipatterns_config = {
  highlighters = {
    conventional_commits = {
      pattern = {
        "%f[%w]()fix():%f[%s]",
        "%f[%w]()feat():%f[%s]",
        "%f[%w]()perf():%f[%s]",
        "%f[%w]()chore():%f[%s]",
        "%f[%w]()refactor():%f[%s]",
        "%f[%w]()text():%f[%s]",
      },
      group = "MiniHipatternsNote",
    },
  },
}
