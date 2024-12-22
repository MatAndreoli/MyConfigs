return { -- Autocompletion
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    {
      'L3MON4D3/LuaSnip',
      build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      dependencies = {
        -- `friendly-snippets` contains a variety of premade snippets.
        --    See the README about individual language/framework/plugin snippets:
        --    https://github.com/rafamadriz/friendly-snippets
        {
          'rafamadriz/friendly-snippets',
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
          end,
        },
      },
    },
    'saadparwaiz1/cmp_luasnip',

    -- Adds other completion capabilities.
    --  nvim-cmp does not ship with all sources by default. They are split
    --  into multiple repos for maintenance purposes.
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
  },
  config = function()
    -- See `:help cmp`
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    luasnip.config.setup {}

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
        completion = {
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
        documentation = {
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
      formatting = {
        fields = { 'abbr', 'kind' }, -- Name | icon
        format = function(_, item) -- lspkind behaviour with mini.icons and nvim-highlight-colors (add cute little icons and css colors)
          local color_item = require('nvim-highlight-colors').format(entry, { kind = item.kind })
          item.kind, item.kind_hl_group = require('mini.icons').get('lsp', item.kind) .. ' '
          if color_item.abbr_hl_group then
            item.kind_hl_group = color_item.abbr_hl_group
            item.kind = color_item.abbr
          end
          return item
        end,
      },
      performance = { -- Trying to improve performance
        debounce = 6,
        throttle = 10,
        fetching_timeout = 200,
        confirm_resolve_timeout = 60,
        async_budget = 1,
        max_view_entries = 200,
      },
      completion = { completeopt = 'menu,menuone,noinsert' },

      -- For an understanding of why these mappings were
      -- chosen, you will need to read `:help ins-completion`
      --
      -- No, but seriously. Please read `:help ins-completion`, it is really good!
      mapping = cmp.mapping.preset.insert {
        -- Select the [n]ext item
        ['<C-n>'] = cmp.mapping.select_next_item(),
        -- Select the [p]revious item
        ['<C-p>'] = cmp.mapping.select_prev_item(),

        -- Scroll the documentation window [b]ack / [f]orward
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),

        -- Accept ([y]es) the completion.
        --  This will auto-import if your LSP supports it.
        --  This will expand snippets if the LSP sent a snippet.
        --['<C-y>'] = cmp.mapping.confirm { select = true },

        -- If you prefer more traditional completion keymaps,
        -- you can uncomment the following lines
        ['<CR>'] = cmp.mapping.confirm { select = true },
        -- ['<Tab>'] = cmp.mapping.select_next_item(),
        -- ['<S-Tab>'] = cmp.mapping.select_prev_item(),

        -- Manually trigger a completion from nvim-cmp.
        --  Generally you don't need this, because nvim-cmp will display
        --  completions whenever it has completion options available.
        ['<C-Space>'] = cmp.mapping.complete {},

        -- Think of <c-l> as moving to the right of your snippet expansion.
        --  So if you have a snippet that's like:
        --  function $name($args)
        --    $body
        --  end
        --
        -- <c-l> will move you to the right of each of the expansion locations.
        -- <c-h> is similar, except moving you backwards.
        ['<C-l>'] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { 'i', 's' }),
        ['<C-h>'] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { 'i', 's' }),

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },
      sources = {
        {
          name = 'lazydev',
          -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
          group_index = 0,
        },
        { name = 'luasnip' },
        { name = 'path' },
        { name = 'snippets', priority = 11 }, -- Custom snippets
        { name = 'lazydev', group_index = 0, priority = 10 }, -- Improved lua_ls
        { name = 'nvim_lua', priority = 9 }, -- Nvim lua api
        { name = 'nvim_lsp', priority = 8 }, -- LSP
        { name = 'buffer', priority = 7 }, -- Text within current buffer
        { name = 'async_path', priority = 7 }, -- Path
      },
    }
  end,
}
