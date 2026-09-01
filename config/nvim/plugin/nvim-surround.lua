-- deferred: surround edits; default keys apply until this loads (a beat post-UI)
later(function()
  vim.pack.add({ "https://github.com/kylechui/nvim-surround" })
  local cfg = require("nvim-surround.config")
  require("nvim-surround").setup({
    surrounds = {
      ["d"] = {
        add = { "{[", "]}" },
        find = "%{%[.-%]%}",
        delete = "^(%{%[)().-(%]%})()$",
      },
      -- angle brackets, displaced from </> by the tag aliases below
      ["a"] = {
        add = { "<", ">" },
        find = function()
          return cfg.get_selection({ motion = "a<" })
        end,
        delete = "^(.)().-(.)()$",
      },
      ["A"] = {
        add = { "< ", " >" },
        find = function()
          return cfg.get_selection({ motion = "a<" })
        end,
        delete = "^(. ?)().-( ?.)()$",
      },
    },
    aliases = {
      -- </> prompt for an HTML tag (<li></li>) instead of adding bare angle brackets
      ["<"] = "t",
      [">"] = "T",
      ["a"] = false, -- drop the default a -> > alias so the surround above is reached
      ["s"] = { "}", "]", ")", "a", '"', "'", "`" },
    },
  })
end)
