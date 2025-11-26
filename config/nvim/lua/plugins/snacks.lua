return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      delay = 750,
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
    opts = {
      terminal = {},
      picker = {
        enabled = true,
        layout = { preset = 'ivy', width = 0.9 },
        formatters = {
          file = {
            filename_first = true,
          }
        },
        win = {
          input = {
            keys = {
              ["<s-cr>"] = { "edit_vsplit", mode = { "i", "n" } },
              ["<m-K>"] = { "history_back", mode = { "i", "n" } },
              ["<m-J>"] = { "history_forward", mode = { "i", "n" } },
              ["<C-p>"] = { "focus_preview", mode = { "i", "n" } },
            }
          }
        },
      },
      toggle = {
        enabled = true,
      },
    },
    keys = {
      -- CMD shortcuts
      { "<D-o>", function() Snacks.picker.git_files() end, desc = "Find Files (Git)" },
      { "<D-f>", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<D-p>", function() Snacks.picker.smart() end, desc = "Find Files (Smart)" },
      { "<D-e>", function() Snacks.picker.recent() end, desc = "Find Files (Recent)" },

      { "<leader><space>", function() Snacks.picker.recent() end, desc = "Recent" },
      { "<leader>p", function() Snacks.picker.smart() end, desc = "Find Files (Smart)" },
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep (cwd)" },
      { "<leader>l/", function() Snacks.picker.grep({cwd = vim.fn.expand("%:p:h")}) end, desc = "Grep (Git root)" },
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>q", function() Snacks.picker.grep({format = function(item) return {id=1,filename="foo.txt",text="foo"} end}) end},
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
      -- git
      { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
      { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
      { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
      { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
      { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
      -- Grep
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
      -- search
      { "<leader>sn", function() Snacks.picker.notifications() end, desc = "Notification History" },
      { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
      { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
      { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
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
      { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
      { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
      { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
      { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
      { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
      -- LSP
      { "<leader>ld", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
      { "<leader>lD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
      { "<leader>lr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
      { "<leader>lI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
      { "<leader>ly", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
      { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
      -- Other
      -- { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
      -- { "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
      { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
      { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
      { "<leader>gn", function() Snacks.notifier.show_history() end, desc = "Notification History" },
      { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      -- { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
      -- { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
      { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
      { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },

      { "<leader>x", function() 
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
      end}
    },
  }
}
