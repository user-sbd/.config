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
vim.o.laststatus = 2
vim.o.cmdheight = 1
vim.o.splitright = true
vim.o.inccommand = "split"
vim.g.mapleader = " "

vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/NeogitOrg/neogit" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/folke/todo-comments.nvim" },
	{ src = "https://github.com/vague-theme/vague.nvim" },
	{ src = "https://github.com/nvim-mini/mini.statusline" },
})

local MiniStatusLine = require("mini.statusline")
MiniStatusLine.setup({ use_icons = vim.g.have_nerd_font })
---@diagnostic disable-next-line: duplicate-set-field
MiniStatusLine.section_location = function()
	return "%2l:%-2v"
end

require("vague").setup({ transparent = true })
vim.cmd("colo vague")
require("todo-comments").setup()
require("mason").setup()
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

require("fzf-lua").setup({
	fzf_opts = {
		["--info"] = "inline-right",
		["--height"] = "100%",
		["--layout"] = "reverse",
		["--border"] = "none",
	},
	winopts = {
		height = 15,
		width = 50,
		row = 1,
		col = 0,
		border = "rounded",
		fullscreen = false,
		preview = {
			border = "rounded",
			hidden = true,
			horizontal = "right:50%",
			layout = "horizontal",
		},
	},
	actions = {
		files = {
			["ctrl-q"] = function(selected_files)
				for _, file in ipairs(selected_files) do
					vim.cmd("argadd " .. file)
				end
			end,
			["enter"] = require("fzf-lua.actions").file_edit_or_qf,
			["ctrl-v"] = require("fzf-lua.actions").file_vsplit,
		},
	},
	files = { prompt = "> " },
	oldfiles = { prompt = "> " },
	previewers = { bat = true },
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
		"zk",
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

local map = vim.keymap.set

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
map("n", "<leader>v", ":e $MYVIMRC<CR>")
map("n", "<leader>z", ":e ~/.zshrc<CR>")
map({ "v", "x", "n" }, "<C-y>", '"+y')
map({ "n", "v" }, "<leader>n", ":norm ")
map({ "n", "v", "x" }, "<leader>lf", vim.lsp.buf.format)
map("n", "-", ":Oil<CR>", { silent = true })
map("n", "<leader>ft", "<cmd>TodoFzfLua<cr>")
map("n", "<leader>fj", ":FzfLua files<CR>", { silent = true })
map("n", "<leader>so", ":FzfLua oldfiles<CR>", { silent = true })
map("n", "<leader>sh", ":FzfLua helptags<CR>", { silent = true })
map("n", "<leader>fs", ":FzfLua live_grep<CR>", { silent = true })
map("n", "<leader>cs", ":FzfLua colorschemes<CR>", { silent = true })
map("n", "<leader>sc", ":FzfLua files cwd=~/.config<CR>", { silent = true })
map("n", "<leader>h", function()
	vim.cmd("te zsh -i -c ollama-gemma")
	vim.cmd("argadd %")
end, { silent = true })
map("n", "<esc>", ":nohlsearch <CR>", { silent = true })
map("n", "<leader>p", ":TypstPreview<CR>", { silent = true })
map("n", "<leader>cd", "<Cmd>cd %:p:h<CR>", { silent = true })
map("n", "<leader>m", "<Cmd>make<CR>", { silent = true })
map("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
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
vim.cmd("hi FzfLuaTitle guibg=NONE")
vim.cmd("hi FzfLuaFzfHeader guifg=NONE")
vim.cmd("hi ModeMsg guifg=#cdcdcd")
vim.cmd("hi NormalFloat guibg=#141415")
vim.cmd("hi FloatBorder guibg=#141415")
vim.cmd("hi WinSeparator guifg=NONE guibg=NONE")

vim.api.nvim_create_autocmd("FileType", {
	pattern = "typst",
	callback = function()
		map(
			"n",
			"<leader>m",
			":make<CR>:lua vim.fn.jobstart('sioyek' .. vim.fn.expand('%:r') .. '.pdf &')<CR><CR>",
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
	vim.keymap.set("n", "<leader>" .. i, function()
		local args = vim.fn.argv()
		if #args >= i then
			vim.cmd.argument(i)
		else
			vim.notify("No argument " .. i, vim.log.levels.WARN)
		end
	end, { desc = "Go to argument " .. i })
end
