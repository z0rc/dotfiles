th.git = th.git or {}
th.git.modified_sign = '~'
th.git.deleted_sign = 'x'
th.git.added_sign = '+'
th.git.untracked_sign = '?'
th.git.ignored_sign = 'o'
th.git.updated_sign = '!'

require('git'):setup { order = 0 }

require("githead"):setup {
  branch_prefix = "",
  branch_symbol = "",
  branch_borders = "",
}
