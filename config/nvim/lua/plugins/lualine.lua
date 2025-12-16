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
      local dark_bg = { bg = util.copy_hl('LineNr').bg }
      local with_dark_bg = function(color)
        local hl = util.copy_hl(color)
        return vim.tbl_extend('force', hl, dark_bg)
      end
      local file_icon = {
            function()
              if is_readonly() then
                return ""
              end
              return ''
            end,
            color = function()
              if is_readonly() then
                return with_dark_bg('WarningMsg')
              end
              return with_dark_bg('Keyword')
            end,
            padding = { left = 1, right = 0 },
          }
      local sections = {
        lualine_b = {
          file_icon ,

          -- filename (base)
          {
            'filename',
            file_status = false,
            newfile_status = false,
            symbols = {
              unnamed = "New File",
            },
            color = function(section)
              local hl = with_dark_bg('Keyword')
              if is_new_file() or is_unnamed() then
                hl.gui = 'italic'
              end
              return hl
            end,
            icons_enabled = true,
          },
          -- modified marker
          {
            function()
              if vim.bo.modified then
                return ""
              end
              return ''
            end,
            color = with_dark_bg('diffNewFile'),
            padding = { left = 0, right = 1 },
          },
          {
            'diff',
            color = dark_bg
          },
        },
        lualine_c = {
          -- path
          {
            'filename',
            path = 1,
            fmt = function(item) return ' ' .. item end,
            cond = function() return vim.fn.expand('%') ~= '' end,
            color = function()
              return util.copy_hl('Comment')
            end
          },
          {
            'branch',
            fmt = function(item) return ' ' .. item end,
            color = function()
              return util.copy_hl('Comment')
            end
          },
          {
            function()
              local git_status = vim.b.gitsigns_status_dict
              if git_status then
                return string.format('+%d ~%d -%d', git_status.added or 0, git_status.changed or 0,
                  git_status.removed or 0)
              end
              return ''
            end,
            color = function()
              return util.copy_hl('Comment')
            end
            -- padding = { left = 0, right = 1},
          },
        },
        lualine_x = {
          -- {
          --   'grapple',
          --   color = function() return util.copy_hl('Comment') end
          -- },
          -- {
          --   'encoding',
          --   color = function() return util.copy_hl('Comment') end
          -- },
          -- {
          --   'fileformat',
          --   color = function() return util.copy_hl('Comment') end
          -- },
          {
            'lsp_status',
            color = function() return util.copy_hl('Comment') end
          },
          {
            'diagnostics'
          },
        },
        lualine_y = {
          {
            'filetype',
            icons_enabled = true,
            color = dark_bg,
          },
        },
        lualine_z = {
          {
            '%P 󰕱 %p 󰕭 %c',
            fmt = function(item) return ' ' .. item end,
          },
        },
      }
      local inactive_sections = {
        lualine_a = {},
        lualine_b = {
          file_icon,
          {
            'filename',
            path = 1,
            color = function()
              local comment = util.copy_hl('Keyword')
              return { fg = comment.fg, bg = dark_bg.bg }
            end,
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
          theme = _G.theme.lualine or 'catppuccin-mocha',
          icons_enabled = false,
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          -- globalstatus = true,
        },
        sections = sections,
        inactive_sections = inactive_sections
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
