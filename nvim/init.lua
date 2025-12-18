vim.cmd([[set mouse=]])
vim.cmd([[set noswapfile]])
vim.o.winborder = "rounded"
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.cmdheight = 1
vim.o.signcolumn = "yes"
vim.o.wrap = false
vim.o.cursorcolumn = false
vim.o.ignorecase = true
vim.o.smartindent = true
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.guicursor = ""
vim.g.mapleader = " "
vim.o.winborder = "rounded"
vim.g.maplocalleader = " "
vim.o.statusline = "[%n] %<%f %w%m%r%=%-14.(%l,%c%V%) %P"

local map = vim.keymap.set

vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/chentoast/marks.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/aznhe21/actions-preview.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim", version = "0.1.8" },
	{ src = "https://github.com/y9san9/y9nika.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/NeogitOrg/neogit" },
	{ src = "https://github.com/vimwiki/vimwiki" },
	{ src = "https://github.com/comfysage/artio.nvim" },
})


require("vim._extui").enable({})
require("artio").setup({
  opts = {
    preselect = true,
    bottom = true,
    promptprefix = "$",
    prompt_title = false,
    pointer = ".",
    use_icons = false,
  },
  win = {
    height = 10,
    hidestatusline = false,
  },
  mappings = {
    ["<C-n>"] = "down",
    ["<C-p>"] = "up",
    ["<cr>"] = "accept",
    ["<C-c>"] = "cancel",
    ["<Esc>"] = "cancel",
    ["<tab>"] = "mark",
    ["<c-l>"] = "togglepreview",
  },
})
vim.ui.select = require("artio").select
map("n", "<leader>fj", "<Plug>(artio-files)")
map("n", "<leader>sc", "<CMD>cd ~/.config<CR> <Plug>(artio-files)")
map("n", "<leader>sd", "<Plug>(artio-diagnostics)")
map("n", "<leader>sh", "<Plug>(artio-helptags)")
map("n", "<leader>sb", "<Plug>(artio-buffers)")
map("n", "<leader>sg", "<Plug>(artio-buffergrep)")
map("n", "<leader>so", "<Plug>(artio-oldfiles)")
map("n", "<leader>cs", "<Plug>(artio-colorschemes)")
map("n", "<leader>fh", "<Plug>(artio-highlights)")

require("mason").setup()
vim.cmd("let g:vimwiki_list = [{'path': '~/Documents/notes/wiki'}]")
vim.cmd([[
let g:vimwiki_list = [{'path': '~/Documents/notes/wiki',
	\ 'syntax': 'markdown', 'ext': 'md'}]
]])

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("my.lsp", {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method("textDocument/completion") then
			local chars = {}
			for i = 32, 126 do
				table.insert(chars, string.char(i))
			end
			client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,
})

vim.cmd([[set completeopt+=menuone,noselect,popup]])

vim.lsp.enable({
	"lua_ls",
	"cssls",
	"svelte",
	"tinymist",
	"rust_analyzer",
	"clangd",
	"ruff",
	"glsl_analyzer",
	"intelephense",
	"tailwindcss",
	"emmet_language_server",
	"emmet_ls",
	"solargraph",
	"zls",
	"bash-language-server",
	"clangd",
	"emmet-language-server",
	"glsl_analyzer",
	"gopls",
	"html-lsp",
	"json-lsp",
	"lua-language-server",
	"markdownlint-cli2",
	"marksman",
	"pyright",
	"python-lsp-server",
	"ruff",
	"rust-analyzer",
	"shfmt",
	"stylua",
	"svelte-language-server",
	"tailwindcss-language-server",
	"tinymist",
	"tree-sitter-cli",
	"zk",
})

require("oil").setup({
	view_options = { show_hidden = true },
	skip_confirm_for_simple_edits = true,
	delete_to_trash = true,
	columns = {
		"permissions",
		"type",
		"file",
		"mtime",
		"size",
	},
	win_options = { signcolumn = "yes:1" },
})

vim.cmd("colorscheme y9nika-monoaccent")
vim.cmd("hi ModeMsg guifg=#cdcdcd")
vim.cmd("hi NormalFloat guibg=#111111")
vim.cmd("hi FloatBorder guibg=#141415")
vim.cmd("hi WinSeparator guifg=NONE guibg=NONE")

require("vague").setup({ transparent = true })

local builtin = require("telescope.builtin")

map("n", "<C-n>", function()
	local argc = vim.fn.argc()
	if argc == 0 then
		return
	end
	local argidx = vim.fn.argidx()
	if argidx == argc - 1 then
		vim.cmd("rewind")
	else
		vim.cmd("next")
	end
end, { noremap = true, silent = true })
map("n", "<leader>h", function()
	vim.cmd("te zsh -i -c ollama-gemma")
	vim.cmd("argadd %")
end, { silent = true })
map("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
map({ "n" }, "<Esc>", "<cmd>nohlsearch<CR>")
map({ "n" }, "<leader>wv", "<cmd>VimwikiIndex<CR>")
map({ "n", "v", "x" }, "<leader>v", "<Cmd>edit $MYVIMRC<CR>", { desc = "Edit " .. vim.fn.expand("$MYVIMRC") })
map({ "n", "v", "x" }, "<leader>z", "<Cmd>e ~/.zshrc<CR>", { desc = "Edit .zshrc" })
map({ "n", "v", "x" }, "<leader>n", ":norm ")
map({ "n", "v", "x" }, "<leader>lf", vim.lsp.buf.format, { desc = "Format current buffer" })
map({ "v", "x", "n" }, "<C-y>", '"+y', { desc = "System clipboard yank." })
map({ "n" }, "-", "<cmd>Oil<CR>")
map({ "n" }, "<leader>c", "1z=")
map("n", "<C-g>", function()
	require("neogit").open({ kind = "replace", cwd = vim.fn.expand("%:p:h") })
end)

--- harpoon
map("n", "<leader>a", function()
	vim.cmd("argadd %")
	vim.cmd("argdedup")
end)
map("n", "<C-q>", function()
	vim.cmd.args()
end)
