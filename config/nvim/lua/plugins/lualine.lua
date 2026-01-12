local util = require 'util'

local function is_new_file()
  local filename = vim.fn.expand('%')
  return filename ~= ''
      and filename:match('^%a+ ://') == nil
      and vim.bo.buftype == ''
      and vim.fn.filereadable(filename) == 0
end

local function is_unnamed()
  return vim.fn.expand('%:t') == ''
end

-- Get the LSP root directory for the current buffer
local function get_lsp_root()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients > 0 then
    return clients[1].config.root_dir
  end
  return nil
end

-- Get relative path
local function get_relative_path()
  local root = get_lsp_root()
  if not root then
    return vim.fn.expand('%:.') -- fallback to cwd-relative
  end

  local file = vim.fn.expand('%:p')
  return vim.fn.fnamemodify(file, ':.' .. root)
end

local function is_readonly()
  return not vim.bo.modifiable or vim.bo.readonly
end

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  config = function()
    local setup_lualine = function()
      -- load theme, with fallback
      local status, theme = pcall(require, 'lualine.themes.' .. _G.theme.lualine)
      if not status then
        theme = require 'lualine.themes.catppuccin'
      end
      -- sets the bg of the "middle" between section
      theme.normal.c.bg = util.copy_hl('LineNr').bg
      theme.inactive.c.bg = util.copy_hl('LineNr').bg
      theme.inactive.c.fg = util.copy_hl('WinSeparator').fg

      -- applies style, keeping section b / y bg
      local mid = function(color)
        local bg_hl = util.copy_hl('DiffChange')
        local hl = color and util.copy_hl(color) or {}
        return vim.tbl_extend('force', hl, { bg = bg_hl.bg })
      end

      -- applies style, keeping section c / x bg
      local inner = function(color)
        local bg_hl = util.copy_hl('SignColumn')
        local hl = color and util.copy_hl(color) or {}
        return vim.tbl_extend('force', hl, { bg = bg_hl.bg })
      end

      -- file icon (warning color) is lock if r/o, otherwise generic file icon (normal color)
      local file_icon = function(colorfn, color)
        return  {
          function()
            if is_readonly() then
              return ""
            end
            return ''
          end,
          color = function()
            if is_readonly() then
              return colorfn('WarningMsg')
            end
            return colorfn(color)
          end,
          padding = { left = 1, right = 0 },
        }
      end

      local sections = {
        lualine_b = {
          -- lock / file icon
          file_icon(mid, 'Keyword'),

          -- filename (base)
          {
            'filename',
            file_status = false,
            newfile_status = false,
            symbols = {
              unnamed = "New File",
            },
            color = function(section)
              local hl = mid('Keyword')
              if is_new_file() or is_unnamed() then
                hl.gui = 'italic'
              end
              return hl
            end,
          },

          -- modified marker
          {
            function()
              if vim.bo.modified then
                return ""
              end
              return ''
            end,
            color = mid('diffNewFile'),
            padding = { left = 0, right = 1 },
          },
          -- buffer diff numbers
          {
            'diff',
            color = mid()
          },
        },
        lualine_c = {
          -- relative path
          {
            function() return vim.fn.fnamemodify(vim.fn.expand('%'), ':.') end,
            icon = '',
            cond = function() return vim.fn.expand('%') ~= '' end,
            color = inner('Comment')
          },
          -- git branch
          {
            'branch',
            icon = '',
            icons_enabled = true,
            padding = { left = 1, right = 0},
            color = inner('Comment')
          },
          -- git diff numbers, from gitsigns
          {
            function()
              local git_status = vim.b.gitsigns_status_dict
              if git_status then
                return string.format('[ +%d ~%d -%d ]', git_status.added or 0, git_status.changed or 0,
                  git_status.removed or 0)
              end
              return ''
            end,
            color = inner('Comment'),
            padding = { left = 0, right = 1},
          },
        },
        lualine_x = {
          {
            function() return vim.fn.fnamemodify(vim.fn.getcwd(), ':t') end,
            icon = '',
            color = inner('Comment'),
          },
          {
            'lsp_status',
            icon = '󰒋',
            color = inner('Comment'),
          },
          {
            'diagnostics',
            sections = { 'error', 'warn' }
          },
          -- unicode hex of char under cursor
          {
            function()
              local char = vim.fn.strcharpart(vim.fn.getline('.'), vim.fn.col('.') - 1, 1)
              local code = vim.fn.char2nr(char)
              return string.format('U+%04X', code)
            end,
            icon = '',
            color = inner('Comment')
          },
        },
        lualine_y = {
          {
            'filetype',
            colored = false,
            color = mid(),
          },
        },
        lualine_z = {
          {
            '%-2P 󰕱 %-2p 󰕭 %-2c',
            fmt = function(item) return ' ' .. item end,
          },
        },
      }
      local inactive_sections = {
        lualine_a = {},
        lualine_b = {
          file_icon(inner, 'Comment'),
          {
            function() return vim.fn.fnamemodify(vim.fn.getcwd(), ':.') end,
            path = 1,
            color = inner('Comment'),
          }
        },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      }
      require('lualine').setup({
        extensions = { 'oil', 'quickfix', 'mason', 'lazy', 'fugitive', },
        options = {
          theme = theme,
          icons_enabled = true,
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
        },
        sections = sections,
        inactive_sections = inactive_sections,
      })
    end

    -- Initial setup
    setup_lualine()

    -- Clear lualine's built-in ColorScheme autocmd that resets config
    vim.api.nvim_clear_autocmds({ group = 'lualine' })

    -- Re-apply our config after colorscheme loads
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = setup_lualine,
    })
  end,
}
