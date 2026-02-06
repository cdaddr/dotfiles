local util = require("util")

-- Repo-wide git status (cached, updated on events)
local git_repo_status = { added = 0, modified = 0, removed = 0, conflicts = 0 }
local git_status_job = nil

local function update_git_repo_status()
  local cwd = vim.fn.getcwd()
  -- Check if we're in a git repo
  if vim.fn.isdirectory(cwd .. "/.git") == 0 and vim.fn.systemlist("git rev-parse --git-dir 2>/dev/null")[1] == nil then
    git_repo_status = { added = 0, modified = 0, removed = 0, conflicts = 0 }
    return
  end

  -- Cancel any existing job
  if git_status_job then
    vim.fn.jobstop(git_status_job)
  end

  git_status_job = vim.fn.jobstart({ "git", "status", "--porcelain" }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      local added, modified, removed, conflicts = 0, 0, 0, 0
      for _, line in ipairs(data) do
        if line ~= "" then
          local status = line:sub(1, 2)
          -- Merge conflicts (unmerged states)
          if status:match("^[UD][UD]") or status == "AA" then
            conflicts = conflicts + 1
          -- Untracked or new files
          elseif status:match("^%?%?") or status:match("^A") or status:match("^ A") then
            added = added + 1
          -- Deleted
          elseif status:match("^D") or status:match("^ D") then
            removed = removed + 1
          -- Modified, renamed, copied
          elseif status:match("[MRC]") then
            modified = modified + 1
          end
        end
      end
      git_repo_status = { added = added, modified = modified, removed = removed, conflicts = conflicts }
      -- Trigger lualine refresh
      vim.schedule(function()
        if package.loaded["lualine"] then
          require("lualine").refresh()
        end
      end)
    end,
  })
end

-- Set up autocmds to refresh git status
vim.api.nvim_create_autocmd({ "BufWritePost", "FocusGained", "DirChanged" }, {
  callback = update_git_repo_status,
})

-- Initial update (deferred)
vim.defer_fn(update_git_repo_status, 100)

local function is_new_file()
  local filename = vim.fn.expand("%")
  return filename ~= ""
    and filename:match("^%a+ ://") == nil
    and vim.bo.buftype == ""
    and vim.fn.filereadable(filename) == 0
end

local function is_unnamed()
  return vim.fn.expand("%:t") == ""
end

local function is_readonly()
  return not vim.bo.modifiable or vim.bo.readonly
end

local is_special = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local fn = vim.api.nvim_buf_get_name(bufnr)
  if fn:match("^fugitive://") then
    return true
  end
end

local is_normal = function()
  return not is_special()
end

local file_icon = function(colorfn, color)
  return {
    function()
      if is_special() then
        return
      end
      if is_readonly() then
        return ""
      end
      return ""
    end,
    color = function()
      if is_readonly() then
        return colorfn("WarningMsg")
      end
      return colorfn(color)
    end,
    padding = { left = 1, right = 0 },
    cond = is_normal,
  }
end

-- applies style, keeping section b / y bg
local mid = function(color)
  local bg_hl = util.copy_hl("DiffChange")
  local hl = color and util.copy_hl(color) or {}
  return vim.tbl_extend("force", hl, { bg = bg_hl.bg })
end

-- applies style, keeping section c / x bg
local inner = function(color)
  local bg_hl = util.copy_hl("SignColumn")
  local hl = color and util.copy_hl(color) or {}
  return vim.tbl_extend("force", hl, { bg = bg_hl.bg })
end

local special_name = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local fn = vim.api.nvim_buf_get_name(bufnr)
  local diff = vim.wo.diff
  return fn:match("^[^:]+") .. (diff and " diff" or "")
