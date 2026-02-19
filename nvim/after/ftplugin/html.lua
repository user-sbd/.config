vim.b.run_command = "open " .. vim.fn.expand("%")
vim.b.run_command = "start " .. vim.fn.expand("%")
vim.b.undo_ftplugin = "unlet! b:run_command"
