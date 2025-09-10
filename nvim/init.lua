vim.cmd([[set mouse=]])
vim.cmd([[set noswapfile]])
vim.o.winborder = "rounded"
vim.o.tabstop = 2
vim.o.wrap = false
vim.o.cursorcolumn = false
vim.o.ignorecase = true
vim.guicursor = ""
vim.o.shiftwidth = 2
vim.o.smartindent = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.termguicolors = true
vim.o.guicursor = ""
vim.o.undofile = true
vim.o.signcolumn = 'yes'

local map = vim.keymap.set
vim.g.mapleader = " "
map('n', '<leader>v', ':e $MYVIMRC<CR>')
map('n', '<leader>z', ':e ~/.zshrc<CR>')
map({ 'n', 'v' }, '<leader>n', ':norm ')
map({ 'n', 'v' }, '<leader>c', '1z=')

vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = 'https://github.com/neovim/nvim-lspconfig' },
	{ src = "https://github.com/mason-org/mason.nvim" },
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
	keymaps = {
		["gd"] = {
			desc = "Toggle file detail view",
			callback = function()
				detail = not detail
				if detail then
					require("oil").set_columns({ "icon", "size", "mtime" })
				else
					require("oil").set_columns({ "icon" })
				end
			end,
		},
	},

})

map('n', '<leader><leader>', ":Pick files<CR>")
map('n', '<leader>ff', ":Pick files<CR>")
map('n', '<leader>fh', ":Pick help<CR>")
map('n', '<leader>tp', ':TypstPreview<CR>', { silent = true })
map('n', '<esc>', ':nohlsearch <CR>', { silent = true })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { silent = true })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { silent = true })
map('v', 'fj', '"+y', { silent = true })
map('n', '-', ":Oil<CR>")

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

vim.lsp.enable(
	{
		"lua_ls",
		"svelte",
		"tinymist",
		"gopls",
		"emmetls",
		"rust_analyzer",
		"clangd",
		"bash-langauge-server",
		"ruff",
		"glsl_analyzer"
	}
)

require "vague".setup({ transparent = true })
vim.cmd("colorscheme vague")
vim.cmd(":hi statusline guibg=NONE")
vim.cmd(":hi ModeMsg guifg=#cdcdcd")
vim.api.nvim_set_hl(0, 'MiniPickPrompt', { italic = false })
vim.api.nvim_set_hl(0, 'MiniPickBorderText', { fg = 'NONE' })
vim.api.nvim_set_hl(0, 'MiniPickBorderBusy', { fg = 'NONE' })
