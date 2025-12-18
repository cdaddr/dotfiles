return {
  'norcalli/nvim-colorizer.lua',
  -- test #ff0000 #ff000099 DarkRed rgb(255, 0, 0) hsla(0, 100%, 50%, 0.5)
  config = function (_, opts)
    require'colorizer'.setup(nil, { css = true })
  end
}
