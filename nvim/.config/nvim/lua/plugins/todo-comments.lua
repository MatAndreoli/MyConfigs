return { -- Highlight todo, notes, etc in comments
  'folke/todo-comments.nvim',
  event = 'BufReadPost',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {
    signs = true,
  },
}
