vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim", version = "0.1.8" },
	{ src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/vague-theme/vague.nvim" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/tpope/vim-fugitive" },
})
local map = vim.keymap.set
local opt = vim.opt

vim.cmd([[set mouse=]])
vim.cmd([[set noswapfile]])
opt.makeprg = "./make.sh"
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
opt.pumborder = "rounded"
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("telescope").setup({
	pickers = { colorscheme = { enable_preview = true } },
	defaults = {
		preview = { treesitter = false },
		-- color_devicons = true,
		sorting_strategy = "ascending",
		-- borderchars = { "", "", "", "", "", "", "", "" },
		borderchars =  { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
		path_displays = { "tail" },
		layout_config = { height = 80, width = 390, prompt_position = "top", preview_cutoff = 40 },
	},
})
require('telescope').load_extension('fzf')

require("oil").setup({
	keymaps = { ["`"] = "actions.tcd" },
	delete_to_trash = true,
	skip_confirm_for_simple_edits = true,
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
	"lua_ls", "cssls", "svelte", "tinymist", "rust_analyzer", "clangd",
	"ruff", "glsl_analyzer", "intelephense", "tailwindcss", "emmet_language_server",
	"emmet_ls", "solargraph", "zls", "bash-language-server",
	"emmet-language-server", "glsl_analyzer", "gopls", "html-lsp", "json-lsp",
	"lua-language-server", "markdownlint-cli2", "marksman", "pyright",
	"python-lsp-server", "ruff", "rust-analyzer", "shfmt",
	"stylua", "svelte-language-server",
	"tailwindcss-language-server", "tinymist", "tree-sitter-cli", "zk",
})
vim.cmd("colorscheme vague")
vim.cmd("hi ModeMsg guifg=#cdcdcd")
vim.cmd("hi StatusLine guibg=none")
vim.cmd("hi NormalFloat guibg=NONE ctermbg=NONE")
vim.cmd("hi FloatBorder guibg=NONE")
vim.cmd("hi WinSeparator guifg=NONE guibg=NONE")
vim.cmd("hi QuickFixLine guifg = #7AA2F7")
vim.cmd("hi Pmenu guibg=NONE")
vim.cmd("hi PmenuBorder guibg=NONE")

map("n", "<leader>m", "<CMD>make<CR>", { silent = true })
map("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
map({ "n", "v", "x" }, "<leader>v", "<Cmd>edit $MYVIMRC<CR>", { desc = "Edit " .. vim.fn.expand("$MYVIMRC") })
map({ "n" }, "<Esc>", "<Cmd>nohlsearch<CR>")
map({ "n", "v", "x" }, "<leader>z", "<Cmd>e ~/.zshrc<CR>", { desc = "Edit .zshrc" })
map({ "n", "v", "x" }, "<leader>n", ":norm ")
map({ "n", "v", "x" }, "<leader>lf", vim.lsp.buf.format, { desc = "Format current buffer" })
map({ "v", "x", "n" }, "<C-y>", '"+y', { desc = "System clipboard yank." })

local builtin = require("telescope.builtin")
map("n", "<leader>ms", "<CMD>Telescope marks<CR>", { silent = true })
map({ "n" }, "<leader>f", builtin.find_files)
map({ "n" }, "<leader>sh", builtin.help_tags)
map({ "n" }, "<leader>g", builtin.live_grep)
map({ "n" }, "<leader>b", builtin.buffers)
map({ "n" }, "<leader>so", builtin.oldfiles)
map("n", "<leader>sc", function()
	vim.cmd("cd ~/.config")
	builtin.find_files()
end, { noremap = true })
map({ "n" }, "<leader>st", builtin.builtin)
map({ "n" }, "-", "<cmd>Oil<CR>")
map("n", "<C-g>", ":Git | only<CR>", { silent = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
})

map("n", "<leader>a", function()
	vim.cmd("argadd %")
	vim.cmd("argdedup")
end)
map("n", "<C-q>", function()
	vim.cmd.args()
end)
for i = 1, 9 do
	vim.keymap.set("n", "<leader>" .. i, function()
		local args = vim.fn.argv()
		if #args >= i then
			vim.cmd.argument(i)
		else
			vim.notify("No argument " .. i, vim.log.levels.WARN)
		end
	end, { desc = "Go to argument " .. i })
end
map("n", "<C-n>", ":if argidx() == argc() - 1 | first | else | next | endif<CR>", { silent = true })

local win = nil
local buf = nil

local function toggle_term()
	if win and vim.api.nvim_win_is_valid(win) then
		vim.api.nvim_win_hide(win)
		win = nil
		return
	end

	if not buf or not vim.api.nvim_buf_is_valid(buf) then
		vim.cmd("below split | terminal")
		buf = vim.api.nvim_get_current_buf()
		win = vim.api.nvim_get_current_win()
		vim.bo[buf].bufhidden = "hide"
	else
		vim.cmd("below split")
		win = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_buf(win, buf)
		vim.cmd("startinsert")
	end
end

vim.keymap.set("n", "<C-t>", toggle_term, {})
vim.keymap.set("t", "<C-t>", toggle_term, {})
