local dir = vim.fn.expand("%:p:h")
if vim.fn.filereadable(dir .. "/package.json") == 1 then
  vim.b.run_command = "npm run dev"
else
  vim.b.run_command = "echo 'No package.json found'"
end
vim.b.undo_ftplugin = "unlet! b:run_command"
