require('which-key').setup {
  icons = {
    rules = false,
    mappings = false,
    keys = {
      Up = '↑',
      Down = '↓',
      Left = '←',
      Right = '→',
      C = 'Ctrl',
      M = 'Alt',
      S = 'Shift',
      CR = '↵',
      Esc = 'Esc',
      BS = '⌫',
      Space = 'Space',
      Tab = '⇥',
      F1 = 'F1',
      F2 = 'F2',
      F3 = 'F3',
      F4 = 'F4',
      F5 = 'F5',
      F6 = 'F6',
      F7 = 'F7',
      F8 = 'F8',
      F9 = 'F9',
      F10 = 'F10',
      F11 = 'F11',
      F12 = 'F12',
    },
  },
}

require('which-key').add {
  { '<leader>t', group = '[t]oggle' },
  { '<leader>g', group = '[g]it',   mode = { 'n', 'v' } },
  { '<leader>s', group = '[s]earch' },
}
