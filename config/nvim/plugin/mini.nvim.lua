-- see colorscheme.lua for highlights
local util = require("util")

vim.pack.add({ "https://github.com/echasnovski/mini.nvim" })

local mini_jump = require("mini.jump")
mini_jump.setup({})
vim.api.nvim_set_hl(0, "MiniJump", { link = "IncSearch" })

local icons = require("mini.icons")
icons.setup({
  filetype = {
    lua = { glyph = "" },
    toml = { glyph = "󰣖" },
    json = { glyph = "" },
  },
  default = {
    file = { hl = "MiniIconsBlue" },
    directory = { hl = "MiniIconsBlue", glyph = "Q" },
  },
  lsp = {
    folder = { glyph = "Q" },
  },
})
icons.mock_nvim_web_devicons()

require("mini.cmdline").setup({
  autocomplete = {
    enable = true,
    predicate = function(input)
      return (input and #input.line >= 2)
    end,
  },
  autopeek = { enable = false },
  autocorrect = { enable = false },
  open = { enable = true },
})

local animate = require("mini.animate")
animate.setup({
  cursor = { enable = false },
  scroll = {
    enable = true,
    timing = animate.gen_timing.linear({ duration = 20, unit = "total" }),
    subscroll = animate.gen_subscroll.equal({ max_output_steps = 10 }),
  },
  resize = {
    enable = true,
    timing = animate.gen_timing.linear({ duration = 40, unit = "total" }),
    subresize = animate.gen_subresize.equal({ max_output_steps = 200 }),
  },
  open = { enable = false },
  close = { enable = false },
})

-- disable mini.animate during mouse scroll to prevent jitter/bounce;
-- use direct scroll commands instead of feedkeys to avoid key misinterpretation
local function mouse_scroll(cmd)
  return function()
    vim.g.minianimate_disable = true
    vim.cmd("normal! " .. cmd)
    vim.schedule(function()
      vim.g.minianimate_disable = false
    end)
  end
end
-- \x05 = <C-e> (scroll down), \x19 = <C-y> (scroll up); 3 lines matches nvim default
vim.keymap.set({ "n", "x" }, "<ScrollWheelDown>", mouse_scroll("3\x05"), { silent = true })
vim.keymap.set({ "n", "x" }, "<ScrollWheelUp>", mouse_scroll("3\x19"), { silent = true })

require("mini.align").setup({ mappings = { start_with_preview = "ga" } })

require("mini.bufremove").setup({})
vim.keymap.set("n", "<leader>d", _G.MiniBufremove.unshow, { desc = "Close buffer (mini.bufremove)" })
vim.keymap.set("n", "<leader>D", _G.MiniBufremove.delete, { desc = "Delete buffer (mini.bufremove)" })

require("mini.splitjoin").setup({})

local ai = require("mini.ai")
local ts = ai.gen_spec.treesitter
local MiniExtra = require("mini.extra")
ai.setup({
  mappings = { around = "", inside = "" },
  custom_textobjects = {
    -- treesitter-based
    f = ts({ a = "@function.outer", i = "@function.inner" }),
    F = ts({ a = "@call.outer", i = "@call.inner" }),
    c = ts({ a = "@class.outer", i = "@class.inner" }),
    l = ts({ a = "@loop.outer", i = "@loop.inner" }),
    o = ts({ a = "@conditional.outer", i = "@conditional.inner" }),
    m = ts({ a = "@comment.outer", i = "@comment.inner" }),
    A = ts({ a = "@attribute.outer", i = "@attribute.inner" }),
    -- parent html/svelte element; 'a' = whole element, 'i' = content between tags
    P = function(ai_type)
      local node = vim.treesitter.get_node()
      if not node then
        return
      end
      while node and node:type() ~= "element" do
        node = node:parent()
      end
      if not node then
        return
      end
      node = node:parent()
      while node and node:type() ~= "element" do
        node = node:parent()
      end
      if not node then
        return
      end
      if ai_type == "a" then
        local sr, sc, er, ec = node:range()
        return { from = { line = sr + 1, col = sc + 1 }, to = { line = er + 1, col = ec } }
      end
      local start_tag, end_tag
      for child in node:iter_children() do
        if child:type() == "start_tag" then
          start_tag = child
        elseif child:type() == "end_tag" then
          end_tag = child
        end
      end
      if not start_tag or not end_tag then
        return
      end
      local _, _, fr, fc = start_tag:range()
      local tr, tc = end_tag:range()
      if fr > tr or (fr == tr and fc >= tc) then
        return
      end
      return { from = { line = fr + 1, col = fc + 1 }, to = { line = tr + 1, col = tc } }
    end,
    -- restore built-ins (custom_textobjects overrides defaults)
    a = ai.gen_spec.argument({ brackets = { "%b()", "%b[]", "%b{}" } }),
    b = { { "%b()", "%b[]", "%b{}" }, "^.().*().$" },
    q = { { "%b''", '%b""', "%b``" }, "^.().*().$" },
    -- token within a string (e.g. a css class in class="foo bar")
    k = function(ai_type)
      local node = vim.treesitter.get_node()
      if not node then
        return
      end
      local string_types = {
        attribute_value = true,
        quoted_attribute_value = true,
        string = true,
        string_fragment = true,
        string_value = true,
      }
      local cur = node
      while cur and not string_types[cur:type()] do
        cur = cur:parent()
      end
      if not cur then
        return
      end
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))
      local line = vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1]
      col = col + 1
      if line:sub(col, col):match("[%s\"'`]") then
        return
      end
      local s, e = col, col
      while s > 1 and not line:sub(s - 1, s - 1):match("[%s\"'`]") do
        s = s - 1
      end
      while e < #line and not line:sub(e + 1, e + 1):match("[%s\"'`]") do
        e = e + 1
      end
      if ai_type == "i" then
        return { from = { line = row, col = s }, to = { line = row, col = e } }
      end
      local from, to = s, e
      if e < #line and line:sub(e + 1, e + 1) == " " then
        to = e + 1
      elseif s > 1 and line:sub(s - 1, s - 1) == " " then
        from = s - 1
      end
      return { from = { line = row, col = from }, to = { line = row, col = to } }
    end,
    B = MiniExtra.gen_ai_spec.buffer(),
    I = MiniExtra.gen_ai_spec.indent(),
  },
})

