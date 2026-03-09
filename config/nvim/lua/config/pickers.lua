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

-- merged view of grapple tags + open buffers with toggle action
M.grapple = function()
  local grapple = require("grapple")

  local function get_items(_, ctx)
    local ok, tags = pcall(grapple.tags)
    if not ok then
      tags = {}
    end
    tags = tags or {}

    local items = {}
    local seen = {}

    -- tagged files first, in tag order
    for n, tag in ipairs(tags) do
      seen[tag.path] = true
      local buf = vim.fn.bufnr(tag.path)
      table.insert(items, {
        file = tag.path,
        text = vim.fn.fnamemodify(tag.path, ":~:."),
        tagged = true,
        buf = buf ~= -1 and buf or nil,
        n = n,
      })
    end

    -- open untagged buffers (matches snacks buffers source logic)
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[buf].buflisted and vim.bo[buf].buftype ~= "nofile" then
        local name = vim.api.nvim_buf_get_name(buf)
        if name ~= "" and not seen[name] then
          seen[name] = true
          table.insert(items, {
            file = name,
            text = vim.fn.fnamemodify(name, ":~:."),
            tagged = false,
            buf = buf,
            n = nil,
          })
        end
      end
    end

    return ctx.filter:filter(items)
  end

  return Snacks.picker({
    title = "Grapple tags",
    finder = get_items,
    format = function(item, picker)
      local ret = {}
      local mark = item.tagged and "●" or "○"
      local hl = item.tagged and "DiagnosticOk" or "Comment"
      table.insert(ret, { mark .. " ", hl })
      if item.n then
        table.insert(ret, { string.format("%2d ", item.n), hl })
      else
        table.insert(ret, { "   ", hl })
      end
      vim.list_extend(ret, require("snacks.picker.format").file(item, picker))
      return ret
    end,
    confirm = function(picker, item)
      picker:close()
      if item.buf and vim.api.nvim_buf_is_valid(item.buf) then
        vim.api.nvim_set_current_buf(item.buf)
      else
        vim.cmd("edit " .. vim.fn.fnameescape(item.file))
      end
    end,
    focus = "list",
    actions = {
      toggle_tag = function(picker)
        local item = picker:current()
        if not item then return end
        local items = picker.list.items
        local pos, tag_count = nil, 0
        for i, it in ipairs(items) do
          if it.file == item.file then pos = i end
          if it.tagged then tag_count = tag_count + 1 end
        end
        if not pos then return end
        if item.tagged then
          grapple.untag({ path = item.file })
          table.remove(items, pos)
          for i = pos, tag_count - 1 do
            if items[i] and items[i].tagged then items[i].n = items[i].n - 1 end
          end
          item.tagged, item.n = false, nil
          table.insert(items, tag_count, item)
          picker.list.dirty = true
          picker.list:render()
          picker.list:move(pos, true)
        else
          grapple.tag({ path = item.file })
          table.remove(items, pos)
          item.tagged, item.n = true, tag_count + 1
          table.insert(items, tag_count + 1, item)
          picker.list.dirty = true
          picker.list:render()
          picker.list:move(tag_count + 1, true)
        end
        require("lualine").refresh()
      end,
      tag_inc = function(picker)
        local item = picker:current()
        if not item or not item.tagged then return end
        local ok, tags = pcall(grapple.tags)
        if not ok or not tags or item.n >= #tags then return end
        local file, new_n = item.file, item.n + 1
        grapple.untag({ path = file })
        grapple.tag({ path = file, index = new_n })
        require("lualine").refresh()
        local items = picker.list.items
        local pos = nil
        for i, it in ipairs(items) do
          if it.file == file then pos = i; break end
        end
        if not pos or not items[pos + 1] then return end
        items[pos], items[pos + 1] = items[pos + 1], items[pos]
        items[pos].n, items[pos + 1].n = item.n, new_n
        picker.list.dirty = true
        picker.list:render()
        picker.list:move(pos + 1, true)
      end,
      tag_dec = function(picker)
        local item = picker:current()
        if not item or not item.tagged then return end
        if item.n <= 1 then return end
        local file, new_n = item.file, item.n - 1
        grapple.untag({ path = file })
        grapple.tag({ path = file, index = new_n })
        require("lualine").refresh()
        local items = picker.list.items
        local pos = nil
        for i, it in ipairs(items) do
          if it.file == file then pos = i; break end
        end
        if not pos or pos <= 1 then return end
        items[pos], items[pos - 1] = items[pos - 1], items[pos]
        items[pos].n, items[pos - 1].n = item.n, new_n
        picker.list.dirty = true
        picker.list:render()
        picker.list:move(pos - 1, true)
      end,
    },
    win = {
      list = {
        keys = {
          ["<tab>"] = { "toggle_tag", mode = "n", desc = "Toggle grapple tag" },
          ["<c-a>"] = { "tag_inc", mode = "n", desc = "Move tag down" },
          ["<c-x>"] = { "tag_dec", mode = "n", desc = "Move tag up" },
        },
      },
    },
  })
end

M.neoclip = function()
  local ok, storage = pcall(require, "neoclip.storage")
  if not ok then
    vim.notify("neoclip not loaded", vim.log.levels.WARN)
    return
  end

  local yanks = storage.get().yanks
  if not yanks or #yanks == 0 then
    vim.notify("Yank history is empty", vim.log.levels.INFO)
    return
  end

  local handlers = require("neoclip.handlers")
  local items = {}
  for i, entry in ipairs(yanks) do
    local preview_text = table.concat(entry.contents, "\n")
    local first_line = (entry.contents[1] or ""):match("^%s*(.-)%s*$")
    local display = first_line .. (#entry.contents > 1 and " …" or "")

    -- neoclip already converts to setreg format: l=linewise, c=charwise, b=blockwise
    local type_label = entry.regtype == "l" and "L" or entry.regtype == "c" and "C" or "B"

    table.insert(items, {
      idx = i,
      text = preview_text,
      display = display,
      type_label = type_label,
      entry = entry,
      preview = { text = preview_text, ft = entry.filetype or "" },
    })
  end

  return Snacks.picker({
    title = "Yank History",
    items = items,
    preview = "preview",
    format = function(item, _)
      return {
        { item.type_label .. " ", "Comment" },
        { item.display, "Normal" },
      }
    end,
    confirm = function(picker, item)
      picker:close()
      vim.schedule(function()
        handlers.paste(item.entry, "p")
      end)
    end,
  })
end

return M
