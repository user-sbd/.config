vim.b.run_command = "python3 " .. vim.fn.expand("%")
vim.b.undo_ftplugin = "unlet! b:run_command"
