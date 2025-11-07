return {
  'mistweaverco/kulala.nvim',
  commit = '0d50e9ce5c992fe507743d8641b36125e668aad4',
  keys = {
    { '<leader>Rs', desc = 'Send request' },
    { '<leader>Ra', desc = 'Send all requests' },
    { '<leader>Rb', desc = 'Open scratchpad' },
  },
  ft = { 'http', 'rest' },
  opts = {
    ui = {
      show_variable_info_text = 'float',
      show_icons = 'signcolumn',
    },
    global_keymaps = {},
    global_keymaps_prefix = '<leader>R',
    kulala_keymaps_prefix = '',
  },
}
