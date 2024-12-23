return {
  'saghen/blink.cmp',
  event = 'VeryLazy',
  dependencies = {
    'rafamadriz/friendly-snippets',
    {
      'L3MON4D3/LuaSnip',
      version = 'v2.*',
      build = 'make install_jsregexp',
    },
  },
  version = '*',
  opts = {
    keymap = { preset = 'default' },
    snippets = {
      expand = function(snippet)
        require('luasnip').lsp_expand(snippet)
      end,
      active = function(filter)
        if filter and filter.direction then
          return require('luasnip').jumpable(filter.direction)
        end
        return require('luasnip').in_snippet()
      end,
      jump = function(direction)
        require('luasnip').jump(direction)
      end,
    },
    appearance = {
      nerd_font_variant = 'mono',
    },
    sources = {
      default = { 'lsp', 'path', 'luasnip', 'snippets', 'buffer', 'markdown' },
      -- completion = {
      --   enabled_providers = { 'lsp', 'path', 'snippets', 'buffer', 'markdown' },
      -- },
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
    },
  },
  opts_extend = { 'sources.default' },
}
