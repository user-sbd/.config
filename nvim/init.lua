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
vim.o.winborder = "rounded"
vim.o.statusline = "[%n] %<%f %w%m%r%=%-14.(%l,%c%V%) %P"
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim", version = "0.1.8" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/y9san9/y9nika.nvim" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/NeogitOrg/neogit" },
	{ src = "https://github.com/chentoast/marks.nvim" },
})

require'marks'.setup {
  default_mappings = true,
  builtin_marks = { ".", "<", ">", "^" },
}
require("telescope").setup({
	defaults = {
		preview = { treesitter = false },
		color_devicons = true,
		sorting_strategy = "ascending",
		borderchars = { "", "", "", "", "", "", "", "" },
		path_displays = { "smart" },
		layout_config = {
			height = 100,
			width = 400,
			prompt_position = "top",
			preview_cutoff = 40,
		},
	},
})

require("oil").setup({
	view_options = { show_hidden = true },
	skip_confirm_for_simple_edits = true,
	delete_to_trash = true,

	columns = { "type", "file", "mtime", "size", "icon" },
	win_options = { signcolumn = "yes:1" },
})

require("mason").setup()

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

vim.cmd("colorscheme y9nika")
vim.cmd("hi ModeMsg guifg=#cdcdcd")
vim.cmd("hi NormalFloat guibg=#111111")
vim.cmd("hi FloatBorder guibg=NONE")
vim.cmd("hi WinSeparator guifg=NONE guibg=NONE")

map("n", "<leader>h", function()
	vim.cmd("te zsh -i -c ollama-gemma")
	vim.cmd("argadd %")
end, { silent = true })

local builtin = require("telescope.builtin")
map({ "n" }, "<leader>so", builtin.oldfiles)
map({ "n" }, "<leader>f", builtin.find_files)
vim.keymap.set("n", "<leader>sc", function()
	vim.cmd("cd ~/.config")
	builtin.find_files()
end, { noremap = true })
map({ "n" }, "<leader>sh", builtin.help_tags)
map({ "n" }, "<leader>sr", builtin.lsp_references)
map({ "n" }, "<leader>st", builtin.builtin)
map({ "n" }, "<leader>sk", builtin.keymaps)

map("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
map({ "n" }, "<Esc>", "<cmd>nohlsearch<CR>")
map({ "n" }, "<leader>wv", "<cmd>VimwikiIndex<CR>")
map({ "n", "v", "x" }, "<leader>v", "<Cmd>edit $MYVIMRC<CR>", { desc = "Edit " .. vim.fn.expand("$MYVIMRC") })
map({ "n", "v", "x" }, "<leader>z", "<Cmd>e ~/.zshrc<CR>", { desc = "Edit .zshrc" })
map({ "n", "v", "x" }, "<leader>n", ":norm ")

map({ "n", "v", "x" }, "t", "'")
map({ "n", "v", "x" }, "<leader>lf", vim.lsp.buf.format, { desc = "Format current buffer" })
map({ "v", "x", "n" }, "<C-y>", '"+y', { desc = "System clipboard yank." })
map({ "n" }, "-", "<cmd>Oil<CR>")
map("n", "<C-g>", function()
	require("neogit").open({ kind = "replace", cwd = vim.fn.expand("%:p:h") })
end)

map("n", "<leader>a", function()
	vim.cmd("argadd %")
	vim.cmd("argdedup")
end)
map("n", "<C-q>", function()
	vim.cmd.args()
end)
