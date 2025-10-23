vim.cmd([[set mouse=]])
vim.cmd([[set noswapfile]])
vim.o.winborder = "rounded"
vim.o.winbar = ""
vim.o.tabstop = 2
vim.o.ignorecase = true
vim.o.shiftwidth = 2
vim.o.smartindent = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.termguicolors = true
vim.o.guicursor = ""
vim.o.undofile = true
vim.o.signcolumn = 'yes:1'
vim.o.wrap = false

vim.pack.add({
	{ src = "https://github.com/bluz71/vim-moonfly-colors" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	-- PREVIEWS
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
})

require("fzf-lua").setup({
	winopts = {
		height = 1, width = 1,
		row = 0, col = 0,
		border = "rounded",
		title_pos = 'right',
		fullscreen = true
	},
	fzf_colors = {
  	fzf_colors = true,
  },
	preview = {
		hidden = true,
	},
	file_icon_padding = "",
	previewers = {
		bat = true,
	},
	files = {
		prompt = "> ",
		previewer = false,
	},
	oldfiles = {
		prompt = "> ",
		previewer = false,
	},
	buffers = {
		prompt = "> ",
		previewer = false,
	},
	quickfix = {
		prompt = "> ",
	},
	loclist = {
		prompt = "> ",
	},
	grep = {
		prompt = "> ",
		input_prompt = "> ",
	},
	live_grep = {
		prompt = "> ",
		input_prompt = "> ",
	},
	tags = {
		prompt = "> ",
	},
	colorschemes = {
		prompt = "> ",
		previewer = false,
		live_preview = true,
	},
})

require("oil").setup({
	view_options = {
		show_hidden = true,
	},
})

vim.cmd("colorscheme moonfly")

local map = vim.keymap.set
vim.g.mapleader = " "

map('n', '<leader>v', ':e $MYVIMRC<CR>')
map('n', '<leader>z', ':e ~/.zshrc<CR>')
map({ 'v', 'x', 'n' }, '<C-y>', '"+y', { desc = 'System clipboard yank.' })
map({ 'n', 'v' }, '<leader>n', ':norm ')
map({ 'x', 'n' }, '<C-s>', [[<esc>:'<,'>s/\V/]])
map('n', '<leader>fj', ':FzfLua files<CR>', { silent = true })
map('n', '<leader>sh', ':FzfLua helptags<CR>', { silent = true })
map('n', '<leader>gs', ':FzfLua live_grep<CR>', { silent = true })
map('n', '<leader>fb', ':FzfLua buffers<CR>', { silent = true })
map('n', '<leader>gc', ':FzfLua git_commits<CR>', { silent = true })
map('n', '<leader>fb', ':FzfLua git_bcommits<CR>', { silent = true })
map('n', '<leader>cs', ':FzfLua colorschemes<CR>', { silent = true })
map('n', '<leader>gs', ':FzfLua git_status<CR>', { silent = true })
map('n', '<leader>cf', ':FzfLua files cwd=~/.config<CR>', { silent = true })
map('n', '-', ':Oil<CR>', { silent = true })
map('n', '<esc>', ':nohlsearch <CR>', { silent = true })
map('n', '<leader>p', ':TypstPreview<CR>', { silent = true })
map('n', '<leader>cd', '<Cmd>cd %:p:h<CR>', { silent = true })

vim.cmd(":hi statusline guibg=NONE")
vim.cmd(":hi statusline guifg=white")
vim.cmd(":hi ModeMsg guifg=#cdcdcd")

map("n", "<C-q>", ":copen<CR>", { silent = true })
	for i = 1, 9 do
	map('n', '<leader>' .. i, ':cc ' .. i .. '<CR>', { noremap = true, silent = true })
end

map("n", "<leader>a", function()
	vim.fn.setqflist({ { filename = vim.fn.expand("%"), lnum = 1, col = 1, text = vim.fn.expand("%") }, }, "a")
end)

vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*",
	group = vim.api.nvim_create_augroup("qf", { clear = true }),
	callback = function()
		if vim.bo.buftype == "quickfix" then
			map("n", "<C-q>", ":ccl<cr>", { buffer = true, silent = true })
			map("n", "dd", function()
				local idx = vim.fn.line('.')
				local qflist = vim.fn.getqflist()
				table.remove(qflist, idx)
				vim.fn.setqflist(qflist, 'r')
			end, { buffer = true })
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "typst",
	callback = function()
		map("n", "<leader>m",
			":make<CR>:lua vim.fn.jobstart('zathura ' .. vim.fn.expand('%:r') .. '.pdf &')<CR><CR>",
			{ noremap = true, buffer = true })
	end,
})

map("n", "<leader>m", ":make<CR>", { noremap = true, silent = true })
