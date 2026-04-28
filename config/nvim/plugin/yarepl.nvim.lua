vim.pack.add({ "https://github.com/milanglacier/yarepl.nvim" })

local yarepl = require("yarepl")

yarepl.setup({
  -- open REPL in a horizontal split at the bottom (like toggleterm)
  wincmd = "belowright 15 split",
  metas = {
    aichat = false,
    radian = false,
    ipython = false,
    python = false,
    R = false,
    bash = false,
    psql = {
      -- use $DATABASE_URL if set, otherwise prompt
      cmd = function()
        local default = os.getenv("DATABASE_URL") or ""
        local url = vim.fn.input("PostgreSQL URL: ", default)
        local test = url == "" and { "psql", "--command", "\\q" } or { "psql", url, "--command", "\\q" }
        local result = vim.fn.system(test)
        if vim.v.shell_error ~= 0 then
          vim.schedule(function()
            vim.notify("psql: " .. vim.trim(result), vim.log.levels.ERROR)
          end)
          return { "sh", "-c", "exit 0" }
        end
        return url == "" and { "psql" } or { "psql", url }
      end,
      formatter = "bracketed_pasting",
    },
    sqlite = {
      cmd = function()
        local default = os.getenv("DATABASE_URL") or ""
        local db = vim.fn.input("SQLite file: ", default, "file")
        local rlwrap = { "rlwrap", "--always-readline", "--no-children" }
        if db == "" then
          return vim.list_extend(rlwrap, { "sqlite3" })
        end
        return vim.list_extend(rlwrap, { "sqlite3", db })
      end,
      formatter = "trim_empty_lines",
    },
  },
})

vim.api.nvim_create_user_command("PG", "REPLStart psql", {})
vim.api.nvim_create_user_command("SQLITE", "REPLStart sqlite", {})

local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc })
end
map("n", "<leader>xp", "<cmd>REPLStart psql<cr>", "Start psql REPL")
map("n", "<leader>xP", "<cmd>REPLStart sqlite<cr>", "Start sqlite REPL")
map("n", "<leader>xd", "<cmd>REPLFocus psql<cr>", "Focus psql REPL")
map("n", "<leader>xh", "<cmd>REPLHide psql<cr>", "Hide psql REPL")
map("n", "<leader>xl", "<cmd>REPLSendLine<cr>", "Send line to REPL")
map("n", "<leader>xm", "<cmd>REPLSendOperator<cr>", "Send motion to REPL")
map("v", "<leader>xv", ":<c-u>REPLSendVisual<cr>", "Send selection to REPL")

-- collect all kitty windows whose foreground process is psql
local function kitty_find_psql_windows()
  local ls = vim.fn.system("kitty @ ls")
  if vim.v.shell_error ~= 0 then return {} end
  local ok, data = pcall(vim.json.decode, ls)
  if not ok then return {} end
  local results = {}
  for _, os_win in ipairs(data) do
    for _, tab in ipairs(os_win.tabs or {}) do
      for _, win in ipairs(tab.windows or {}) do
        for _, proc in ipairs(win.foreground_processes or {}) do
          local cmd = (proc.cmdline or {})[1] or ""
          if cmd:match("psql") then
            table.insert(results, {
              id = win.id,
              tab = tab.title or "",
              cmdline = table.concat(proc.cmdline or {}, " "),
            })
            break
          end
        end
      end
    end
  end
  return results
end

local function kitty_send_to_psql(text)
  local windows = kitty_find_psql_windows()
  if #windows == 0 then
    vim.notify("no kitty window running psql found", vim.log.levels.WARN)
    return
  end
  local function send(win)
    local out = vim.fn.system(
      { "kitty", "@", "send-text", "--match", "id:" .. win.id, "--stdin" },
      text
    )
    if vim.v.shell_error ~= 0 then
      vim.notify("kitty send-text failed: " .. vim.trim(out), vim.log.levels.ERROR)
    end
  end
  if #windows == 1 then
    send(windows[1])
  else
    local labels = vim.tbl_map(function(w)
      return string.format("[%s] %s", w.tab, w.cmdline)
    end, windows)
    vim.ui.select(labels, { prompt = "Select psql window:" }, function(_, idx)
      if idx then send(windows[idx]) end
    end)
  end
end

map("n", "<leader>xb", function()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    vim.notify("buffer has no file path", vim.log.levels.WARN)
    return
  end
  kitty_send_to_psql("\\i " .. path .. "\n")
end, "Send buffer to kitty psql")
