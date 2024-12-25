return {
  'akinsho/bufferline.nvim',
  dependencies = {
    'moll/vim-bbye',
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    options = {
      mode = 'buffers', -- set to "tabs" to only show tabpages instead
      themable = true, -- allows highlight groups to be overriden i.e. sets highlights as default
      separator_style = { '│', '│' }, -- | "thick" | "thin" | { 'any', 'any' },
      indicator = {
        icon = '⏽', -- this should be omitted if indicator style is not 'icon'
        style = 'icon', -- Options: 'icon', 'underline', 'none'
      },
      icon_pinned = '󰐃',
    },
  },
}
