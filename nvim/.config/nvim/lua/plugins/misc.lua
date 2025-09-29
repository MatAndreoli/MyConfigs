return {
  -- {
  --   'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  --   event = 'BufReadPre',
  -- },
  {
    'NvChad/nvim-colorizer.lua',
    event = 'BufReadPre',
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
        mode = 'foreground', -- Set the display mode.
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
  { --* Highlight colors and add color completions *--
    'brenoprata10/nvim-highlight-colors',
    event = 'BufReadPre',
    opts = {
      virtual_symbol_suffix = ' ',
      virtual_symbol_prefix = ' ',
      virtual_symbol_position = 'eow',
      virtual_symbol = '󱓻',
      render = 'virtual',
      enable_tailwind = true,
    },
  },
}
