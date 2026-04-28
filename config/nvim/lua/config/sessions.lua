-- sessions are saved based on cwd when nvim is opened
-- but only when nvim has no cli args
--
-- if nvim had cli args, then we'll use shada instead of session, below
-- and make sure not to overwrite the existing session file if there is one

local vimrc_augroup = vim.api.nvim_create_augroup("vimrc", { clear = false })
local should_use_session = vim.fn.argc() == 0 and not vim.g._no_session

-- don't include `options`; it messes with lchdir autocmd elsewhere
vim.opt.sessionoptions = {
  "buffers",
  "help",
  "folds",
  "tabpages",
  "winpos",
  "winsize",
  "skiprtp",
}

local function session_path()
  -- use global cwd (-1) so lchdir autocmd doesn't affect session naming
  local name = vim.fn.getcwd(-1):gsub("%%", "%%%%"):gsub("/", "%%")
  return vim.fn.stdpath("state") .. "/sessions/" .. name .. ".vim"
end

local function save()
  if not should_use_session then
    return
  end
  -- I only want to save the first tab; others will be stuff like diffview
  vim.cmd("1tabnext | tabonly")

  -- mark non-file buffers as nofile before mksession so they're excluded
  -- then restore buftype/buflisted after saving session
  -- https://github.com/neovim/neovim/issues/12242
  local saved_buf_configs = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype ~= "" then
      saved_buf_configs[buf] = { buftype = vim.bo[buf].buftype, buflisted = vim.bo[buf].buflisted }
      local ok = pcall(function()
        vim.bo[buf].buflisted = false
        vim.bo[buf].buftype = "nofile"
      end)
      if not ok then
        saved_buf_configs[buf] = nil
      end
    end
  end

  -- close side panels so their window sizes don't corrupt the saved layout
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.bo[buf].filetype
    if ft == "NvimTree" then
      pcall(vim.api.nvim_win_close, win, true)
    end
  end

  pcall(vim.fn.mkdir, vim.fn.stdpath("state") .. "/sessions", "p")
  pcall(vim.cmd, "mksession! " .. vim.fn.fnameescape(session_path()))

  for buf, s in pairs(saved_buf_configs) do
    if vim.api.nvim_buf_is_valid(buf) then
      vim.bo[buf].buftype = s.buftype
      vim.bo[buf].buflisted = s.buflisted
    end
  end
end

local function load()
  if not should_use_session then
    return
  end
  local path = session_path()
  if vim.fn.filereadable(path) == 1 then
    vim.cmd("silent! source " .. vim.fn.fnameescape(path))
  end
end

vim.api.nvim_create_autocmd("VimEnter", { once = true, nested = true, group = vimrc_augroup, callback = load })
vim.api.nvim_create_autocmd("VimLeavePre", { nested = true, group = vimrc_augroup, callback = save })

-- restore cursor position from shada when opening a file via nvim cli args
-- (we ignore session file if one exists)
vim.api.nvim_create_autocmd("BufReadPost", {
  group = vimrc_augroup,
  callback = function()
    if should_use_session then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 0 then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

return { save = save }
