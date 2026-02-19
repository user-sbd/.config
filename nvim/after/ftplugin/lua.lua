vim.b.run_command = "lua " .. vim.fn.expand("%")
vim.b.undo_ftplugin = "unlet! b:run_command"
