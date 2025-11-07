return {
  {
    'mason-org/mason.nvim',
    event = 'VeryLazy',
    opts = {
      ui = {
        icons = {
          package_installed = '✓',
          package_pending = '➜',
          package_uninstalled = '✗',
        },
        border = 'rounded',
      },
    },
  },
  {
    'mason-org/mason-lspconfig.nvim',
    event = 'VeryLazy',
    opts = {
      ensure_installed = {
        'clangd',
        'cssls',
        'docker_compose_language_service',
        'dockerls',
        'eslint',
        'html',
        'jdtls',
        'jsonls',
        'lua_ls',
        'marksman',
        'nginx_language_server',
        'pyright',
        'ruff',
        'ts_ls',
        'vuels',
        'yamlls',
      },
    },
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    cmd = 'MasonToolsInstall',
    opts = {
      ensure_installed = {
        'black',
        'cpptools',
        'eslint_d',
        'google-java-format',
        'java-debug-adapter',
        'java-test',
        'jsonlint',
        'prettier',
        'pylint',
        'shfmt',
        'sonarlint-language-server',
        'stylua',
      },
      integrations = {
        ['mason-lspconfig'] = true,
      },
    },
  },
}
