local miniclue = require('mini.clue')
miniclue.setup({
  triggers = {
    { mode = { 'n', 'x' }, keys = '<Leader>' }, -- Leader triggers
    { mode = 'i', keys = '<C-x>' }, -- Built-in completion
    { mode = { 'n', 'x' }, keys = 'g' }, -- `g` key
    { mode = { 'n', 'x' }, keys = "'" }, -- Marks
    { mode = { 'n', 'x' }, keys = '`' },
    { mode = { 'n', 'x' }, keys = '"' }, -- Registers
    { mode = { 'i', 'c' }, keys = '<C-r>' },
    { mode = 'n', keys = '<C-w>' }, -- Window commands
    { mode = { 'n', 'x' }, keys = 'z' }, -- `z` key
    { mode = { 'n', 'x' }, keys = 's' }, -- mini.surround
    { mode = 'n', keys = '\\' }, -- mini.basics
    { mode = { 'n', 'x' }, keys = '[' }, -- mini.bracketed
    { mode = { 'n', 'x' }, keys = ']' },
  },
  clues = {
    { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
    { mode = 'n', keys = '<leader>f', desc = '+Find' },
    { mode = 'n', keys = '<Leader>g', desc = '+Git' },
    { mode = 'n', keys = '<leader>l', desc = '+LSP' },
    { mode = 'n', keys = '<leader>t', desc = '+Toggle' },
    { mode = 'x', keys = '<Leader>g', desc = '+Git' },
    { mode = 'x', keys = '<Leader>l', desc = '+LSP' },
    { mode = 'n', keys = ']b', postkeys = ']' },
    { mode = 'n', keys = ']w', postkeys = ']' },
    { mode = 'n', keys = '[b', postkeys = '[' },
    { mode = 'n', keys = '[w', postkeys = '[' },
    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows({ submode_resize = true }),
    miniclue.gen_clues.z(),
  },
  window = {
    delay = 0,
    config = {
      width = 'auto',
    },
  },
})
