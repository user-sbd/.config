vim.b.run_command = "bash " .. vim.fn.expand("%")
vim.b.undo_ftplugin = "unlet! b:run_command"
