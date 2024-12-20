return {
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  {
    'NvChad/nvim-colorizer.lua',
    opts = {
      user_default_options = {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = true, -- "Name" codes like Blue
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = false, -- CSS hsl() and hsla() functions
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Available modes: foreground, background
        mode = 'background', -- Set the display mode.
      },
    },
  },
  {
    'max397574/colortils.nvim',
    cmd = 'Colortils',
    config = function()
      require('colortils').setup()
    end,
  },
}
