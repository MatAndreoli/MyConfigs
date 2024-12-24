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
  keys = {
    -- Git
    { '<leader>gt', '<cmd>FzfLua git_stash<CR>', desc = 'Stash' },
    { '<leader>gC', '<cmd>FzfLua git_bcommits<CR>', desc = 'Commits of current buffer' },
    { '<leader>gn', '<cmd>FzfLua git_branches<CR>', desc = 'Branches' },

    -- Buffers
    { '<leader>/', '<cmd>FzfLua blines<CR>', desc = 'Fuzzily search in current buffer' },
    { '<leader>s/', '<cmd>FzfLua lines<CR>', desc = 'Fuzzily search in open buffers' },
  },
}
