vim.wo.spell = true
vim.opt_local.sidescroll = 0
vim.opt_local.sidescrolloff = 0

vim.b.ministatusline_disable = true
-- b4 edits cover letters as <repo>/.b4-editor*/COMMIT_EDITMSG, outside .git, which committia can't resolve
if vim.api.nvim_buf_get_name(0):find('/%.b4%-editor[^/]*/COMMIT_EDITMSG$') then vim.b.committia_opened = true end

vim.cmd('startinsert')
