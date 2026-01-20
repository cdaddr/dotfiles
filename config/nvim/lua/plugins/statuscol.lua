return {
  "luukvbaal/statuscol.nvim",
  config = function()
    local builtin = require("statuscol.builtin")
    -- vim.o.foldcolumn = "no"
    -- vim.o.signcolumn = "no"
    vim.o.fillchars = 'eob: ,fold: ,foldopen:+,foldsep:|,foldinner: ,foldclose:-'

    local foldcol = function()
      local foldsigns = {
        open = '+',
        close = '–',
        seps = { '┊', '┆', '│', },

        --     seps = { '┊', '┆', }, -- open fold middle marker , '┃' 
      }
      local lnum = vim.v.lnum
      local foldlevel = vim.fn.foldlevel(vim.v.lnum)
      local prev_foldlevel = lnum > 1 and vim.fn.foldlevel(lnum - 1) or 0

      local foldtext = ' '
      if foldlevel > 0 then
        if vim.fn.foldclosed(vim.v.lnum) == lnum then
          foldtext = foldsigns.open
        elseif foldlevel > prev_foldlevel then
          foldtext = foldsigns.close
        else
          foldtext = foldsigns.seps[foldlevel] or foldsigns.seps[#foldsigns.seps]
        end
      end
      return foldtext
    end
    require'statuscol'.setup({
      setopt = true,
      segments = {
        {
          text = { "%s" },
          click = "v:lua.ScSa",
          condition = { builtin.not_empty },
        },
        {
          text = { foldcol, " " },
          click = "v:lua.ScFa",
          hl = "FoldColumn",
          colwidth = 2,
          maxwidth = 2,
          condition = { builtin.not_empty },
        },
        {
          text = { builtin.lnumfunc, " " },
          condition = { true, builtin.not_empty },
          click = "v:lua.ScLa",
        }
      }
    })
  end
}
