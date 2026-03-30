vim.pack.add({ 'https://github.com/monaqa/dial.nvim' })

local augend = require("dial.augend")

vim.keymap.set("n", "<C-a>", function() require("dial.map").manipulate("increment", "normal") end)
vim.keymap.set("n", "<C-x>", function() require("dial.map").manipulate("decrement", "normal") end)
vim.keymap.set("n", "g<C-a>", function() require("dial.map").manipulate("increment", "gnormal") end)
vim.keymap.set("n", "g<C-x>", function() require("dial.map").manipulate("decrement", "gnormal") end)
vim.keymap.set("x", "<C-a>", function() require("dial.map").manipulate("increment", "visual") end)
vim.keymap.set("x", "<C-x>", function() require("dial.map").manipulate("decrement", "visual") end)
vim.keymap.set("x", "g<C-a>", function() require("dial.map").manipulate("increment", "gvisual") end)
vim.keymap.set("x", "g<C-x>", function() require("dial.map").manipulate("decrement", "gvisual") end)

local logical_alias = augend.constant.new({ elements = { "&&", "||" }, word = false, cyclic = true })
local ordinal_numbers = augend.constant.new({
  elements = { "first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth" },
  word = false,
  cyclic = true,
})
local weekdays = augend.constant.new({
  elements = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
  word = true,
  cyclic = true,
})
local months = augend.constant.new({
  elements = { "January", "February", "March", "April", "May", "June",
               "July", "August", "September", "October", "November", "December" },
  word = true,
  cyclic = true,
})
local capitalized_boolean = augend.constant.new({ elements = { "True", "False" }, word = true, cyclic = true })
local cases = augend.case.new({ types = { "camelCase", "snake_case" }, cyclic = true })
local comment_tags = augend.constant.new({ elements = { "TODO", "NOTE", "FIXME", "BUG", "HACK", "WARN" } })

local groups = {
  default = {
    augend.integer.alias.decimal,
    augend.integer.alias.decimal_int,
    augend.integer.alias.hex,
    augend.date.alias["%Y/%m/%d"],
    ordinal_numbers,
    weekdays,
    months,
    capitalized_boolean,
    augend.constant.alias.bool,
    logical_alias,
  },
  vue = {
    augend.constant.new({ elements = { "let", "const" } }),
    augend.hexcolor.new({ case = "lower" }),
    augend.hexcolor.new({ case = "upper" }),
  },
  typescript = { augend.constant.new({ elements = { "let", "const" } }) },
  css = {
    augend.hexcolor.new({ case = "lower" }),
    augend.hexcolor.new({ case = "upper" }),
  },
  markdown = {
    augend.constant.new({ elements = { "[ ]", "[x]" }, word = false, cyclic = true }),
    augend.misc.alias.markdown_header,
  },
  json = { augend.semver.alias.semver },
  lua = { augend.constant.new({ elements = { "and", "or" }, word = true, cyclic = true }) },
  python = { augend.constant.new({ elements = { "and", "or" } }) },
}

-- merge non-default groups with default
for name, group in pairs(groups) do
  if name ~= "default" then
    vim.list_extend(group, groups.default)
  end
end

require("dial.config").augends:register_group(groups)

vim.g.dials_by_ft = {
  css = "css",
  vue = "vue",
  javascript = "typescript",
  typescript = "typescript",
  typescriptreact = "typescript",
  javascriptreact = "typescript",
  json = "json",
  lua = "lua",
  markdown = "markdown",
  sass = "css",
  scss = "css",
  python = "python",
}
