return {
  'saghen/blink.cmp',
  opts = {
    snippets = {
      preset = 'luasnip',
    },
    sources = {
      default = { 'markdown' },
      providers = {
        markdown = { name = 'RenderMarkdown', module = 'render-markdown.integ.blink' },
      },
    },
    completion = {
      keyword = { range = 'prefix' },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = {
          border = {
            { '󱐋', 'WarningMsg' },
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
      menu = {
        max_height = 100,
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
        draw = {
          columns = {
            { 'label', 'label_description', gap = 1 },
            { 'kind_icon', 'kind', gap = 1 },
          },
          components = {
            kind_icon = {
              ellipsis = false,
              text = function(ctx)
                local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                return kind_icon
              end,
              highlight = function(ctx)
                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                return hl
              end,
            },
          },
        },
      },
      ghost_text = { enabled = false },
    },
  },
}