-- count-aware a/i text object mappings; mini.ai's default 'a'/'i' treat count as Nth occurrence
local function make_textobject(ai_type, id)
  return function()
    local n = vim.v.count > 0 and vim.v.count or 1
    local from, to
    for i = 1, n do
      local region = ai.find_textobject(ai_type, id, { n_times = 1 })
      if not region or not region.to then
        break
      end
      if i == 1 then
        from = region.from
      end
      to = region.to
      if i < n then
        local line_content = vim.api.nvim_buf_get_lines(0, to.line - 1, to.line, true)[1]
        if to.col >= #line_content then
          if to.line >= vim.api.nvim_buf_line_count(0) then
            break
          end
          vim.api.nvim_win_set_cursor(0, { to.line + 1, 0 })
        else
          vim.api.nvim_win_set_cursor(0, { to.line, to.col })
        end
      end
    end
    if from and to then
      vim.fn.cursor(from.line, from.col)
      vim.cmd.normal("v")
      vim.fn.cursor(to.line, to.col)
    end
  end
end

for _, id in ipairs({ "f", "F", "c", "l", "o", "m", "A", "k", "a", "b", "q", "B", "I" }) do
  vim.keymap.set({ "o", "x" }, "a" .. id, make_textobject("a", id))
  vim.keymap.set({ "o", "x" }, "i" .. id, make_textobject("i", id))
end

-- P: parent html element; count = levels to go up (d2aP = grandparent, etc.)
local function walk_to_parent_element(n)
  local node = vim.treesitter.get_node()
  if not node then
    return
  end
  for _ = 1, n do
    while node and node:type() ~= "element" do
      node = node:parent()
    end
    if not node then
      return
    end
    node = node:parent()
  end
  while node and node:type() ~= "element" do
    node = node:parent()
  end
  return node
end

vim.keymap.set({ "o", "x" }, "aP", function()
  local node = walk_to_parent_element(vim.v.count > 0 and vim.v.count or 1)
  if not node then
    return
  end
  local sr, sc, er, ec = node:range()
  vim.fn.cursor(sr + 1, sc + 1)
  vim.cmd.normal("v")
  vim.fn.cursor(er + 1, ec)
end)

vim.keymap.set({ "o", "x" }, "iP", function()
  local node = walk_to_parent_element(vim.v.count > 0 and vim.v.count or 1)
  if not node then
    return
  end
  local start_tag, end_tag
  for child in node:iter_children() do
    if child:type() == "start_tag" then
      start_tag = child
    elseif child:type() == "end_tag" then
      end_tag = child
    end
  end
  if not start_tag or not end_tag then
    return
  end
  local _, _, fr, fc = start_tag:range()
  local tr, tc = end_tag:range()
  if fr > tr or (fr == tr and fc >= tc) then
    return
  end
  vim.fn.cursor(fr + 1, fc + 1)
  vim.cmd.normal("v")
  vim.fn.cursor(tr + 1, tc)
end)

local map_lsp_selection = function(lhs, desc)
  local s = vim.startswith(desc, "Increase") and 1 or -1
  local rhs = function()
    vim.lsp.buf.selection_range(s * vim.v.count1)
  end
  vim.keymap.set("x", lhs, rhs, { desc = desc })
end
map_lsp_selection("<tab>", "Increase selection")
map_lsp_selection("<s-tab>", "Decrease selection")

require("mini.cursorword").setup({ delay = 50 })
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
  callback = function()
    local word = vim.fn.expand("<cword>")
    vim.b.minicursorword_disable = not word:match("^[%a_][%w_]+$")
  end,
})

require("mini.notify").setup({
  lsp_progress = { enable = false },
  window = {
    config = function(bufnr)
      local max_width_share = 0.5
      local min_width = 30
      local width = min_width
      local line_widths = vim.tbl_map(vim.fn.strdisplaywidth, vim.api.nvim_buf_get_lines(bufnr, 0, -1, true))
      for _, l_w in ipairs(line_widths) do
        width = math.max(width, l_w)
      end
      local max_width = math.max(math.floor(max_width_share * vim.o.columns), 1)
      width = math.min(width, max_width)
      local col = math.floor((vim.o.columns - width) / 2)
      return { anchor = "SW", col = col, row = 0, width = width }
    end,
  },
})

local hipatterns = require("mini.hipatterns")

util.on_colorscheme(function()
  local hi_warning = util.copy_hl("WarningMsg")
  vim.api.nvim_set_hl(0, "MiniHipatternsWS", { bg = hi_warning.fg })
end)

hipatterns.setup({
  delay = { text_change = 5 },
  highlighters = {
    fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
    bug = { pattern = "%f[%w]()BUG()%f[%W]", group = "MiniHipatternsFixme" },
    warn = { pattern = "%f[%w]()WARN()%f[%W]", group = "MiniHipatternsHack" },
    hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
    todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
    note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
  },
})
