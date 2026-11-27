-- deferred: markdown/text bullet lists; only relevant in those filetypes
later(function()
  vim.g.bullets_enabled_file_types = { "markdown", "text" }
  vim.pack.add({ "https://github.com/bullets-vim/bullets.vim" })

  local function is_list_item(line)
    return line:match("^%s*[-*+]%s") or line:match("^%s*%d+[.)]%s")
  end

  -- Visual gb: turn each selected line into a bullet, marker chosen by indent depth.
  -- Markers come from the std* entries of bullets.vim's outline levels (default
  -- - * +), the same progression it uses when demoting; deeper lines keep the last
  -- one, as bullets.vim does. Blank lines and existing list items are left alone.
  local function bulletize()
    local markers = {}
    for _, level in ipairs(vim.g.bullets_outline_levels or {}) do
      if level:match("^std.$") then
        table.insert(markers, level:sub(4))
      end
    end
    if #markers == 0 then
      markers = { "-" }
    end

    local first, last = vim.fn.line("v"), vim.fn.line(".")
    if first > last then
      first, last = last, first
    end
    local lines = vim.api.nvim_buf_get_lines(0, first - 1, last, false)
    for i, line in ipairs(lines) do
      if line:match("%S") and not is_list_item(line) then
        -- ceil: markdown nests at 2 spaces under "- ", less than a 4-wide shiftwidth
        local depth = math.ceil(vim.fn.indent(first + i - 1) / vim.fn.shiftwidth())
        local ws, text = line:match("^(%s*)(.*)$")
        lines[i] = ws .. markers[math.min(depth + 1, #markers)] .. " " .. text
      end
    end
    vim.api.nvim_buf_set_lines(0, first - 1, last, false, lines)
    vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", false)
  end

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("bulletize", { clear = true }),
    pattern = vim.g.bullets_enabled_file_types,
    callback = function(ev)
      vim.keymap.set("x", "gb", bulletize, { buffer = ev.buf, desc = "Bulletize selection" })
      -- bullets.vim has no per-mapping opt-out, so drop its default <leader>x here;
      -- this group is defined after the plugin's, so its maps already exist.
      pcall(vim.keymap.del, "n", "<leader>x", { buffer = ev.buf })
      vim.keymap.set("n", "-", "<Plug>(bullets-toggle-checkbox)", { buffer = ev.buf, desc = "Toggle checkbox" })
    end,
  })

  -- bullets.vim sets its buffer maps (<CR>, o, >>, ...) from FileType autocmds, which
  -- already fired for buffers opened at startup or restored from a session. Replay
  -- just those groups for such buffers.
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local ft = vim.bo[buf].filetype
    if vim.api.nvim_buf_is_loaded(buf) and vim.tbl_contains(vim.g.bullets_enabled_file_types, ft) then
      vim.api.nvim_buf_call(buf, function()
        for _, group in ipairs({ "TextBulletsMappings", "bulletize" }) do
          vim.api.nvim_exec_autocmds("FileType", { group = group, pattern = ft })
        end
      end)
    end
  end
end)
