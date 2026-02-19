local file = vim.fn.expand("%")
local out = vim.fn.expand("%:r")
vim.b.run_command = string.format("kotlinc %s -include-runtime -d %s.jar && java -jar %s.jar", file, out, out)
vim.b.undo_ftplugin = "unlet! b:run_command"
