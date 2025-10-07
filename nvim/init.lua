vim.cmd([[set mouse=]])
vim.cmd([[set noswapfile]])
vim.o.winborder = "rounded"
vim.o.tabstop = 2
vim.o.wrap = true
vim.o.ignorecase = true
vim.o.shiftwidth = 2
vim.o.smartindent = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.termguicolors = true
vim.o.guicursor = ""
vim.o.undofile = true
vim.o.signcolumn = 'yes:1'
vim.guicursor = ""

vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = 'https://github.com/neovim/nvim-lspconfig' },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
})

require("mini.pick").setup({
	window = {
		prompt_caret = "█"
	}
})
require "mason".setup()
require("oil").setup({
	view_options = {
		show_hidden = true,
	},
})
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"svelte",
		"tinymist",
		"gopls",
		"emmet_ls",
		"rust_analyzer",
		"clangd",
		"bashls",
		"ruff",
		"glsl_analyzer",
		"marksman"
	},
	automatic_enable = true,
})

local map = vim.keymap.set
vim.g.mapleader = " "
map('n', '<leader>v', ':e $MYVIMRC<CR>')
map('n', '<leader>z', ':e ~/.zshrc<CR>')
map({ 'n', 'v' }, '<leader>n', ':norm ')
map({ "x", "n" }, "<C-s>", [[<esc>:'<,'>s/\V/]],
	{ desc = "Enter substitue mode in selection" })
map('n', '<C-f>', '<Cmd>Open %<CR>')
map('n', '<leader>fj', ":Pick files<CR>", { silent = true })
map('n', '<leader>sh', ":Pick help<CR>", { silent = true })
map('n', '<leader>cb', ":Pick buffers<CR>", { silent = true })
map('n', '-', ":Oil<CR>", { silent = true })
map('n', '<esc>', ':nohlsearch <CR>', { silent = true })
map('n', '<leader>tp', ':TypstPreview<CR>', { silent = true })
map({ 'v', 'n' }, 'fj', '"+y', { silent = true })
map("n", "<leader>cd", "<Cmd>cd %:p:h<CR>", { silent = true })


map(
	"n",
	"<leader>rp",
	function()
		local current_word = vim.fn.expand("<cword>")
		vim.ui.input({ prompt = "change '" .. current_word .. "' to > " }, function(input)
			if input and input ~= "" then
				vim.cmd("%s/\\<" .. current_word .. "\\>/" .. input .. "/gI")
			end
		end)
	end,
	{ silent = false }
)

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method('textDocument/completion') then
			local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
			client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,
})

map('n', '<leader>lf', vim.lsp.buf.format)
vim.cmd [[set completeopt+=menuone,noselect,popup]]

require "vague".setup({ transparent = true })
vim.cmd("colorscheme vague")
vim.cmd(":hi statusline guibg=NONE")
vim.cmd(":hi statusline guifg=white")
vim.cmd(":hi ModeMsg guifg=#cdcdcd")
vim.api.nvim_set_hl(0, 'MiniPickPrompt', { italic = false })
vim.api.nvim_set_hl(0, 'MiniPickBorderText', { fg = 'NONE' })
vim.api.nvim_set_hl(0, 'MiniPickBorderBusy', { fg = 'NONE' })

map("n", "<C-q>", ":copen<CR>", { silent = true })
for i = 1, 9 do
	map('n', '<leader>' .. i, ':cc ' .. i .. '<CR>', { noremap = true, silent = true })
end
map("n", "<leader>a",
	function() vim.fn.setqflist({ { filename = vim.fn.expand("%"), lnum = 1, col = 1, text = vim.fn.expand("%"), } }, "a") end,
	{ desc = "Add current file to QuickFix" })

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

vim.api.nvim_create_autocmd("FileType", { pattern = "typst", callback = function() map("n", "<leader>m", ":make<CR>:lua vim.fn.jobstart('zathura ' .. vim.fn.expand('%:r') .. '.pdf &')<CR><CR>", { noremap = true, buffer = true }) end })

vim.keymap.set("n", "<leader>m", ":make<CR>", { noremap = true, silent = true })
vim.cmd("filetype plugin on")
