return {
  'ibhagwan/fzf-lua',
  event = 'VeryLazy',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('fzf-lua').setup {
      winopts = {
        height = 0.9,
        width = 0.9,
        border = 'rounded',
        preview = {
          wrap = 'wrap',
        },
      },
      previewers = {
        builtin = {
          extensions = {
            ['png'] = { 'chafa', '{file}', '--format=symbols' },
            ['jpg'] = { 'chafa', '{file}', '--format=symbols' },
            ['jpeg'] = { 'chafa', '{file}', '--format=symbols' },
            ['gif'] = { 'chafa', '{file}', '--format=symbols' },
            ['webp'] = { 'chafa', '{file}', '--format=symbols' },
          },
        },
      },
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
    }
    local builtin = require 'fzf-lua'
    vim.keymap.set('n', '<leader>sh', builtin.helptags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', builtin.files, { desc = '[S]earch [F]iles fzf-lua' })
    vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect fzf-lua' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_cword, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics_document, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sD', builtin.diagnostics_workspace, { desc = '[S]earch [D]iagnostics in workspace' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
    vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = '[G]it [S]tatus' })
    vim.keymap.set('n', '<leader>gt', builtin.git_stash, { desc = '[G]it s[T]ash' })
    vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = '[G]it [C]ommits' })
    vim.keymap.set('n', '<leader>gh', builtin.git_bcommits, { desc = '[G]it Commits of current buffer' })
    vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = '[G]it [B]ranches' })
    vim.keymap.set('n', '<leader>/', builtin.blines, { desc = '[/] Fuzzily search in current buffer' })
    vim.keymap.set('n', '<leader>s/', builtin.lines, { desc = '[S]earch [/] in Open Files' })
  end,
}
