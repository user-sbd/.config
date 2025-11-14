if vim.g.neovide then
	vim.o.guifont = "JetBrainsMono Nerd Font:h25"
	vim.g.neovide_show_border = false
	vim.g.neovide_window_blurred = true
	vim.g.neovide_opacity = 1.0
	vim.opt.linespace = 0 -- No extra line spacing
	vim.g.neovide_scale_factor = 1.0 -- No UI scaling (since 0.10.2)
	vim.g.neovide_padding_top = 0 -- Zero padding (top/bottom/left/right; since 0.10.4)
	vim.g.neovide_padding_bottom = 0
	vim.g.neovide_padding_left = 0
	vim.g.neovide_padding_right = 0
end
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
vim.o.signcolumn = "yes:1"
vim.o.wrap = false

vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-mini/mini.pick" },
	{ src = "https://github.com/sphamba/smear-cursor.nvim" },
	-- LSP CONFIG
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/bluz71/vim-moonfly-colors" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	-- PREVIEWS
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/barrett-ruth/live-server.nvim" },
	{ src = "https://github.com/toppair/peek.nvim" },
	{ src = "https://github.com/SylvanFranklin/omni-preview.nvim" },
})

vim.cmd("colorscheme vague")
require("omni-preview").setup({})
require("live-server").setup({})
require("smear_cursor").setup({
	opts = {
		legacy_computing_symbols_support = false,
	},
})
require("peek").setup({ app = "browser" })
require("mason").setup()
require("oil").setup({ view_options = { show_hidden = true } })
require("mini.pick").setup({
	mappings = {
		choose = "<CR>",
		choose_in_vsplit = "<C-v>",
		mark = "<C-x>",
		move_down = "<C-n>",
		move_up = "<C-p>",
		stop = "<Esc>",
		toggle_preview = "<Tab>",
	},
})

require("mason-lspconfig").setup({
	ensure_installed = {
		"bashls",
		"clangd",
		"emmet_ls",
		"glsl_analyzer",
		"gopls",
		"html",
		"lua_ls",
		"marksman",
		"ruff",
		"rust_analyzer",
		"svelte",
		"tailwindcss",
		"tinymist",
		"jsonls",
	},
	automatic_installation = true,
	automatic_enable = true,
})

vim.g.mapleader = " "
local map = vim.keymap.set

map("n", "<C-l>", "<cmd>cnext<CR>")
map("n", "<leader>t", "<cmd>te<CR>")
map("n", "<C-h>", "<cmd>cprev<CR>")
map({ "n", "v", "x" }, "<leader>lf", vim.lsp.buf.format)
map("n", "<leader>v", ":e $MYVIMRC<CR>")
map("n", "<leader>z", ":e ~/.zshrc<CR>")
map({ "v", "x", "n" }, "<C-y>", '"+y')
map({ "n", "v" }, "<leader>n", ":norm ")
map("n", "<leader>fj", ":Pick files<CR>")
map("n", "<leader>sh", ":Pick help<CR>")
map("n", "<leader>fs", ":Pick grep_live<CR>")
map({ "x", "n" }, "<C-s>", [[<esc>:'<,'>s/\V/]])
map("n", "-", ":Oil<CR>", { silent = true })
map("n", "<esc>", ":nohlsearch <CR>", { silent = true })
map("n", "<leader>p", ":OmniPreview start<CR>", { silent = true })
map("n", "<leader>cd", "<Cmd>cd %:p:h<CR>", { silent = true })
map("n", "<leader>m", "<Cmd>make<CR>", { silent = true })
map("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
map("n", "<leader>l", [[<cmd>vertical resize +5<cr>]])
map("n", "<leader>h", [[<cmd>vertical resize -5<cr>]])

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

vim.cmd([[set completeopt=menu,menuone,noselect]])
vim.cmd("hi statusline guibg=NONE")
vim.cmd("hi statusline guifg=white")
vim.cmd("hi ModeMsg guifg=#cdcdcd")
vim.cmd("hi Cursor guifg=white guibg=white")

vim.api.nvim_create_autocmd("FileType", {
	pattern = "typst",
	callback = function()
		map(
			"n",
			"<leader>m",
			":make<CR>:lua vim.fn.jobstart('zathura ' .. vim.fn.expand('%:r') .. '.pdf &')<CR><CR>",
			{ noremap = true, buffer = true }
		)
	end,
})

vim.keymap.set("n", "<C-q>", ":copen<CR>", { silent = true })
for i = 1, 9 do
	vim.keymap.set("n", "<leader>" .. i, ":cc " .. i .. "<CR>", { noremap = true, silent = true })
end

vim.keymap.set("n", "<leader>a", function()
	local pos = vim.api.nvim_win_get_cursor(0)
	vim.fn.setqflist({
		{
			filename = vim.fn.expand("%"),
			lnum = pos[1],
			col = pos[2] + 1,
			text = vim.fn.expand("%"),
		},
	}, "a")
end)

vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*",
	group = vim.api.nvim_create_augroup("qf", { clear = true }),
	callback = function()
		if vim.bo.buftype == "quickfix" then
			vim.keymap.set("n", "<C-q>", ":ccl<cr>", { buffer = true, silent = true })
			vim.keymap.set("n", "dd", function()
				local idx = vim.fn.line(".")
				local qflist = vim.fn.getqflist()
				table.remove(qflist, idx)
				vim.fn.setqflist(qflist, "r")
			end, { buffer = true })
		end
	end,
})
vim.api.nvim_set_keymap("n", "<leader>m", "<cmd>make<CR>", { noremap = true, silent = true })
