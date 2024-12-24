return {
  'ray-x/lsp_signature.nvim',
  event = 'LazyFile',
  opts = {
    bind = true,
    handler_opts = {
      border = {
        { '󰙎', 'DiagnosticHint' },
        { '─', 'Comment' },
        { '╮', 'Comment' },
        { '│', 'Comment' },
        { '╯', 'Comment' },
        { '─', 'Comment' },
        { '╰', 'Comment' },
        { '│', 'Comment' },
      },
    },
  },
}
