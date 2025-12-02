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
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/NeogitOrg/neogit" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/vague-theme/vague.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
})

vim.cmd("colorscheme vague")
-- vim.cmd("colorscheme default")

require("mason").setup()
require("oil").setup({
	view_options = { show_hidden = true },
	skip_confirm_for_simple_edits = true,
	delete_to_trash = true,
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

local actions = require("fzf-lua.actions")
require("fzf-lua").setup({
  fzf_colors = true,
  winopts = {
    height     = 1,
    width      = 1,
    row        = 0,
    col        = 0,
    border     = "single",
    fullscreen = true,
    preview    = {
      vertical = "right:45%",
    },
    title      = "",
  },
  actions = {
    files = {
      ["enter"]   = actions.file_edit_or_qf,
      ["ctrl-v"]  = actions.file_vsplit,
      ["ctrl-q"]   = actions.file_arg
    },
  },
  files = {
    prompt = "> ",
  },
  oldfiles = {
    prompt = "> ",
  },
  previewers = {
    bat = true,
  },
  file_icon_padding = "",
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
		"zk",
	},
	automatic_installation = true,
	automatic_enable = true,
})

vim.g.mapleader = " "
local map = vim.keymap.set

map("n", "<C-l>", "<cmd>cnext<cr>")
map("n", "<C-h>", "<cmd>cprev<CR>")
map("n", "<leader>t", "<cmd>te<CR>")
map("n", "<leader>v", ":e $MYVIMRC<CR>")
map("n", "<leader>z", ":e ~/.zshrc<CR>")
map({ "v", "x", "n" }, "<C-y>", '"+y')
map({ "n", "v" }, "<leader>n", ":norm ")
map("n", "<leader>u", "<CMD>:Undotree<CR>")
map({ "n", "v", "x" }, "<leader>lf", vim.lsp.buf.format)
map("n", "-", ":Oil<CR>", { silent = true })
map("n", "<leader>fj", ":FzfLua files<CR>", { silent = true })
map("n", "<leader>so", ":FzfLua oldfiles<CR>", { silent = true })
map("n", "<leader>sh", ":FzfLua helptags<CR>", { silent = true })
map("n", "<leader>ss", ":FzfLua live_grep<CR>", { silent = true })
map("n", "<leader>cs", ":FzfLua colorschemes<CR>", { silent = true })
map("n", "<leader>sc", ":FzfLua files cwd=~/.config<CR>", { silent = true })
map("n", "<esc>", ":nohlsearch <CR>", { silent = true })
map("n", "<leader>p", ":TypstPreview<CR>", { silent = true })
map("n", "<leader>cd", "<Cmd>cd %:p:h<CR>", { silent = true })
map("n", "<leader>m", "<Cmd>make<CR>", { silent = true })
map("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
map("t", "<C-l>", "<Esc><cmd>cnext<CR>", { noremap = true, silent = true })
map("t", "<C-h>", "<Esc><cmd>cprev<CR>", { noremap = true, silent = true })
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


