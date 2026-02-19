local dir = vim.fn.expand("%:p:h")
if vim.fn.filereadable(dir .. "/Cargo.toml") == 1 then
  vim.b.run_command = "cargo run"
else
  local out = vim.fn.expand("%:r")
  vim.b.run_command = string.format("rustc %s && ./%s", vim.fn.expand("%"), out)
end
vim.b.undo_ftplugin = "unlet! b:run_command"
