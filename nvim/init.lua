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
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/NeogitOrg/neogit" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/nvim-mini/mini.pick" },
})

vim.cmd("colo habamax")
require("mini.pick").setup({
  options = {
    content_from_bottom = false,
    use_cache = false,
  },
  window = {
    config = {
			height = 100,
			width = 100,
		},
    prompt_caret = '█',
    prompt_prefix = ' ',
  },
})

require("mason").setup()
require("oil").setup({
	view_options = { show_hidden = true },
	skip_confirm_for_simple_edits = true,
	delete_to_trash = true,
	buf_options = { buflisted = true },
	columns = {
		"mtime",
		"permissions",
		"size",
	},
	keymaps = {
		["<C-h>"] = false,
		["<C-j>"] = false,
		["<C-k>"] = false,
		["<C-l>"] = false,
		["<C-b>"] = false,
		["<C-n>"] = false,
		["<C-m>"] = false,
		["<C-,>"] = false,
	},
})

require("mason-lspconfig").setup({
	ensure_installed = {
		"bashls", "clangd", "emmet_ls", "glsl_analyzer", "gopls",
		"html", "lua_ls", "marksman", "ruff", "rust_analyzer",
		"svelte", "tailwindcss", "tinymist", "jsonls", "zk",
		"pyright", "pylsp",
	},
	automatic_installation = true,
	automatic_enable = true,
})

vim.g.mapleader = " "
local map = vim.keymap.set

map("n", "<C-f>", "<cmd>cd ~/.config | :Pick files <CR>")
map("n", "<leader>fj", "<cmd>Pick files <CR>")
map("n", "<leader><leader>", "<cmd>Pick files <CR>")
map("n", "<leader>fs", "<cmd>Pick grep_live<CR>")
map("n", "<leader>sh", "<cmd>Pick help<CR>")

map("n", "<leader>t", "<cmd>te<CR>")
map("n", "<leader>v", ":e $MYVIMRC<CR>")
map("n", "<leader>z", ":e ~/.zshrc<CR>")
map({ "v", "x", "n" }, "<C-y>", '"+y')
map({ "n", "v" }, "<leader>n", ":norm ")
map("n", "<leader>u", "<CMD>:Undotree<CR>")
map({ "n", "v", "x" }, "<leader>lf", vim.lsp.buf.format)
map("n", "-", ":Oil<CR>", { silent = true })
map("n", "<esc>", ":nohlsearch <CR>", { silent = true })
map("n", "<leader>cd", "<Cmd>cd %:p:h<CR>", { silent = true })
map("n", "<leader>m", "<Cmd>make<CR>", { silent = false })
map("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
map({ "t", "n" }, "<C-l>", "<Esc><cmd>next<CR>", { noremap = true, silent = true })
map({ "t", "n" }, "<C-h>", "<Esc><cmd>prev<CR>", { noremap = true, silent = true })
map("n", "<C-g>", function()
	require("neogit").open({ kind = "replace", cwd = vim.fn.expand("%:p:h") })
end)

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
vim.cmd("hi MiniPickBorderBusy guibg=NONE")
vim.cmd("hi MiniPickBorderText guibg=NONE")
vim.cmd("hi TelescopeSelection guibg=#cdcdcd")
vim.cmd("hi statusline guifg=WHITE")
vim.cmd("hi NormalFloat guibg=#1C1C1C")
vim.cmd("hi FloatBorder guifg=#NONE guibg=#NONE")
vim.cmd("hi ModeMsg guifg=#cdcdcd")
vim.cmd("hi ModeMsg guibg=NONE")
vim.cmd("hi WinSeparator guifg=NONE guibg=NONE gui=bold")
vim.cmd("hi StatusLineNC guifg=#737373 guibg=NONE gui=italic")

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

vim.cmd.packadd("nvim.undotree")
vim.api.nvim_create_autocmd("FileType", {
	pattern = "nvim-undotree",
	callback = function()
		vim.cmd.wincmd("H")
		vim.api.nvim_win_set_width(0, 80)
	end,
})

--- harpoon
map("n", "<leader>a", function()
	vim.cmd("argadd %")
	vim.cmd("argdedup")
end)
map("n", "<C-q>", function()
	vim.cmd.args()
end)
for i = 1, 9 do
	map("n", "<leader>" .. i, function()
		local args = vim.fn.argv()
		if #args >= i then
			vim.cmd("argument " .. i)
		end
	end)
end

