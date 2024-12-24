return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    git = {
      icons = {
        ['M'] = { icon = '', color = 'yellow' },
        ['D'] = { icon = '', color = 'red' },
        ['A'] = { icon = '', color = 'green' },
        ['R'] = { icon = '󰑕', color = 'yellow' },
        ['C'] = { icon = '', color = 'yellow' },
        ['T'] = { icon = '', color = 'magenta' },
        ['?'] = { icon = '', color = 'magenta' },
      },
    },
  },
}
