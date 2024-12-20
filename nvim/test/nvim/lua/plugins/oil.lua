return {
  'stevearc/oil.nvim',
  opts = {
    watch_for_changes = true,
    keymaps = {
      ['<C-s>'] = false,
      ['<C-h>'] = false,
      ['<C-t>'] = false,
      ['<C-l>'] = false,
      ['<S-l>'] = 'actions.refresh',
    },
    view_options = {
      show_hidden = true,
      is_always_hidden = function(name, bufnr)
        local ignore_patterns = {
          '^node_modules$',
          '^%.git$',
          '^%.cache$',
          '^dist$',
          '^build$',
          '%.pyc$',
          '%.o$',
          '%.class$',
          '%.swp$',
          '^__pycache__',
        }

        for _, pattern in ipairs(ignore_patterns) do
          if name:match(pattern) then
            return true
          end
        end

        return false
      end,
    },
  },
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  vim.keymap.set('n', '_', ':lua require("oil").open_float(".")<CR>', { desc = 'Open parent directory' }),
  vim.keymap.set('n', '-', function()
    local current_file = vim.fn.expand '%:p'
    local parent_dir = vim.fn.fnamemodify(current_file, ':h')
    require('oil').open_float(parent_dir)
  end, { desc = 'Open parent directory' }),
}
