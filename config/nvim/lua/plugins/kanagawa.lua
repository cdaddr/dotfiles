return {
    "rebelot/kanagawa.nvim",
    lazy = false,
    prority = 1000,
    config = function()
      local colors = require("kanagawa.colors").setup({ theme = "wave" })
      local palette_colors = colors.palette
      require("kanagawa").setup({
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = palette_colors.sumiInk2,
              },
            },
          },
        },
        overrides = function(colors)
          local theme = colors.theme
          local palette = require("kanagawa.colors").setup({ theme = "wave" }).palette

          return {
            NormalFloat = { bg = "none" },
            FloatBorder = { bg = "none" },
            FloatTitle = { bg = "none" },
            Visual = { bold = true },

            -- Save an hlgroup with dark background and dimmed foreground
            -- so that you can use it where your still want darker windows.
            -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

            -- Popular plugins that open floats will link to NormalFloat by default;
            -- set their background accordingly if you wish to keep them dark and borderless
            LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
          }
        end,
      })
    end,
  }
