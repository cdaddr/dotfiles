return {
  'folke/flash.nvim',
  keys = {
    { "f", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "F", mode = { "n", "x", "o" }, function() require("flash").jump({continue = true}) end, desc = "Flash" },
    { "<F5>", mode = {"n", "x", "o"}, function ()
    require("flash").jump({
      pattern = ".", -- initialize pattern with any char
      search = {
        mode = function(pattern)
          -- remove leading dot
          if pattern:sub(1, 1) == "." then
            pattern = pattern:sub(2)
          end
          -- return word pattern and proper skip pattern
          return ([[\<%s\w*\>]]):format(pattern), ([[\<%s]]):format(pattern)
        end,
      },
      -- select the range
      jump = { pos = "range" },
    })
    end},
    -- { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
  config = function(_, opts)
    vim.api.nvim_set_hl(0, "FlashLabel", { fg = "#FF007C", bold = true })
    local search = vim.api.nvim_get_hl(0, { name = 'Search' })
    vim.api.nvim_set_hl(0, 'FlashMatch', vim.tbl_extend('force', search, { bg = 'none', underline = true }))
    local incsearch = vim.api.nvim_get_hl(0, { name = 'IncSearch' })
    vim.api.nvim_set_hl(0, 'FlashCurrent', vim.tbl_extend('force', incsearch, { underline = true, sp = incsearch.fg }))

    require('flash').setup(
      vim.tbl_deep_extend('force', opts, {
        labels = "qwertyuiopzxcvbnm",
        keys = { },
        jump = {
          -- pos = "range",
          -- autojump = true,
        },
        label = {
          -- after = {0, 2},
          -- current = false,
          rainbow = {
            enabled = false,
            -- number between 1 and 9
            shade = 1,
          },
          style = "inline",
          format = function(opts)
            return { { "[", opts.hl_group}, { opts.match.label, opts.hl_group }, { "]", opts.hl_group} }
          end
        },
        modes = {
          search = {
            enabled = false,
          },
          char = {
            enabled = false,
          },
        },
        -- char_actions = function(motion)
          --   return {}
          -- end
      }))
  end,
}
