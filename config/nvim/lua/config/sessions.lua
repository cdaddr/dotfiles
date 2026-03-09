local vimrc_augroup = vim.api.nvim_create_augroup("vimrc", { clear = false })

vim.opt.sessionoptions = {
  "buffers",
  "help",
  "folds",
  "tabpages",
  "winpos",
  "winsize",
  "options",
  "skiprtp",
}

local function session_path()
  -- use global cwd (-1) so lchdir from the project-root autocmd doesn't affect session naming
  local name = vim.fn.getcwd(-1):gsub("%%", "%%%%"):gsub("/", "%%")
  return vim.fn.stdpath("state") .. "/sessions/" .. name .. ".vim"
end

local function save()
  vim.cmd("1tabnext | tabonly")

  -- mark non-file buffers as nofile before mksession so they're excluded
  -- https://github.com/neovim/neovim/issues/12242
  local saved_buf_configs = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype ~= "" then
      saved_buf_configs[buf] = { buftype = vim.bo[buf].buftype, buflisted = vim.bo[buf].buflisted }
      vim.bo[buf].buflisted = false
      vim.bo[buf].buftype = "nofile"
    end
  end

  vim.fn.mkdir(vim.fn.stdpath("state") .. "/sessions", "p")
  vim.cmd("mksession! " .. vim.fn.fnameescape(session_path()))

  for buf, s in pairs(saved_buf_configs) do
    if vim.api.nvim_buf_is_valid(buf) then
      vim.bo[buf].buftype = s.buftype
      vim.bo[buf].buflisted = s.buflisted
    end
  end
end

local function load()
  if vim.fn.argc() ~= 0 then
    return
  end
  local path = session_path()
  if vim.fn.filereadable(path) == 1 then
    vim.cmd("silent! source " .. vim.fn.fnameescape(path))
  end
end

vim.api.nvim_create_autocmd("VimEnter", { once = true, nested = true, group = vimrc_augroup, callback = load })
vim.api.nvim_create_autocmd("VimLeavePre", { nested = true, group = vimrc_augroup, callback = save })
