local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  spec = {
    -- add LazyVim and import its plugins
    {
      'LazyVim/LazyVim',
      import = 'lazyvim.plugins',
      opts = {
        colorscheme = 'onedark_vivid',
      },
    },

    -- Disabling plugins
    { 'catppuccin', enabled = false },
    { 'folke/ts-comments.nvim', enabled = false },
    { 'nvim-mini/mini.ai', enabled = false },
    { 'nvim-mini/mini.icons', enabled = false },
    { 'nvim-mini/mini.pairs', enabled = false },
    { 'nvim-neo-tree/neo-tree.nvim', enabled = false },
    { 'nvim-treesitter/nvim-treesitter-textobjects', enabled = false },

    -- Adding extras
    { import = 'lazyvim.plugins.extras.linting.eslint' },

    { import = 'lazyvim.plugins.extras.formatting.prettier' },

    { import = 'lazyvim.plugins.extras.editor.fzf' },
    { import = 'lazyvim.plugins.extras.editor.harpoon2' },
    { import = 'lazyvim.plugins.extras.editor.refactoring' },

    { import = 'lazyvim.plugins.extras.lang.docker' },
    { import = 'lazyvim.plugins.extras.lang.go' },
    { import = 'lazyvim.plugins.extras.lang.helm' },
    { import = 'lazyvim.plugins.extras.lang.java' },
    { import = 'lazyvim.plugins.extras.lang.json' },
    { import = 'lazyvim.plugins.extras.lang.markdown' },
    { import = 'lazyvim.plugins.extras.lang.python' },
    { import = 'lazyvim.plugins.extras.lang.vue' },

    -- { import = 'lazyvim.plugins.extras.dap.core' },
    -- { import = 'lazyvim.plugins.extras.test.core' },

    { import = 'lazyvim.plugins.extras.ui.smear-cursor' },

    { import = 'lazyvim.plugins.extras.util.rest' },

    { import = 'lazyvim.plugins.extras.coding.blink' },
    { import = 'lazyvim.plugins.extras.coding.luasnip' },

    -- Adding my plugins
    { import = 'plugins' },
  },
  defaults = {
    lazy = true,
  },
  checker = {
    enabled = true,
  },
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        'gzip',
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
