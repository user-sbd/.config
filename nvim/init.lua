vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.pick" },
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
})


vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = os.getenv("HOME") .. "/.cache/undodir"
vim.o.undofile = true
vim.o.cmdheight = 2
vim.o.showmode = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 2
vim.g.mapleader = " "
vim.o.guicursor = ""

require("oil").setup({
	view_options = {
		show_hidden = true,
	},
})
require("mini.pick").setup({
	window = {
		prompt_caret = "█"
	}
})

local map = vim.keymap.set


map('t', '<Esc>', '<C-\\><C-n>')
map('n', '<leader><leader>', '<CMD>Pick files<CR>', { silent = true })
map('n', '<leader>fc', '<CMD>e $MYVIMRC<CR>', { silent = true })
map('n', '<leader>fh', '<CMD>Pick help<CR>', { silent = true })
map('n', '<leader>gl', '<CMD>Pick grep_live<CR>', { silent = true })
map('n', '<leader>tp', ':TypstPreview<CR>', { silent = true })
map('n', '<esc>', ':nohlsearch <CR>', { silent = true })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { silent = true })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { silent = true })
map('v', 'fj', '"+y', { silent = true })
map('n', '-', ':Oil<CR>', { silent = true })
map('n', '<leader>qf', '<CMD>copen<CR>', { silent = true })

-- custom colors
vim.cmd.colorscheme("vague")
vim.cmd(":hi statusline guibg=NONE")
vim.cmd("hi ModeMsg guifg=#cdcdcd")
vim.api.nvim_set_hl(0, 'MiniPickPrompt', { italic = false })
vim.api.nvim_set_hl(0, 'MiniPickBorderText', { fg = 'NONE' })
vim.api.nvim_set_hl(0, 'MiniPickBorderBusy', { fg = 'NONE' })
