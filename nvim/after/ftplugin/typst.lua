vim.keymap.set("n", "<leader>p", ":TypstPreview<CR>", { buffer = 0 })

vim.cmd([[
	setlocal wrapmargin=10
	setlocal formatoptions+=t
	setlocal linebreak
	"setlocal spell
	setlocal wrap
]])

local file = vim.fn.expand("%")
local out = vim.fn.expand("%:r")
vim.b.run_command = string.format("typst watch %s %s.pdf &> /dev/null & sioyek %s.pdf", file, out, out)
vim.b.undo_ftplugin = "unlet! b:run_command"
