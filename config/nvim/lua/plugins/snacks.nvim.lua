local pickers = require("config.pickers")

-- open a grep picker with cwd shown in title
local function grep(title, source, opts)
  opts = opts or {}
  local dir = opts.cwd or vim.fn.getcwd()
  opts.title = title .. " (" .. vim.fn.fnamemodify(dir, ":~") .. ")"
  Snacks.picker[source](opts)
end

---@module "Snacks"
---@type LazySpec[]
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  init = function()
    -- Override column number highlight for better visibility on selected lines
    vim.api.nvim_set_hl(0, "SnacksPickerCol", { link = "SnacksPickerIdx" })
  end,
  -- see colorscheme.lua for highlights
  opts = function()
    -- toggle options
    Snacks.toggle.option("spell", { name = "Spelling" }):map([[\s]])
    Snacks.toggle.option("wrap", { name = "Wrap" }):map([[\w]])
    Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map([[\L]])
    Snacks.toggle.diagnostics():map([[\d]])
    Snacks.toggle.line_number():map([[\l]])
    Snacks.toggle
      .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" })
      :map([[\c]])
    Snacks.toggle
      .option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" })
      :map([[\A]])
    Snacks.toggle.treesitter():map([[\T]])
    Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map([[\b]])
    Snacks.toggle.dim():map([[\D]])
    Snacks.toggle.animate():map([[\a]])
    Snacks.toggle.indent():map([[\g]])
    Snacks.toggle.scroll():map([[\S]])
    Snacks.toggle.profiler():map([[\pp]])
    Snacks.toggle.profiler_highlights():map([[\ph]])

    if vim.lsp.inlay_hint then
      Snacks.toggle.inlay_hints():map("<leader>uh")
    end
    -- custom grep formatter: left-aligned line content, right-aligned "basename  line  col"
    local grep_format = function(item, picker)
      local ret = {} ---@type snacks.picker.Highlight[]

      if item.line then
        local trimmed = item.line:match("^%s*(.-)$") or item.line

        if item.positions then
          local leading_ws = #(item.line:match("^%s*") or "")
          local adjusted = {}
          for _, pos in ipairs(item.positions) do
            local p = pos - leading_ws
            if p >= 0 then
              table.insert(adjusted, p)
            end
          end
          if #adjusted > 0 then
            local temp = vim.tbl_extend("force", {}, item)
            temp.positions = adjusted
            Snacks.picker.highlight.matches(ret, temp.positions, Snacks.picker.highlight.offset(ret))
          end
        end
        Snacks.picker.highlight.format(item, trimmed, ret)

        local path = Snacks.picker.util.path(item) or item.file
        if path and not item.preview_title then
          -- full path shown in preview border title via {preview} template
          item.preview_title = path
        end

        local basename = path and vim.fn.fnamemodify(path, ":t") or ""
        local virt = { { " " }, { basename, "SnacksPickerDimmed" } }
        if item.pos and item.pos[1] then
          table.insert(virt, { "  " })
          table.insert(virt, { string.format("%4d", item.pos[1]), "SnacksPickerRow" })
          table.insert(virt, { "  " })
          if item.pos[2] and item.pos[2] > 0 then
            table.insert(virt, { string.format("%2d", item.pos[2]), "SnacksPickerCol" })
          else
            table.insert(virt, { "  " })
          end
        end

        ret[#ret + 1] = { col = 0, virt_text = virt, virt_text_pos = "right_align", hl_mode = "replace" }
      else
        return require("snacks.picker.format").file(item, picker)
      end

      return ret
    end

    -- floating vertical layout for grep: input → list → full-width preview
    local grep_layout = {
      layout = {
        backdrop = false,
        width = 0.8,
        min_width = 80,
        height = 0.8,
        min_height = 30,
        box = "vertical",
        border = true,
        title = " {title} {live} {flags}",
        title_pos = "center",
        { win = "input", height = 1, border = "bottom" },
        { win = "list", border = "none" },
        { win = "preview", title = "{preview}", height = 0.4, border = "top" },
      },
    }

    local open_in_oil = function(picker)
      local item = picker:current()
      if item and item._path then
        picker:close()
        local dir = vim.fn.fnamemodify(item._path, ":h")
        -- require("nvim-tree.api").tree.open({ path = dir })
        require("oil").open(dir)
      end
    end

    -- close picker if in input mode and typed input is blank
    -- always close if in normal mode
    local close_if_no_input = function(picker)
      local mode = vim.fn.mode()
      if mode == "i" then
        local line = vim.api.nvim_get_current_line()
        if line == "" then
          picker:close()
        else
          vim.cmd("stopinsert")
        end
      else
        picker:close()
      end
    end

    local exit_insert = function()
      vim.cmd("stopinsert")
    end

    local win_opts = { input = { keys = { ["<c-o>"] = { "open_in_oil", mode = { "n", "i" }, desc = "Open in Oil" } } } }
    local exclude = { ".lock", "*lock.json", "*lock.yaml", "*lock.yml", "*lock.toml" }

    ---@type snacks.Config
    return {
      terminal = {},
      picker = {
        enabled = true,
        layout = { preset = "ivy", width = 0.9 },
        formatters = {
          file = {
            filename_first = true,
          },
        },
        actions = { close_if_no_input = close_if_no_input, open_in_oil = open_in_oil, exit_insert = exit_insert },
        sources = {
          files = { win = win_opts, exclude = exclude },
          git_files = { win = win_opts, exclude = exclude },
          recent = { win = win_opts, exclude = exclude },
          buffers = { win = win_opts },
          smart = { win = win_opts, exclude = exclude },
          grep = { format = grep_format, win = win_opts, exclude = exclude, layout = grep_layout },
          grep_buffers = { format = grep_format, win = win_opts, layout = grep_layout },
          grep_word = { format = grep_format, win = win_opts, layout = grep_layout },
        },
        win = {
          input = {
            keys = {
              ["<Esc>"] = { "close_if_no_input", mode = { "i", "n" } },
              ["<C-c>"] = { "exit_insert", mode = "i", desc = "Normal mode" },
              ["<s-cr>"] = { "edit_vsplit", mode = { "i", "n" } },
              ["<s-d-cr>"] = { "edit_split", mode = { "i", "n" } },
              ["<m-K>"] = { "history_back", mode = { "i", "n" } },
              ["<m-J>"] = { "history_forward", mode = { "i", "n" } },
              ["<M-p>"] = { "focus_preview", mode = { "i", "n" } },
            },
          },
        },
        prompt = "? ",
        -- debug = {
        --   scores = true, grep = true,
        --   files = true
        -- }
      },
      toggle = {
        enabled = true,
        notify = true,
      },
    }
  end,

  -- stylua: ignore start
  keys = {
    -- CMD shortcuts
    -- { "<D-o>", function() Snacks.picker.git_files() end, desc = "Find Files (Git)", },
    -- { "<D-f>", function() Snacks.picker.grep() end, desc = "Grep", },
    -- { "<D-p>", function() Snacks.picker.smart() end, desc = "Find Files (Smart)", },
    -- { "<D-e>", function() Snacks.picker.recent() end, desc = "Find Files (Recent)", },
    { "<leader>r", function() Snacks.picker.recent() end, desc = "Recent", },
    { "<leader>p", function() Snacks.picker.smart() end, desc = "Find Files (Smart)", },
    { "<leader>/", function() grep("Grep", "grep") end, desc = "Grep (cwd)", },
    { "<leader>sg", function() grep("Grep", "grep") end, desc = "Grep (cwd)", },
    { "<leader>?", function() grep("Local Grep", "grep", { cwd = vim.fn.expand("%:p:h") }) end, desc = "Grep (buffer dir)", },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History", },
    -- find
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers", },
    { "<leader>fl", function() Snacks.picker.files({ cwd = vim.fn.expand("%:p:h") }) end, desc = "Find Files (buffer dir)", },
    { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config"), follow = true, ignored = true }) end, desc = "Find Files (nvim config)", },
    { "<leader>fC", function() Snacks.picker.files({ cwd = _G.DOTFILES, follow = true, ignored = true }) end, desc = "Find Files ($XDG_CONFIG_HOME)", },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files", },
    { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Files (Git)", },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects", },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent", },
    -- buffers
    { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers", },
    { "<leader>bb", function() Snacks.picker.buffers() end, desc = "Buffers", },
    -- git
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches", },
    { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log", },
    { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line", },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status", },
    { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash", },
    -- { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)", },
    { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File", },
    { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" }, },
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit", },
    -- notifications
    { "<leader>nn", function() require("mini.notify").show_history() end, desc = "Notification History", },
    { "<leader>nm", "<cmd>messages<cr>", desc = "Message history", },
    -- search
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines", },
    { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers", },
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers", },
    { "<leader>s/", function() Snacks.picker.search_history() end, desc = "Search History", },
    { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds", },
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines", },
    { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History", },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands", },
    { "<leader>sO", function() Snacks.picker.colorschemes() end, desc = "Colorschemes", },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics", },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics", },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages", },
    { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights", },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons", },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps", },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps", },
    { "<leader>sK", function() Snacks.picker.keymaps({global = false, ["local"] = true}) end, desc = "Keymaps (local)"},
    { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List", },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks", },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages", },
    { "<leader>sp", function() Snacks.picker.lazy() end, desc = "lazy.nvim Plugin Spec", },
    { "<leader>sP", function() Snacks.picker.files({ cwd = require("lazy.core.config").options.root }) end, desc = "Installed Plugin Source", },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List", },
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume", },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History", },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols", },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols", },

    { "<leader>sU", pickers.unicode, desc = "Unicode Character" },
    { "<leader>xx", pickers.npm, desc = "npm script" },

    -- LSP
    { "<leader>ld", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition", },
    { "<leader>lD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration", },
    { "<leader>lr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References", },
    { "<leader>lI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation", },
    { "<leader>ly", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition", },
    -- Other
    -- { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
    -- { "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
    { "<leader>xR", function() Snacks.rename.rename_file() end, desc = "Rename File", },
    { "<leader>xc", function() vim.cmd.cd(vim.fn.expand("%:p:h")) end, desc = "cd to buffer's dir", },
    { "<leader>xy", require("util").copy_filename, desc = "Copy buffer path to clipboard" },

    -- { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
    -- { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
    -- { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" }, },
    { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" }, },
    -- stylua: ignore end
  },
}
