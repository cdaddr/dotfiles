-- eager (now): indent guides are part of the first frame
now(function()
  local util = require("util")

  vim.pack.add({ "https://github.com/nvimdev/indentmini.nvim" })

  -- capture the callbacks setup() hands to nvim_set_decoration_provider, so the
  -- patch below can reach indentmini's file-local on_win
  local ns = vim.api.nvim_create_namespace("IndentLine")
  local real_set_provider = vim.api.nvim_set_decoration_provider
  local callbacks
  vim.api.nvim_set_decoration_provider = function(namespace, cbs)
    if namespace == ns then
      callbacks = cbs
    end
    return real_set_provider(namespace, cbs)
  end

  local setup_ok, setup_err = pcall(require("indentmini").setup, {
    minlevel = 2,
    char = "┊",
  })
  vim.api.nvim_set_decoration_provider = real_set_provider
  if not setup_ok then
    error(setup_err)
  end

  -- MONKEY PATCH: remove once nvimdev/indentmini.nvim fixes this upstream.
  --
  -- indentmini's on_win does `context.has_ts = pcall(treesitter.get_parser, bufnr)`,
  -- which relied on get_parser raising when no parser exists. Neovim 0.13 changed it
  -- to return nil instead, so has_ts is now always true. on_line then calls get_node()
  -- for every indent level of every visible line, and each call rescans the whole
  -- runtimepath for a parser that will never exist (~45ms/redraw in qed buffers).
  --
  -- on_win holds `treesitter` in an upvalue slot separate from the ones make_snapshot
  -- and on_line hold, so swapping just that slot patches the one buggy call site
  -- without copying any plugin code.
  local function patch_has_ts()
    if not (callbacks and callbacks.on_win) then
      return "could not capture indentmini's decoration provider"
    end
    local index, i = nil, 1
    while true do
      local name, value = debug.getupvalue(callbacks.on_win, i)
      if not name then
        break
      end
      if name == "treesitter" then
        if not rawequal(value, vim.treesitter) then
          return "on_win's `treesitter` upvalue is not vim.treesitter"
        end
        index = i
        break
      end
      i = i + 1
    end
    if not index then
      return "on_win has no `treesitter` upvalue"
    end
    debug.setupvalue(
      callbacks.on_win,
      index,
      setmetatable({
        -- raise on a missing parser, so indentmini's pcall reads it as absent
        get_parser = function(...)
          local parser = vim.treesitter.get_parser(...)
          if parser == nil then
            error("indentmini has_ts patch: no parser", 0)
          end
          return parser
        end,
      }, { __index = vim.treesitter })
    )
  end

  local patch_err = patch_has_ts()
  if patch_err then
    vim.schedule(function()
      vim.notify("indentmini has_ts patch skipped: " .. patch_err, vim.log.levels.WARN)
    end)
  end

  util.on_colorscheme(function()
    local linenr_hl = vim.api.nvim_get_hl(0, { name = "LineNr" })
    local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })
    local bg = normal_hl.bg or 0x16161D
    if linenr_hl.fg then
      vim.api.nvim_set_hl(0, "IndentLine", { fg = util.blend(linenr_hl.fg, bg, 0.5) })
      vim.api.nvim_set_hl(0, "IndentLineCurrent", { fg = linenr_hl.fg })
    end
  end)
end)
