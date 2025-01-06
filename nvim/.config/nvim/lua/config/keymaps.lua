-- General
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<C-s>', ':w<CR>', { desc = '[S]ave current buffer', silent = true })
vim.keymap.set('n', '<leader><leader>x', ':so %<CR>', { desc = 'Source current buffer', silent = true })
vim.keymap.set('n', '<M-x>', ':.lua<CR>', { desc = 'Source current buffer', silent = true })
vim.keymap.set('v', '<M-x>', ':lua<CR>', { desc = 'Source current buffer', silent = true })

-- Editor
vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('n', '<leader>i', ':%s/\\<<C-r><C-w>\\>//g<Left><Left>', { desc = 'Substitute word under cursor occurrences', noremap = true })

-- Better navigation
vim.keymap.set('n', 'n', 'nzz', { noremap = true })
vim.keymap.set('n', 'N', 'Nzz', { noremap = true })
vim.keymap.set('n', '<C-d>', '<C-d>zt', { noremap = true })
vim.keymap.set('n', '<C-u>', '<C-u>zt', { noremap = true })
vim.keymap.set('n', 'J', "mzJ'z")

-- Window navigation (ldur)
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Window management
vim.keymap.set('n', '<leader>wv', '<C-w>v', { desc = 'Split window [V]ertically' })
vim.keymap.set('n', '<leader>wh', '<C-w>s', { desc = 'Split window [H]orizontally' })
vim.keymap.set('n', '<leader>se', '<C-w>=', { desc = 'Make windows [S]ize [E]qually' })
vim.keymap.set('n', '<leader>xs', ':close<CR>', { desc = 'Close current split window', silent = true })

-- Window resizing
vim.keymap.set('n', '<Up>', ':resize -2<CR>', { silent = true })
vim.keymap.set('n', '<Down>', ':resize +2<CR>', { silent = true })
vim.keymap.set('n', '<Left>', ':vertical resize -2<CR>', { silent = true })
vim.keymap.set('n', '<Right>', ':vertical resize +2<CR>', { silent = true })

-- Buffer management
vim.keymap.set('n', '<leader>x', ':Bdelete!<CR>', { desc = 'Close current buffer', silent = true })

-- Tab management
vim.keymap.set('n', '<leader>to', ':tabnew<CR>', { desc = '[T]ab [O]pen', silent = true })
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', { desc = '[T]ab close', silent = true })
-- vim.keymap.set('n', '<leader>tn', ':tabn<CR>', { desc = '[T]ab [N]ext' })
-- vim.keymap.set('n', '<leader>tp', ':tabp<CR>', { desc = '[T]ab [P]revious' })

-- Terminal
-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<leader>tt', function()
  vim.cmd 'botright split | terminal'
  vim.cmd 'startinsert'
end, { desc = 'Open [T]erminal at the bottom' })
vim.keymap.set('t', '<C-t>', '<C-\\><C-n>:q<CR>', { desc = 'Close terminal split' })

-- LSP and Diagnostics
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>ch', vim.lsp.buf.hover, { desc = '[C]ode [H]over Documentation' })
vim.keymap.set('n', '<M-f>', ':cnext<CR>', { silent = true })
vim.keymap.set('n', '<M-d>', ':cprevious<CR>', { silent = true })

-- Text manipulation
vim.keymap.set('v', '>', '>gv', { desc = 'Indent and keep selection' })
vim.keymap.set('v', '<', '<gv', { desc = 'Unindent and keep selection' })
vim.keymap.set('v', 'p', '"_dP')
vim.keymap.set({ 'n', 'v' }, 'd', '"_d')

-- Tmux navigator
vim.keymap.set('n', '<C-h>', ':TmuxNavigateLeft<CR>')
vim.keymap.set('n', '<C-j>', ':TmuxNavigateDown<CR>')
vim.keymap.set('n', '<C-k>', ':TmuxNavigateUp<CR>')
vim.keymap.set('n', '<C-l>', ':TmuxNavigateRightCR>')
