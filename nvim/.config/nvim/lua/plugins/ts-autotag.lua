return {
  'windwp/nvim-ts-autotag',
  event = 'BufReadPre',
  config = function()
    require('nvim-ts-autotag').setup {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false,
      },
    }
  end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
}
