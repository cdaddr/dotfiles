return {
  "luukvbaal/statuscol.nvim",
  init = function()
    vim.o.fillchars = "eob: ,fold: ,foldopen:▽,foldsep:|,foldinner: ,foldclose:▷"
  end,

  config = function()
    local builtin = require("statuscol.builtin")

    -- Custom fold click handler
    _G.FoldClick = function(minwid, clicks, button, mods)
      local line = vim.fn.getmousepos().line
      if button == "l" then
        if vim.fn.foldclosed(line) ~= -1 then
          vim.cmd(line .. "foldopen")
        else
          vim.cmd(line .. "foldclose")
        end
      end
    end
    -- vim.o.foldcolumn = "no"
    -- vim.o.signcolumn = "no"

    local foldcol = function()
      local foldsigns = {
        closed = "%#SignColumn#▷",
        opened = "%#StatusColFold#▽",
        seps = { "%#StatusColFold#┊", "%#StatusColFold#┆", "%#StatusColFold#│" },
      }
      local lnum = vim.v.lnum
      local foldlevel = vim.fn.foldlevel(vim.v.lnum)
      local prev_foldlevel = lnum > 1 and vim.fn.foldlevel(lnum - 1) or 0

      local foldtext = " "
      if foldlevel > 0 then
        if vim.fn.foldclosed(vim.v.lnum) == lnum then
          foldtext = foldsigns.closed
        elseif foldlevel > prev_foldlevel then
          foldtext = foldsigns.opened
        else
          foldtext = foldsigns.seps[foldlevel] or foldsigns.seps[#foldsigns.seps]
        end
      end
      return foldtext
    end
    require("statuscol").setup({
      setopt = true,
      segments = {
        {
          text = { "%s" },
          click = "v:lua.ScSa",
          condition = { builtin.not_empty },
        },
        {
          text = { foldcol, " " },
          click = "v:lua.FoldClick",
          fillchar = "x",
          colwidth = 1,
          maxwidth = 1,
          condition = { builtin.not_empty },
        },
        {
          text = { builtin.lnumfunc, " " },
          condition = { true, builtin.not_empty },
          click = "v:lua.ScLa",
        },
      },
    })
  end,
}
