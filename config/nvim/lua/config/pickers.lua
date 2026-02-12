local M = {}

M.unicode = function()
  local Snacks = require("snacks")

  return Snacks.picker({
    title = "Unicode Character",
    format = "text",
    layout = { preset = "select", hidden = { "preview" } },
    filter = {
      -- Transform the pattern before matching: strip U+/0x prefix, lowercase
      transform = function(picker, filter)
        local pattern = filter.pattern
        if pattern and pattern ~= "" then
          -- Strip U+ or 0x prefix (case-insensitive) and lowercase
          local normalized = pattern:lower():gsub("^u%+", ""):gsub("^0x", "")
          if normalized ~= pattern then
            filter.pattern = normalized
          end
        end
      end,
    },
    finder = function()
      local items = {}

      local unicode_data_path = vim.fn.stdpath("config") .. "/lua/plugins/_UnicodeData.txt"
      local file = io.open(unicode_data_path, "r")

      if not file then
        vim.notify("_UnicodeData.txt not found", vim.log.levels.ERROR)
        return items
      end

      for line in file:lines() do
        local parts = vim.split(line, ";")
        if #parts >= 2 then
          local hex_code = parts[1]
          local name = parts[2]

          if name ~= "<control>" and name ~= "" and not name:match("^<.*>$") then
            local codepoint = tonumber(hex_code, 16)

            if
              (codepoint >= 0x0020 and codepoint <= 0x00FF) -- Latin
              or (codepoint >= 0x0370 and codepoint <= 0x04FF) -- Greek, Cyrillic
              or (codepoint >= 0x0590 and codepoint <= 0x06FF) -- Hebrew, Arabic
              or (codepoint >= 0x2000 and codepoint <= 0x2BFF) -- General Punctuation to Misc Symbols
              or (codepoint >= 0x3000 and codepoint <= 0x30FF) -- CJK, Hiragana, Katakana
              or (codepoint >= 0x1F000 and codepoint <= 0x1F6FF) -- Emoticons, symbols
            then
              local char = vim.fn.nr2char(codepoint)
              local hex_upper = string.format("%04X", codepoint)
              local hex_lower = hex_upper:lower()
              local hex_display = "U+" .. hex_upper

              -- Format: character  hex  name
              local text = string.format("%s  %s  %s", char, hex_display, name)

              -- Search includes bare hex (both cases) and name - no 0x/U+ prefix
              local search = string.format("%s %s %s", hex_upper, hex_lower, name)

              table.insert(items, {
                value = char,
                text = text,
                search = search,
                codepoint = codepoint,
                hex = hex_display,
                name = name,
              })
            end
          end
        end
      end

      file:close()
      return items
    end,
    confirm = function(picker, selected)
      picker:close()
      -- Insert the character at cursor position
      local char = selected.value
      vim.api.nvim_put({ char }, "c", true, true)
    end,
  })
end

M.npm = function()
  local Snacks = require("snacks")
  return Snacks.picker({
    format = "text",
    finder = function()
      local items = {}
      local file = "package.json"

      local f = io.open(file, "r")
      if not f then
        return {}
      end

      local content = f:read("*all")
      f:close()

      -- Simple JSON parsing (assumes valid JSON and "scripts" present)
      -- For robustness, use vim.json.decode in Neovim 0.6+
      local ok, json = pcall(vim.json.decode, content)
      if not ok or not json.scripts then
        return {}
      end

      for name, cmd in pairs(json.scripts) do
        table.insert(items, {
          value = name,
          text = name .. " : " .. cmd,
          label = "npm run " .. name,
          description = cmd,
        })
      end
      return items
    end,
    confirm = function(picker, selected)
      picker:close()
      Snacks.terminal("npm run " .. selected.value)
    end,
  })
end

return M
