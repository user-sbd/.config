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
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master" },
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

require("fzf-lua").setup({
	fzf_colors = true,
	winopts = {
		height = 1, width = 1,
		row = 0, col = 0,
		border = "single", title = false,
		title_pos = "", fullscreen = true,
		preview = { vertical = "right:45%" },
	},
	file_icon_padding = "", previewers = { bat = true, },
	files = { prompt = "> ", }, oldfiles = { prompt = "> ", },
})

require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })
require("luasnip").setup({ enable_autosnippets = true })
require('omni-preview').setup({})
require('live-server').setup({})
require('peek').setup({ app = "browser" })
require("mason").setup()
require("oil").setup({ view_options = { show_hidden = true, }, })

local ls = require("luasnip")
vim.cmd("colorscheme vague")

require("mason-lspconfig").setup({
	ensure_installed = {
		"bashls", "clangd", "emmet_ls", "glsl_analyzer", "gopls", "html",
		"lua_ls", "marksman", "ruff", "rust_analyzer", "svelte", "tailwindcss", "tinymist", "jsonls",
	},
	automatic_installation = true,
	automatic_enable = true,
})

vim.g.mapleader = " "
local map = vim.keymap.set

map({ 'n', 'v', 'x' }, '<leader>lf', vim.lsp.buf.format)
map('n', '<leader>v', ':e $MYVIMRC<CR>')
map('n', '<leader>z', ':e ~/.zshrc<CR>')
map({ 'v', 'x', 'n' }, '<C-y>', '"+y', { desc = 'System clipboard yank.' })
map({ 'i', 's' }, '<C-e>', function() ls.expand_or_jump(1) end, { silent = true })
map({ 'n', 'v' }, '<leader>n', ':norm ')
map({ 'x', 'n' }, '<C-s>', [[<esc>:'<,'>s/\V/]])
map('n', '<leader>fj', ':FzfLua files<CR>', { silent = true })
map('n', '<leader>so', ':FzfLua oldfiles<CR>', { silent = true })
map('n', '<leader>sh', ':FzfLua helptags<CR>', { silent = true })
map('n', '<leader>sm', ':FzfLua manpages<CR>', { silent = true })
map('n', '<leader>ss', ':FzfLua live_grep<CR>', { silent = true })
map('n', '<leader>cs', ':FzfLua colorschemes<CR>', { silent = true })
map('n', '<leader>cf', ':FzfLua files cwd=~/.config<CR>', { silent = true })
map('n', '<leader>gb', ':FzfLua git_bcommits<CR>', { silent = true })
map('n', '<leader>gs', ':FzfLua git_status<CR>', { silent = true })
map('n', '-', ':Oil<CR>', { silent = true })
map('n', '<esc>', ':nohlsearch <CR>', { silent = true })
map('n', '<leader>p', ':OmniPreview start<CR>', { silent = true })
map('n', '<leader>cd', '<Cmd>cd %:p:h<CR>', { silent = true })

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
vim.cmd("hi statusline guibg=NONE")
vim.cmd("hi statusline guifg=white")
vim.cmd("hi ModeMsg guifg=#cdcdcd")
vim.cmd("hi Cursor guifg=white guibg=white")

map("n", "<leader>a", function()
	vim.cmd("argadd %")
	vim.cmd("argdedup")
end)

map("n", "<leader>e", function()
	vim.cmd.args()
end)

map("n", "<leader>1", function()
	vim.cmd("silent! 1argument")
end)

map("n", "<leader>2", function()
	vim.cmd("silent! 2argument")
end)

map("n", "<leader>3", function()
	vim.cmd("silent! 3argument")
end)

map("n", "<leader>4", function()
	vim.cmd("silent! 4argument")
end)

map("n", "<leader>5", function()
	vim.cmd("silent! 5argument")
end)

map("n", "<leader>6", function()
	vim.cmd("silent! 6argument")
end)

vim.api.nvim_create_autocmd("FileType", {
	pattern = "typst",
	callback = function()
		map("n", "<leader>m", ":make<CR>:lua vim.fn.jobstart('zathura ' .. vim.fn.expand('%:r') .. '.pdf &')<CR><CR>",
			{ noremap = true, buffer = true })
	end,
})

