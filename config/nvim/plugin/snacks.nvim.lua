local pickers = require("config.pickers")

-- open a grep picker with cwd shown in title
local function grep(title, source, opts)
  opts = opts or {}
  local dir = opts.cwd or vim.fn.getcwd()
  opts.title = title .. " (" .. vim.fn.fnamemodify(dir, ":~") .. ")"
  Snacks.picker[source](opts)
end

vim.pack.add({ 'https://github.com/folke/snacks.nvim' })

-- override column number highlight for better visibility on selected lines
vim.api.nvim_set_hl(0, "SnacksPickerCol", { link = "SnacksPickerIdx" })

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
        if p >= 0 then table.insert(adjusted, p) end
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
    require("oil").open(dir)
  end
end

-- close picker if in input mode and typed input is blank; always close in normal mode
local close_if_no_input = function(picker)
  local mode = vim.fn.mode()
  if mode == "i" then
    local line = vim.api.nvim_get_current_line()
    if line == "" then picker:close()
    else vim.cmd("stopinsert") end
  else
    picker:close()
  end
end

local exit_insert = function() vim.cmd("stopinsert") end

local win_opts = { input = { keys = { ["<c-o>"] = { "open_in_oil", mode = { "n", "i" }, desc = "Open in Oil" } } } }
local exclude = { ".lock", "*lock.json", "*lock.yaml", "*lock.yml", "*lock.toml" }

