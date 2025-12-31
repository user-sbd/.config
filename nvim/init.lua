vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim", version = "0.1.8" },
	{ src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/bluz71/vim-moonfly-colors" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/tpope/vim-fugitive" },
	{ src = "https://github.com/walkersumida/fusen.nvim" },
})
local map = vim.keymap.set
local opt = vim.opt

vim.cmd([[set mouse=]])
vim.cmd([[set noswapfile]])
opt.winborder = "rounded"
opt.tabstop = 2
opt.inccommand = "split"
opt.showtabline = 0
opt.shiftwidth = 2
opt.cmdheight = 1
opt.signcolumn = "yes:1"
opt.wrap = false
opt.cursorcolumn = false
opt.ignorecase = true
opt.smartindent = true
opt.termguicolors = true
opt.undofile = true
opt.number = true
opt.relativenumber = true
opt.guicursor = ""
opt.statusline = "[%n] %<%f %w%m%r%=%-14.(%l,%c%V%) "
opt.winborder = "rounded"
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("telescope").setup({
	pickers = { colorscheme = { enable_preview = true } },
	defaults = {
		preview = { treesitter = false },
		color_devicons = true,
		sorting_strategy = "ascending",
		borderchars = { "", "", "", "", "", "", "", "" },
		path_displays = { "smart" },
		layout_config = { height = 100, width = 400, prompt_position = "top", preview_cutoff = 40 },
	},
})
require("telescope").load_extension("fzf")

require("oil").setup({
	keymaps = { ["`"] = "actions.tcd" },
	delete_to_trash = true,
	skip_confirm_for_simple_edits = true,
	win_options = { signcolumn = "yes:1" },
})

require("fusen").setup({
	save_file = vim.fn.expand("$HOME") .. "/.config/nvim/fusen_marks.json",
	mark = {
		icon = "",
		hl_group = "DiagnosticError",
	},
	keymaps = {
		add_mark = "<C-m>",
		clear_mark = "dm",
		clear_buffer = "mC",
		clear_all = "mD",
		next_mark = "]q",
		prev_mark = "[q",
		list_marks = "ml",
	},
	annotation_display = {
		mode = "eol",
		spacing = 4,
	},
	enabled = true,
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

vim.cmd("colorscheme moonfly")
-- vim.cmd("colorscheme unokai")
-- vim.cmd("colorscheme ")
vim.cmd("hi ModeMsg guifg=#cdcdcd")
vim.cmd("hi StatusLine guibg=none")
vim.cmd("hi NormalFloat guibg=NONE ctermbg=NONE")
vim.cmd("hi FloatBorder guibg=NONE")
vim.cmd("hi WinSeparator guifg=NONE guibg=NONE")
vim.cmd("hi QuickFixLine guifg = #7AA2F7")

vim.cmd([[
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
]])

map("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })

map({ "n", "v", "x" }, "<leader>v", "<Cmd>edit $MYVIMRC<CR>", { desc = "Edit " .. vim.fn.expand("$MYVIMRC") })
map(
	{ "n", "v", "x" },
	"<leader>td",
	"<Cmd>edit /Users/nitin/Documents/DO.typ<CR>",
	{ desc = "Edit " .. vim.fn.expand("$MYVIMRC") }
)
map({ "n" }, "<Esc>", "<Cmd>nohlsearch<CR>")
map({ "n", "v", "x" }, "<leader>z", "<Cmd>e ~/.zshrc<CR>", { desc = "Edit .zshrc" })
map({ "n", "v", "x" }, "<leader>n", ":norm ")
map({ "n", "v", "x" }, "<leader>lf", vim.lsp.buf.format, { desc = "Format current buffer" })
map({ "v", "x", "n" }, "<C-y>", '"+y', { desc = "System clipboard yank." })

local builtin = require("telescope.builtin")
map({ "n" }, "<leader>f", builtin.find_files)
map({ "n" }, "<leader>sm", builtin.marks)
map({ "n" }, "<leader>sh", builtin.help_tags)
map({ "n" }, "<leader>g", builtin.live_grep)
map({ "n" }, "<leader>b", builtin.buffers)
map({ "n" }, "<leader>so", builtin.oldfiles)
map("n", "<leader>sc", function()
	vim.cmd("cd ~/.config")
	builtin.find_files()
end, { noremap = true })
map({ "n" }, "<leader>st", builtin.builtin)
map("n", "<C-p>", ":bnext<CR>", { silent = true })
map("n", "<C-n>", ":bprevious<CR>", { silent = true })
map({ "n" }, "-", "<cmd>Oil<CR>")
map("n", "<C-g>", ":Git | only<CR>", { silent = true })
map("n", "<C-s>", "<CMD>te<CR>")

map("n", "<C-q>", ":copen<CR>", { silent = true })
for i = 1, 9 do
	map("n", "<leader>" .. i, ":cc " .. i .. "<CR>", { noremap = true, silent = true })
end
map("n", "<leader>a", function()
	local pos = vim.api.nvim_win_get_cursor(0)
	vim.fn.setqflist(
		{ { filename = vim.fn.expand("%"), lnum = pos[1], col = pos[2] + 1, text = vim.fn.expand("%:t") } },
		"a"
	)
end)
vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*",
	group = vim.api.nvim_create_augroup("qf", { clear = true }),
	callback = function()
		if vim.bo.buftype == "quickfix" then
			vim.wo.number = false
			vim.wo.relativenumber = false
			vim.wo.signcolumn = "no"
			map("n", "<C-q>", ":ccl<cr>", { buffer = true, silent = true })
			map("n", "dd", function()
				local idx = vim.fn.line(".")
				local qflist = vim.fn.getqflist()
				table.remove(qflist, idx)
				vim.fn.setqflist(qflist, "r")
			end, { buffer = true })
		end
	end,
})

