return {
  'olimorris/onedarkpro.nvim',
  priority = 1000,
  opts = {
    styles = {
      types = 'bold',
      methods = 'bold',
      numbers = 'NONE',
      strings = 'NONE',
      comments = 'NONE',
      keywords = 'italic',
      constants = 'bold,italic',
      functions = 'bold',
      operators = 'bold',
      variables = 'NONE',
      parameters = 'italic',
      conditionals = 'italic',
      virtual_text = 'NONE',
    },
    options = {
      cursorline = false, -- Use cursorline highlighting?
      transparency = true, -- Use a transparent background?
      terminal_colors = true, -- Use the theme's colors for Neovim's :terminal?
      lualine_transparency = false, -- Center bar transparency?
      highlight_inactive_windows = false, -- When the window is out of focus, change the normal background?
    },
  },
}
