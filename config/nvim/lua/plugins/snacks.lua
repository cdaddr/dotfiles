local unicode_picker = function()
  local Snacks = require'snacks'
  return Snacks.picker({
    title = "Unicode Character",
    format = "text",
    finder = function()
      local items = {}

      local unicode_data_path = vim.fn.stdpath("config") .. "/lua/plugins/UnicodeData.txt"
      local file = io.open(unicode_data_path, "r")

      if not file then
        vim.notify("UnicodeData.txt not found", vim.log.levels.ERROR)
        return items
      end

      for line in file:lines() do
        local parts = vim.split(line, ";")
        if #parts >= 2 then
          local hex_code = parts[1]
          local name = parts[2]

          if name ~= "<control>" and name ~= "" and not name:match("^<.*>$") then
            local codepoint = tonumber(hex_code, 16)

            if (codepoint >= 0x0020 and codepoint <= 0x00FF) or  -- Latin
              (codepoint >= 0x0370 and codepoint <= 0x04FF) or  -- Greek, Cyrillic
              (codepoint >= 0x0590 and codepoint <= 0x06FF) or  -- Hebrew, Arabic
              (codepoint >= 0x2000 and codepoint <= 0x2BFF) or  -- General Punctuation to Misc Symbols
              (codepoint >= 0x3000 and codepoint <= 0x30FF) or  -- CJK, Hiragana, Katakana
              (codepoint >= 0x1F000 and codepoint <= 0x1F6FF) then -- Emoticons, symbols

              local char = vim.fn.nr2char(codepoint)
              local hex = string.format("U+%04X", codepoint)

              -- Format: character  hex  name
              local text = string.format("%s  %s  %s", char, hex, name)

              table.insert(items, {
                value = char,
                text = text,
                codepoint = codepoint,
                hex = hex,
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
      vim.api.nvim_put({char}, 'c', true, true)
    end,
  })
end
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    --@type wk.Opts
    opts = {
      delay = 400,
      spec = {
        { '<leader>f', group = "File" },
        { '<leader>b', group = 'Buffers'},
        { '<leader>g', group = 'Git'},
        { '<leader>h', group = 'Gitsigns (hunks)' },
        { '<leader>l', group = 'LSP' },
        { '<leader>s', group = 'Search' },
        { '<leader>t', group = 'Terminal' },
        { '<leader>u', group = 'Toggle' },
        { '<leader>x', group = 'Execute' },
      },
      icons = {
        mappings = false,
        breadcrumb = "",
        separator = "⇒", -- symbol used between a key and it's label
        group = "+",
      },

      win = {
        border = "double",
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

  { "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    init = function()
      -- Override column number highlight for better visibility on selected lines
      vim.api.nvim_set_hl(0, "SnacksPickerCol", { link = "SnacksPickerIdx" })
    end,
    opts = function()
      -- toggle options
      Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
      Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
      Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
      Snacks.toggle.diagnostics():map("<leader>ud")
      Snacks.toggle.line_number():map("<leader>ul")
      Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" }):map("<leader>uc")
      Snacks.toggle.option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" }):map("<leader>uA")
      Snacks.toggle.treesitter():map("<leader>uT")
      Snacks.toggle.option("background", { off = "light", on = "dark" , name = "Dark Background" }):map("<leader>ub")
      Snacks.toggle.dim():map("<leader>uD")
      Snacks.toggle.animate():map("<leader>ua")
      Snacks.toggle.indent():map("<leader>ug")
      Snacks.toggle.scroll():map("<leader>uS")
      Snacks.toggle.profiler():map("<leader>dpp")
      Snacks.toggle.profiler_highlights():map("<leader>dph")

      if vim.lsp.inlay_hint then
        Snacks.toggle.inlay_hints():map("<leader>uh")
      end
      -- Define custom grep formatter once
      local grep_format = function(item, picker)
        local ret = {} ---@type snacks.picker.Highlight[]

        if item.line then
          -- Trim leading whitespace and truncate to 40 chars
          local trimmed_line = item.line:match("^%s*(.-)$") or item.line
          local max_line_width = 40
          local truncated = false

          if vim.api.nvim_strwidth(trimmed_line) > max_line_width then
            local width = 0
            local idx = 1
            for i = 1, #trimmed_line do
              local char = trimmed_line:sub(i, i)
              local char_width = vim.api.nvim_strwidth(char)
              if width + char_width > max_line_width - 1 then
                idx = i
                break
              end
              width = width + char_width
              idx = i + 1
            end
            trimmed_line = trimmed_line:sub(1, idx - 1) .. "…"
            truncated = true
          end

          -- Add the matching line content
          if item.positions and not truncated then
            local leading_ws = #(item.line:match("^%s*") or "")
            local adjusted_positions = {}
            for _, pos in ipairs(item.positions) do
              local adjusted_pos = pos - leading_ws
              if adjusted_pos >= 0 and adjusted_pos < #trimmed_line then
                table.insert(adjusted_positions, adjusted_pos)
              end
            end
            if #adjusted_positions > 0 then
              local temp_item = vim.tbl_extend("force", {}, item)
              temp_item.positions = adjusted_positions
              local offset = Snacks.picker.highlight.offset(ret)
              Snacks.picker.highlight.matches(ret, temp_item.positions, offset)
            end
          end
          Snacks.picker.highlight.format(item, trimmed_line, ret)

          -- Add virtual text for right-aligned file info
          local path = Snacks.picker.util.path(item) or item.file
          local truncpath = Snacks.picker.util.truncpath(
            path,
            100,
            { cwd = picker:cwd(), kind = picker.opts.formatters.file.truncate }
          )

          local dir, base = truncpath:match("^(.*)/(.+)$")

          local virt_parts = {}
          if base and dir and dir ~= "" then
            table.insert(virt_parts, { dir, "SnacksPickerDir" })
            table.insert(virt_parts, { " " })
            table.insert(virt_parts, { base, "SnacksPickerFile" })
          else
            table.insert(virt_parts, { " " })
            table.insert(virt_parts, { truncpath, "SnacksPickerFile" })
          end
          table.insert(virt_parts, { ":", "SnacksPickerDelim" })
          if item.pos and item.pos[1] then
            table.insert(virt_parts, { tostring(item.pos[1]), "SnacksPickerRow" })
            if item.pos[2] and item.pos[2] > 0 then
              table.insert(virt_parts, { ":", "SnacksPickerDelim" })
              table.insert(virt_parts, { tostring(item.pos[2]), "SnacksPickerCol" })
            end
          end

          ret[#ret + 1] = {
            col = 0,
            virt_text = virt_parts,
            virt_text_pos = "right_align",
            hl_mode = "combine",
          }
        else
          return require("snacks.picker.format").file(item, picker)
        end

        return ret
      end

      local open_in_oil = function(picker)
        local item = picker:current()
        if item and item.file then
          picker:close()
          require("oil").open(picker:dir())
        end
      end

      return {
        terminal = {},
        picker = {
          enabled = true,
          layout = { preset = 'ivy', width = 0.9 },
          formatters = {
            file = {
              filename_first = true,
            },
          },
          sources = {
            files = {
              actions = { open_in_oil = open_in_oil }
            },
            grep = {
              actions = { open_in_oil = open_in_oil },
              format = grep_format,
            },
            grep_buffers = {
              actions = { open_in_oil = open_in_oil },
              format = grep_format,
            },
            grep_word = {
              actions = { open_in_oil = open_in_oil },
              format = grep_format,
            },
          },
          win = {
            input = {
              keys = {
                ["<s-cr>"] = { "edit_vsplit", mode = { "i", "n" } },
                ["<m-K>"] = { "history_back", mode = { "i", "n" } },
                ["<m-J>"] = { "history_forward", mode = { "i", "n" } },
                ["<C-p>"] = { "focus_preview", mode = { "i", "n" } },
                ["<C-o>"] = { "open_in_oil", mode = { "i", "n" } },
              }
            }
          },
        },
        toggle = {
          enabled = true,
          notify = true,
        },
      }
    end,

    keys = {
      -- CMD shortcuts
      { "<D-o>", function() Snacks.picker.git_files() end, desc = "Find Files (Git)" },
      { "<D-f>", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<D-p>", function() Snacks.picker.smart() end, desc = "Find Files (Smart)" },
      { "<D-e>", function() Snacks.picker.recent() end, desc = "Find Files (Recent)" },

      { "<leader><space>", function() Snacks.picker.recent() end, desc = "Recent" },
      { "<leader>p", function() Snacks.picker.smart() end, desc = "Find Files (Smart)" },
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep (cwd)" },
      { "<leader>f?", function() Snacks.picker.grep({cwd = vim.fn.expand("%:p:h")}) end, desc = "Grep (buffer dir)" },
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
      -- find
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Files (Config)" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Files (Git)" },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
      { "<leader>fl", function() Snacks.picker.files({cwd = vim.fn.expand("%:p:h")}) end, desc = "Find Files (current file's cwd)" },
      -- buffers
      { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>bb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      -- git
      { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
      { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
      { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
      { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
      { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
      { "<leader>gn", function() Snacks.notifier.show_history() end, desc = "Notification History" },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      -- search
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
      { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
      { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
      { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<leader>sO", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
      { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
      { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
      { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
      { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
      { "<leader>sp", function() Snacks.picker.lazy() end, desc = "lazy.nvim Plugin Spec" },
      { "<leader>sP", function() Snacks.picker.files({cwd = require'lazy.core.config'.options.root}) end, desc = "Installed Plugin Source" },
      { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
      { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
      { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
      { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
      { "<leader>sU", unicode_picker, desc = "Unicode Character" },
      -- LSP
      { "<leader>ld", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
      { "<leader>lD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
      { "<leader>lr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
      { "<leader>lI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
      { "<leader>ly", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
      -- Other
      -- { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
      -- { "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
      { "<leader>xR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
      { "<leader>xcd", function() vim.cmd.cd(vim.fn.expand('%:p:h')) end, desc = "cd to buffer's dir"},
      { "<leader>xcp", require('util').copy_filename, desc = "Copy buffer path to clipboard"},

      -- { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
      -- { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
      { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
      { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
      { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },

      { "<leader>xx", function() 
        local Snacks = require'snacks'
        return Snacks.picker({
          format = "text",
          finder = function()
            local items = {}
            local file = 'package.json'

            local f = io.open(file, "r")
            if not f then return {} end

            local content = f:read("*all")
            f:close()

            -- Simple JSON parsing (assumes valid JSON and "scripts" present)
            -- For robustness, use vim.json.decode in Neovim 0.6+
            local ok, json = pcall(vim.json.decode, content)
            if not ok or not json.scripts then return {} end

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
          confirm = function (picker, selected)
            picker:close()
            Snacks.terminal("npm run " .. selected.value)
          end
        })
      end, desc = "npm script"}
    },
  }
}
