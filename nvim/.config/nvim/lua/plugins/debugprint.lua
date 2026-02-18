return {
  'andrewferrier/debugprint.nvim',
  opts = {
    filetypes = {
      ['javascript'] = {
        left = 'console.log("',
        right = '")',
        mid_var = '", ',
        right_var = ')',
      },
      ['javascriptreact'] = {
        left = 'console.log("',
        right = '")',
        mid_var = '", ',
        right_var = ')',
      },
      ['typescript'] = {
        left = 'console.log("',
        right = '")',
        mid_var = '", ',
        right_var = ')',
      },
      ['typescriptreact'] = {
        left = 'console.log("',
        right = '")',
        mid_var = '", ',
        right_var = ')',
      },
    },
    keymaps = {
      normal = {
        plain_below = 'g?p',
        plain_above = 'g?P',
        variable_below = 'g?v',
        variable_above = 'g?V',
        variable_below_alwaysprompt = '',
        variable_above_alwaysprompt = '',
        surround_plain = 'g?sp',
        surround_variable = 'g?sv',
        surround_variable_alwaysprompt = '',
        textobj_below = 'g?o',
        textobj_above = 'g?O',
        textobj_surround = 'g?so',
        toggle_comment_debug_prints = 'g?c',
        delete_debug_prints = 'g?d',
      },
      insert = {
        plain = '<C-G>p',
        variable = '<C-G>v',
      },
      visual = {
        variable_below = 'g?v',
        variable_above = 'g?V',
      },
    },
    display_counter = false,
    print_tag = 'DEBUG',
    highlight_lines = false,
  },
  dependencies = {
    'nvim-mini/mini.nvim', -- Optional: Needed for line highlighting (full mini.nvim plugin)
    'ibhagwan/fzf-lua', -- Optional: If you want to use the `:Debugprint search` command with fzf-lua
  },
  lazy = false, -- Required to make line highlighting work before debugprint is first used
  version = '*', -- Remove if you DON'T want to use the stable version
}
