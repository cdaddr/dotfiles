local helpers = require("config.lualine.helpers")

local M = {}

local git_repo_status = { added = 0, modified = 0, removed = 0, conflicts = 0 }
local git_status_job = nil

local function update_git_repo_status()
  local cwd = vim.fn.getcwd()
  if vim.fn.isdirectory(cwd .. "/.git") == 0 and vim.fn.systemlist("git rev-parse --git-dir 2>/dev/null")[1] == nil then
    git_repo_status = { added = 0, modified = 0, removed = 0, conflicts = 0 }
    return
  end

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
          -- git porcelain status codes
          if status:match("^[UD][UD]") or status == "AA" then
            conflicts = conflicts + 1
          elseif status:match("^%?%?") or status:match("^A") or status:match("^ A") then
            added = added + 1
          elseif status:match("^D") or status:match("^ D") then
            removed = removed + 1
          elseif status:match("[MRC]") then
            modified = modified + 1
          end
        end
      end
      git_repo_status = { added = added, modified = modified, removed = removed, conflicts = conflicts }
      vim.schedule(function()
        if package.loaded["lualine"] then
          require("lualine").refresh()
        end
      end)
    end,
  })
end

vim.api.nvim_create_autocmd({ "BufWritePost", "FocusGained", "DirChanged" }, {
  callback = update_git_repo_status,
})

vim.defer_fn(update_git_repo_status, 100)

function M.branch(palette, active)
  local color = active and palette.dark_comment or palette.inactive_dark

  return {
    "branch",
    icon = "\u{f062c}",
    icons_enabled = true,
    padding = { left = 1, right = 0 },
    color = color,
    cond = helpers.is_normal,
  }
end

-- per-file diff from gitsigns
function M.buffer_diff(palette, active)
  local color = active and palette.mid_default or palette.inactive_mid

  return {
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
    color = color,
    cond = helpers.is_normal,
  }
end

function M.repo_status(palette, active)
  local color = active and palette.dark_comment or palette.inactive_dark

  return {
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
    color = color,
    cond = function()
      return helpers.is_normal()
        and (
          git_repo_status.added > 0
          or git_repo_status.modified > 0
          or git_repo_status.removed > 0
          or git_repo_status.conflicts > 0
        )
    end,
  }
end

return M