end

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  config = function()
    -- load theme, with fallback
    local status, theme = pcall(require, "lualine.themes." .. _G.theme.lualine)
    if not status then
      theme = require("lualine.themes.catppuccin")
    end
    -- sets the bg of the "middle" between section
    theme.normal.c.bg = util.copy_hl("LineNr").bg
    theme.inactive.c.bg = util.copy_hl("LineNr").bg
    theme.inactive.c.fg = util.copy_hl("WinSeparator").fg


      -- stylua: ignore start
      local sections = {
        lualine_a = {
          { "mode", cond = is_normal },
          { special_name, cond = is_special }
        },
        lualine_b = {
        -- file icon (warning color) is lock if r/o, otherwise generic file icon (normal color)
          file_icon(mid, "Keyword"),

          -- filename (base)
          {
            function()
              local bufnr = vim.api.nvim_get_current_buf()
              local bufname = vim.api.nvim_buf_get_name(bufnr)
              local special_prefix = bufname:match('^(%w+)://')
              if bufname == "" then
                return "New File"
              elseif special_prefix and special_prefix ~= "" then
                return "SPECIAL"
              end
              return vim.fn.expand("%:t")
            end,
            color = function()
              local hl = mid("Keyword")
              local bufname = vim.fn.expand("%")
              if is_new_file() or is_unnamed() or is_special() then
                hl.gui = "italic"
              end
              return hl
            end,
          },

          -- modified marker
          {
            function()
              if vim.bo.modified then
                return ""
              end
              return ""
            end,
            color = mid("diffNewFile"),
            padding = { left = 0, right = 1 },
            cond = is_normal
          },
          -- buffer diff numbers
          {
            "diff",
            source = function()
              local git_status = vim.b.gitsigns_status_dict
              if git_status then
                return {
                  added = git_status.added or 0,
                  modified = git_status.changed or 0,
                  removed = git_status.removed or 0,
                }
              end
            end,
            color = mid(),
            cond = is_normal
          },
        },
        lualine_c = {
          -- relative path
          {
            function()
              return vim.fn.fnamemodify(vim.fn.expand("%:~:.:p:h"), ":.")
            end,
            icon = "",
            cond = function()
              return is_normal() and vim.fn.expand("%") ~= ""
            end,
            color = inner("Comment"),
          },
          -- git branch
          {
            "branch",
            icon = "\u{f062c}",
            icons_enabled = true,
            padding = { left = 1, right = 0 },
            color = inner("Comment"),
            cond = is_normal
          },
          -- repo-wide git status (custom component to avoid lualine diff state issues)
          {
            function()
              local parts = {}
              if git_repo_status.added > 0 then
                table.insert(parts, "+" .. git_repo_status.added)
              end
              if git_repo_status.modified > 0 then
                table.insert(parts, "~" .. git_repo_status.modified)
              end
              if git_repo_status.removed > 0 then
                table.insert(parts, "-" .. git_repo_status.removed)
              end
              if git_repo_status.conflicts > 0 then
                table.insert(parts, "!" .. git_repo_status.conflicts)
              end
              return table.concat(parts, " ")
            end,
            color = inner("Comment"),
            cond = function()
              return is_normal() and ( git_repo_status.added > 0
                or git_repo_status.modified > 0
                or git_repo_status.removed > 0
                or git_repo_status.conflicts > 0)
            end,
          },
        },
        lualine_x = {
          {
            function()
              return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
            end,
            icon = "",
            color = inner("Comment"),
            on_click = function()
              vim.cmd("Oil")
            end,
            cond = is_normal
          },
          {
            "lsp_status",
            icon = "",
            symbols = {
              done = "",
              separator = "|",
            },
            fmt = function(txt)
              if txt then
                return "⨉" .. tostring(#vim.split(txt, "|"))
              end
              return txt
            end,
            color = inner("Comment"),
            on_click = function()
              vim.cmd("checkhealth lsp")
            end,
            cond = is_normal
          },
          -- code format-on-save enabled indicator, see conform.lua
          {
            function()
              if not vim.b.disable_format_on_save then
                return "󰁨 "
              end
            end,
            padding = 0,
            color = inner("Comment"),
            cond = is_normal
          },
          {
            "diagnostics",
            sections = { "error", "warn" },
            cond = is_normal
          },
          -- unicode hex of char under cursor
          {
            function()
              local line = vim.fn.getline(".")
              if line == "" then
                return ""
              end

              local byte_col = vim.fn.col(".") - 1 -- convert to 0-indexed byte position
              local char_idx = vim.fn.charidx(line, byte_col)
              if char_idx < 0 then
                return ""
              end

              local char = vim.fn.strcharpart(line, char_idx, 1)
              if char == "" then
                return ""
              end

              -- Get codepoint using vim's char2nr (handles multibyte)
              local codepoint = vim.fn.char2nr(char)
              if codepoint == 0 then
                return ""
              end
              return string.format("U+%04X", codepoint)
            end,
            icon = "",
            color = inner("Comment"),
            draw_empty = true,
          },
        },
        lualine_y = {
          {
            "filetype",
            colored = false,
            color = mid(),
          },
        },
        lualine_z = {
          {
            "%-2P 󰕱 %-3p 󰕭 %-2c",
            fmt = function(item)
              return " " .. item
            end,
          },
        },
      }

      local inactive_sections = {
        lualine_a = {
          { special_name, cond = is_special, color = inner('Comment') }
        },
        lualine_b = {
          file_icon(inner, "Comment"),
          {
            function()
              return vim.fn.fnamemodify(vim.fn.expand("%:~:.:p:h"), ":.")
            end,
            color = inner("Comment"),
            cond = is_normal
          },
        },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      }

      require("lualine").setup({
        extensions = { "oil", "quickfix", "mason", "lazy" },
        options = {
          theme = theme,
          icons_enabled = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = sections,
        inactive_sections = inactive_sections,
      })
  end,
}
