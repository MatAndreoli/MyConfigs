return {
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
        { path = 'LazyVim', words = { 'LazyVim' } },
        -- { path = "snacks.nvim", words = { "Snacks" } },
        { path = 'lazy.nvim', words = { 'LazyVim' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },
  {

    'WhoIsSethDaniel/mason-tool-installer.nvim',
    event = 'VeryLazy',
    opts = {
      ensure_installed = {
        'black',
        'clangd',
        'cpptools',
        'cssls',
        'docker_compose_language_service',
        'dockerls',
        'eslint',
        'eslint_d',
        'google-java-format',
        'html',
        'java-debug-adapter',
        'java-test',
        'jdtls',
        'jsonls',
        'jsonlint',
        'lua_ls',
        'marksman',
        'nginx_language_server',
        'prettier',
        'pylint',
        'pyright',
        'pylsp',
        'ruff',
        'shfmt',
        'sonarlint-language-server',
        'stylua',
        'ts_ls',
        'yamlls',
      },
      integrations = {
        ['mason-lspconfig'] = true,
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    dependencies = {
      'saghen/blink.cmp',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'ray-x/lsp_signature.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'j-hui/fidget.nvim',
    },
    opts = {
      inlay_hints = { enabled = true },
      servers = {
        clangd = {},
        cssls = {},
        docker_compose_language_service = {},
        dockerls = {},
        eslint = {},
        html = {},
        jsonls = {},
        nginx_language_server = {},
        pylsp = {},
        ts_ls = {},
        yamlls = {},
        pyright = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      },
    },
    config = function(_, opts)
      require('mason').setup {
        ui = {
          icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗',
          },
          border = 'rounded',
        },
      }

      require('mason-lspconfig').setup {
        ensure_installed = { 'lua_ls', 'jdtls', 'cssls' },
        run_on_start = true,
        start_delay = 1000,
      }

      local ensure_installed = vim.tbl_keys(opts.servers or {})
      vim.list_extend(ensure_installed, {
        'stylua',
        'black',
        'eslint_d',
        'jsonlint',
        'pylint',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('lsp_signature').setup {
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
      }
      require('fidget').setup {}

      for server, config in pairs(opts.servers) do
        -- Skip jdtls as it's handled separately
        if server ~= 'jdtls' then
          -- Merge capabilities using blink.cmp's recommended approach
          config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
          if server ~= 'ruff_lsp' then
            require('lspconfig')[server].setup(config)
          end
        end
      end

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          local fzf_lua_builtin = require 'fzf-lua'
          map('gd', fzf_lua_builtin.lsp_definitions, '[G]oto [D]efinition')

          -- Find references for the word under your cursor.
          map('gr', fzf_lua_builtin.lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', fzf_lua_builtin.lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('<leader>D', fzf_lua_builtin.lsp_typedefs, 'Type [D]efinition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>ds', fzf_lua_builtin.lsp_document_symbols, '[D]ocument [S]ymbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('<leader>ws', fzf_lua_builtin.lsp_workspace_symbols, '[W]orkspace [S]ymbols')

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      if vim.g.have_nerd_font then
        local signs = { ERROR = '', WARN = '', INFO = '', HINT = '' }
        local diagnostic_signs = {}
        for type, icon in pairs(signs) do
          diagnostic_signs[vim.diagnostic.severity[type]] = icon
        end
        vim.diagnostic.config { signs = { text = diagnostic_signs } }
      end

      local open_floating_preview = vim.lsp.util.open_floating_preview
      function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or 'rounded' -- Set border to rounded
        return open_floating_preview(contents, syntax, opts, ...)
      end
    end,
  },
}
