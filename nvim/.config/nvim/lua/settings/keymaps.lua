-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<C-a>', ':qa!<CR>', { desc = 'Quit all (without savin "!")' })
vim.keymap.set('n', '<C-x>', ':wqa<CR>', { desc = 'Quit all' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Custom keymaps

vim.keymap.set('n', '<leader>tt', function()
  vim.cmd 'botright split | terminal'
  vim.cmd 'startinsert'
end, { desc = 'Open [T]erminal at the bottom' })

vim.keymap.set('t', '<C-t>', '<C-\\><C-n>:q<CR>', { desc = 'Close terminal split' })

vim.keymap.set('v', '>', '>gv', { desc = 'Indent and keep selection' })
vim.keymap.set('v', '<', '<gv', { desc = 'Unindent and keep selection' })

vim.keymap.set('n', '<C-s>', ':w<CR>', { desc = '[S]ave current buffer' })

vim.keymap.set('n', 'n', 'nzt')

vim.keymap.set('n', '<leader>to', ':tabnew<CR>', { desc = '[T]ab [O]pen' })
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', { desc = '[T]ab close' })
-- vim.keymap.set('n', '<leader>tn', ':tabn<CR>', { desc = '[T]ab [N]ext' })
-- vim.keymap.set('n', '<leader>tp', ':tabp<CR>', { desc = '[T]ab [P]revious' })

vim.keymap.set('v', 'p', '"_dP')

vim.keymap.set('n', '<Up>', ':resize -2<CR>')
vim.keymap.set('n', '<Down>', ':resize +2<CR>')
vim.keymap.set('n', '<Left>', ':vertical resize -2<CR>')
vim.keymap.set('n', '<Right>', ':vertical resize +2<CR>')

vim.keymap.set('n', '<leader>wv', '<C-w>v', { desc = 'Split window [V]ertically' })
vim.keymap.set('n', '<leader>wh', '<C-w>s', { desc = 'Split window [H]orizontally' })
vim.keymap.set('n', '<leader>se', '<C-w>=', { desc = 'Make windows [S]ize [E]qually' })
vim.keymap.set('n', '<leader>xs', ':close<CR>', { desc = 'Close current split window' })

vim.keymap.set('n', '<Tab>', ':bnext<CR>', { desc = 'Go to next buffer' })
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', { desc = 'Go to previous buffer' })
vim.keymap.set('n', '<leader>x', ':Bdelete!<CR>', { desc = 'Close current buffer' })

vim.keymap.set('n', '<C-M-j>', ':cnext<CR>')
vim.keymap.set('n', '<C-M-k>', ':cprevious<CR>')

vim.keymap.set('n', '<leader>ch', vim.lsp.buf.hover, { desc = '[C]ode [H]over Documentation' })
