local file = vim.fn.expand("%")
local dir = vim.fn.expand("%:p:h")

local function is_flutter_project()
  return vim.fn.filereadable(dir .. "/pubspec.yaml") == 1
end

if is_flutter_project() then
  if file:match("main%.dart$") then
    vim.b.run_command = "flutter run -d iPhone"
  else
    vim.b.run_command = "dart analyze " .. file
  end
else
  vim.b.run_command = "dart run " .. file
end
vim.b.undo_ftplugin = "unlet! b:run_command"

vim.keymap.set('n', "<C-t>", "<CMD>FlutterLogToggle<CR><esc>")
