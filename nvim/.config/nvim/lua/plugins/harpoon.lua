return {
  'ThePrimeagen/harpoon',
  keys = function()
    local harpoon = require 'harpoon'
    local keys = {
      {
        '<leader>a',
        function()
          harpoon:list():add()
        end,
        desc = 'Harpoon Add File',
      },
      {
        '<C-e>',
        function()
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = 'Harpoon Quick Menu',
      },
      {
        '<leader>h1',
        function()
          harpoon:list():select(1)
        end,
        desc = 'Harpoon File 1',
      },
      {
        '<leader>h2',
        function()
          harpoon:list():select(2)
        end,
        desc = 'Harpoon File 2',
      },
      {
        '<leader>h3',
        function()
          harpoon:list():select(3)
        end,
        desc = 'Harpoon File 3',
      },
      {
        '<leader>h4',
        function()
          harpoon:list():select(4)
        end,
        desc = 'Harpoon File 4',
      },
      {
        '<leader>p',
        function()
          harpoon:list():prev()
        end,
        desc = 'Harpoon Prev File',
      },
      {
        '<leader>P',
        function()
          harpoon:list():next()
        end,
        desc = 'Harpoon Next File',
      },
    }
    return keys
  end,
}