---@type snacks.Config
require('snacks').setup({
  terminal = {},
  picker = {
    enabled = true,
    layout = { preset = "ivy", width = 0.9 },
    formatters = {
      file = { filename_first = true },
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
  },
  toggle = { enabled = true, notify = true },
})

-- toggle mappings (Snacks global now available)
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

-- stylua: ignore start
vim.keymap.set("n", "<leader>r", function() Snacks.picker.recent() end, { desc = "Recent" })
vim.keymap.set("n", "<leader>p", function() Snacks.picker.smart() end, { desc = "Find Files (Smart)" })
vim.keymap.set("n", "<leader>/", function() grep("Grep", "grep") end, { desc = "Grep (cwd)" })
vim.keymap.set("n", "<leader>sg", function() grep("Grep", "grep") end, { desc = "Grep (cwd)" })
vim.keymap.set("n", "<leader>?", function() grep("Local Grep", "grep", { cwd = vim.fn.expand("%:p:h") }) end, { desc = "Grep (buffer dir)" })
vim.keymap.set("n", "<leader>:", function() Snacks.picker.command_history() end, { desc = "Command History" })
-- find
vim.keymap.set("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fl", function() Snacks.picker.files({ cwd = vim.fn.expand("%:p:h") }) end, { desc = "Find Files (buffer dir)" })
vim.keymap.set("n", "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config"), follow = true, ignored = true }) end, { desc = "Find Files (nvim config)" })
vim.keymap.set("n", "<leader>fC", function() Snacks.picker.files({ cwd = _G.DOTFILES, follow = true, ignored = true }) end, { desc = "Find Files ($XDG_CONFIG_HOME)" })
vim.keymap.set("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", function() Snacks.picker.git_files() end, { desc = "Find Files (Git)" })
vim.keymap.set("n", "<leader>fp", function() Snacks.picker.projects() end, { desc = "Projects" })
vim.keymap.set("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Recent" })
-- buffers
vim.keymap.set("n", "<leader>,", function() Snacks.picker.buffers() end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>bb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
-- git
vim.keymap.set("n", "<leader>gb", function() Snacks.picker.git_branches() end, { desc = "Git Branches" })
vim.keymap.set("n", "<leader>gl", function() Snacks.picker.git_log() end, { desc = "Git Log" })
vim.keymap.set("n", "<leader>gL", function() Snacks.picker.git_log_line() end, { desc = "Git Log Line" })
vim.keymap.set("n", "<leader>gs", function() Snacks.picker.git_status() end, { desc = "Git Status" })
vim.keymap.set("n", "<leader>gS", function() Snacks.picker.git_stash() end, { desc = "Git Stash" })
vim.keymap.set("n", "<leader>gf", function() Snacks.picker.git_log_file() end, { desc = "Git Log File" })
vim.keymap.set({ "n", "v" }, "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Git Browse" })
vim.keymap.set("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })
-- notifications
vim.keymap.set("n", "<leader>nn", function() require("mini.notify").show_history() end, { desc = "Notification History" })
vim.keymap.set("n", "<leader>nm", "<cmd>messages<cr>", { desc = "Message history" })
-- search
vim.keymap.set("n", "<leader>sb", function() Snacks.picker.lines() end, { desc = "Buffer Lines" })
vim.keymap.set("n", "<leader>sB", function() Snacks.picker.grep_buffers() end, { desc = "Grep Open Buffers" })
vim.keymap.set("n", '<leader>s"', function() Snacks.picker.registers() end, { desc = "Registers" })
vim.keymap.set("n", "<leader>s/", function() Snacks.picker.search_history() end, { desc = "Search History" })
vim.keymap.set("n", "<leader>sa", function() Snacks.picker.autocmds() end, { desc = "Autocmds" })
vim.keymap.set("n", "<leader>sc", function() Snacks.picker.command_history() end, { desc = "Command History" })
vim.keymap.set("n", "<leader>sC", function() Snacks.picker.commands() end, { desc = "Commands" })
vim.keymap.set("n", "<leader>sO", function() Snacks.picker.colorschemes() end, { desc = "Colorschemes" })
vim.keymap.set("n", "<leader>sd", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, { desc = "Buffer Diagnostics" })
vim.keymap.set("n", "<leader>sh", function() Snacks.picker.help() end, { desc = "Help Pages" })
vim.keymap.set("n", "<leader>sH", function() Snacks.picker.highlights() end, { desc = "Highlights" })
vim.keymap.set("n", "<leader>si", function() Snacks.picker.icons() end, { desc = "Icons" })
vim.keymap.set("n", "<leader>sj", function() Snacks.picker.jumps() end, { desc = "Jumps" })
vim.keymap.set("n", "<leader>sk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>sK", function() Snacks.picker.keymaps({ global = false, ["local"] = true }) end, { desc = "Keymaps (local)" })
vim.keymap.set("n", "<leader>sl", function() Snacks.picker.loclist() end, { desc = "Location List" })
vim.keymap.set("n", "<leader>sm", function() Snacks.picker.marks() end, { desc = "Marks" })
vim.keymap.set("n", "<leader>sM", function() Snacks.picker.man() end, { desc = "Man Pages" })
vim.keymap.set("n", "<leader>sq", function() Snacks.picker.qflist() end, { desc = "Quickfix List" })
vim.keymap.set("n", "<leader>sR", function() Snacks.picker.resume() end, { desc = "Resume" })
vim.keymap.set("n", "<leader>su", function() Snacks.picker.undo() end, { desc = "Undo History" })
vim.keymap.set("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, { desc = "LSP Symbols" })
vim.keymap.set("n", "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "LSP Workspace Symbols" })
vim.keymap.set("n", "<leader>sU", pickers.unicode, { desc = "Unicode Character" })
vim.keymap.set("n", "<leader>xx", pickers.npm, { desc = "npm script" })
-- LSP
vim.keymap.set("n", "<leader>ld", function() Snacks.picker.lsp_definitions() end, { desc = "Goto Definition" })
vim.keymap.set("n", "<leader>lD", function() Snacks.picker.lsp_declarations() end, { desc = "Goto Declaration" })
vim.keymap.set("n", "<leader>lr", function() Snacks.picker.lsp_references() end, { nowait = true, desc = "References" })
vim.keymap.set("n", "<leader>lI", function() Snacks.picker.lsp_implementations() end, { desc = "Goto Implementation" })
vim.keymap.set("n", "<leader>ly", function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" })
-- other
vim.keymap.set("n", "<leader>xR", function() Snacks.rename.rename_file() end, { desc = "Rename File" })
vim.keymap.set("n", "<leader>xc", function() vim.cmd.cd(vim.fn.expand("%:p:h")) end, { desc = "cd to buffer's dir" })
vim.keymap.set({ "n", "t" }, "]]", function() Snacks.words.jump(vim.v.count1) end, { desc = "Next Reference" })
vim.keymap.set({ "n", "t" }, "[[", function() Snacks.words.jump(-vim.v.count1) end, { desc = "Prev Reference" })
-- stylua: ignore end
