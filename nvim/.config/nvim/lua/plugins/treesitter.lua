return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  version = false, -- last release is way too old and doesn't work on Windows
  build = function()
    local TS = require 'nvim-treesitter'
    if not TS.get_installed then
      LazyVim.error 'Please restart Neovim and run `:TSUpdate` to use the `nvim-treesitter` **main** branch.'
      return
    end
    LazyVim.treesitter.ensure_treesitter_cli(function()
      TS.update(nil, { summary = true })
    end)
  end,
  lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
  event = { 'LazyFile', 'VeryLazy' },
  cmd = { 'TSUpdate', 'TSInstall', 'TSLog', 'TSUninstall' },
  opts_extend = { 'ensure_installed' },
  ---@class lazyvim.TSConfig: TSConfig
  opts = {
    -- LazyVim config for treesitter
    indent = { enable = true },
    highlight = { enable = true },
    folds = { enable = true },
    ensure_installed = {
      'bash',
      'c',
      'css',
      'diff',
      'gitignore',
      'html',
      'java',
      'javascript',
      'jsdoc',
      'json',
      'jsonc',
      'lua',
      'luadoc',
      'luap',
      'markdown',
      'markdown_inline',
      'ninja',
      'printf',
      'python',
      'query',
      'regex',
      'rst',
      'toml',
      'tsx',
      'typescript',
      'vim',
      'vimdoc',
      'xml',
      'yaml',
    },
  },
  ---@param opts lazyvim.TSConfig
  config = function(_, opts)
    local TS = require 'nvim-treesitter'

    -- some quick sanity checks
    if not TS.get_installed then
      return LazyVim.error 'Please use `:Lazy` and update `nvim-treesitter`'
    elseif type(opts.ensure_installed) ~= 'table' then
      return LazyVim.error '`nvim-treesitter` opts.ensure_installed must be a table'
    end

    -- setup treesitter
    TS.setup(opts)
    LazyVim.treesitter.get_installed(true) -- initialize the installed langs

    -- install missing parsers
    local install = vim.tbl_filter(function(lang)
      return not LazyVim.treesitter.have(lang)
    end, opts.ensure_installed or {})
    if #install > 0 then
      LazyVim.treesitter.ensure_treesitter_cli(function()
        TS.install(install, { summary = true }):await(function()
          LazyVim.treesitter.get_installed(true) -- refresh the installed langs
        end)
      end)
    end

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('lazyvim_treesitter', { clear = true }),
      callback = function(ev)
        if not LazyVim.treesitter.have(ev.match) then
          return
        end

        -- highlighting
        if vim.tbl_get(opts, 'highlight', 'enable') ~= false then
          pcall(vim.treesitter.start)
        end

        -- indents
        if vim.tbl_get(opts, 'indent', 'enable') ~= false then
          vim.bo[ev.buf].indentexpr = 'v:lua.LazyVim.treesitter.indentexpr()'
        end

        -- folds
        if vim.tbl_get(opts, 'folds', 'enable') ~= false then
          vim.wo.foldmethod = 'expr'
          vim.wo.foldexpr = 'v:lua.LazyVim.treesitter.foldexpr()'
        end
      end,
    })
  end,
}
