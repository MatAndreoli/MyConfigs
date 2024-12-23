return { -- Collection of various small independent plugins/modules
  'echasnovski/mini.nvim',
  event = 'BufReadPre',
  config = function()
    -- i - Inside
    -- a - Arround
    -- w - Word
    -- a - Argument
    -- p - paragraph
    -- b - Brackets ({[]})
    -- q - Quotes

    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    --  - in/an - next
    --  - il/al - last
    --  - cina/cila - Arguments
    require('mini.ai').setup { n_lines = 500 }

    -- Better text editting operators
    --
    -- Examples:
    --  - gr            - Replace
    --  - gm            - Multiply/duplicate
    --  - gx            - Exchange
    --  - g=            - Evaluate
    --  - gs            - Sort
    --  - gx + ina/ila  - Move arguments
    require('mini.operators').setup()

    -- Add the closing pair to '|"|(|{|`
    require('mini.pairs').setup()

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    -- - srff  - [S]urround [Replace] [F]unction
    require('mini.surround').setup()

    require('mini.move').setup {
      mappings = {
        -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
        left = '<M-h>',
        right = '<M-l>',
        down = '<M-j>',
        up = '<M-k>',

        -- Move current line in Normal mode
        line_left = '<M-h>',
        line_right = '<M-l>',
        line_down = '<M-j>',
        line_up = '<M-k>',
      },
    }

    require('mini.icons').setup {
      lsp = { -- Icons stollen from lspkind.nvim
        text = { glyph = '󰉿' },
        method = { glyph = '󰆧' },
        ['function'] = { glyph = '󰊕' },
        constructor = { glyph = '' },
        field = { glyph = '󰜢' },
        variable = { glyph = '' },
        class = { glyph = '󰠱' },
        interface = { glyph = '' },
        module = { glyph = '' },
        property = { glyph = '󰜢' },
        unit = { glyph = '󰑭' },
        value = { glyph = '󰎠' },
        enum = { glyph = '' },
        keyword = { glyph = '󰌋' },
        snippet = { glyph = '' },
        color = { glyph = '󰏘' },
        file = { glyph = '󰈙' },
        reference = { glyph = '󰈇' },
        folder = { glyph = '󰉋' },
        enumMember = { glyph = '' },
        constant = { glyph = '󰏿' },
        struct = { glyph = '󰙅' },
        event = { glyph = '' },
        operator = { glyph = '󰆕' },
        typeParameter = { glyph = '' },
      },
    }
  end,
}
