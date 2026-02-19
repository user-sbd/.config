local file = vim.fn.expand("%")
local out = vim.fn.expand("%:r")
vim.b.run_command = string.format("gcc -Wall -Wextra %s -o %s && ./%s", file, out, out)
vim.b.undo_ftplugin = "unlet! b:run_command"
