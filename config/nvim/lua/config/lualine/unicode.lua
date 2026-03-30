local M = {}

function M.component(palette, active)
  local color = active and palette.dark_comment or palette.inactive_dark

  return {
    function()
      local line = vim.fn.getline(".")
      if line == "" then
        return ""
      end

      local byte_col = vim.fn.col(".") - 1
      local char_idx = vim.fn.charidx(line, byte_col)
      if char_idx < 0 then
        return ""
      end

      local char = vim.fn.strcharpart(line, char_idx, 1)
      if char == "" then
        return ""
      end

      local codepoint = vim.fn.char2nr(char)
      if codepoint == 0 then
        return ""
      end
      return string.format("U+%04X", codepoint)
    end,
    icon = "\u{f4df}",
    color = color,
    draw_empty = true,
  }
end

return M
