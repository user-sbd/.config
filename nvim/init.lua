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
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/bluz71/vim-moonfly-colors" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },

	-- LSP CONFIG
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },

	-- PREVIEWS
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/barrett-ruth/live-server.nvim" },
	{ src = "https://github.com/SylvanFranklin/omni-preview.nvim" },
	{ src = "https://github.com/toppair/peek.nvim" },
})

require("luasnip").setup({ enable_autosnippets = true })
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })
local ls = require("luasnip")

require 'omni-preview'.setup({})
require 'live-server'.setup({})
require 'peek'.setup({ app = "browser" })

require("mini.pick").setup({
	window = {
		prompt_caret = "█",
		config = {
			height = "120",
			width = "120"
		}
	},
	mappings = {
		choose_in_vsplit = '<C-x>'
	}
})

require("mason").setup()
require("oil").setup({
	view_options = {
		show_hidden = true,
	},
})

vim.cmd("colorscheme moonfly")
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#000000', fg = '#ffffff' })
vim.api.nvim_set_hl(0, 'FloatBorder', { fg = '#5f5f5f' })
vim.api.nvim_set_hl(0, 'PmenuSel', { bg = '#3a3a3a', fg = '#ffffff' })

require("mason-lspconfig").setup({
	ensure_installed = {
		"bashls", "clangd", "emmet_ls", "glsl_analyzer", "gopls", "html",
		"lua_ls", "marksman", "ruff", "rust_analyzer", "svelte", "tailwindcss",
		"tinymist",
	},
	automatic_installation = true,
	automatic_enable = true,
})

local map = vim.keymap.set
vim.g.mapleader = " "

map({ "n", "v", "x" }, "<leader>lf", vim.lsp.buf.format, { desc = "Format current buffer" })
map('n', '<leader>v', ':e $MYVIMRC<CR>')
map({ "v", "x", "n" }, "<C-y>", '"+y', { desc = "System clipboard yank." })
map({ "i", "s" }, "<C-e>", function() ls.expand_or_jump(1) end, { silent = true })
map('n', '<leader>z', ':e ~/.zshrc<CR>')
map({ 'n', 'v' }, '<leader>n', ':norm ')
map({ "x", "n" }, "<C-s>", [[<esc>:'<,'>s/\V/]], { desc = "Enter substitue mode in selection" })
map('n', '<leader>dj', ":Pick files tool='git'<CR>", { silent = true })
map('n', '<leader>fj', ":Pick files<CR>", { silent = true })
map('n', '<leader>sh', ":Pick help<CR>", { silent = true })
map('n', '<leader>rg', ":Pick grep_live<CR>", { silent = true })
map('n', '-', ":Oil<CR>", { silent = true })
map('n', '<esc>', ':nohlsearch <CR>', { silent = true })
map('n', '<leader>p', ':OmniPreview start<CR>', { silent = true })
map("n", "<leader>cd", "<Cmd>cd %:p:h<CR>", { silent = true })

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

vim.cmd [[set completeopt=menu,menuone,noselect]]
vim.cmd(":hi statusline guibg=NONE")
vim.cmd(":hi statusline guifg=white")
vim.cmd(":hi ModeMsg guifg=#cdcdcd")

vim.api.nvim_set_hl(0, 'MiniPickPrompt', { italic = false })
vim.api.nvim_set_hl(0, 'MiniPickBorderText', { fg = 'NONE' })
vim.api.nvim_set_hl(0, 'MiniPickBorderBusy', { fg = 'NONE' })
vim.api.nvim_set_hl(0, 'MiniPickNormal', { bg = '#080808' })

map("n", "<C-q>", ":copen<CR>", { silent = true })
for i = 1, 9 do
	map('n', '<leader>' .. i, ':cc ' .. i .. '<CR>', { noremap = true, silent = true })
end

map("n", "<leader>a", function()
	vim.fn.setqflist({ { filename = vim.fn.expand("%"), lnum = 1, col = 1, text = vim.fn.expand("%") }, }, "a")
end, { desc = "Add current file to QuickFix" })

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
