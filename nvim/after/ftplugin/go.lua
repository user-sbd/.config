vim.b.run_command = "go run " .. vim.fn.expand("%")
vim.b.undo_ftplugin = "unlet! b:run_command"
