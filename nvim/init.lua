vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/tpope/vim-fugitive" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/nvim-flutter/flutter-tools.nvim" },
	{ src = "https://github.com/leafOfTree/vim-svelte-plugin" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/vague-theme/vague.nvim" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/vimpostor/vim-tpipeline" },
	{ src = "https://github.com/michaelb/sniprun" },
})

local opt = vim.opt
local map = vim.keymap.set

vim.cmd([[set mouse=]])
vim.cmd([[set noswapfile]])
opt.winborder = "rounded"
opt.tabstop = 2
opt.inccommand = "split"
opt.shiftwidth = 2
opt.cmdheight = 0
opt.signcolumn = "yes:1"
opt.wrap = false
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

require("fzf-lua").setup({
	fzf_args = {
		--color=fg:#d0d0d0,fg+:#d0d0d0,bg:#011627,bg+:#262626
		--color=hl:#FFFFFF,hl+:#5fd7ff,info:#FFFFFF,marker:#87ff00
		--color=prompt:#FFFFFF,spinner:#011627,pointer:#ffffff,header:#011627
		--color=gutter:#011627,border:#262626,separator:#011627,scrollbar:#011627
		--color=preview-scrollbar:#011627,label:#aeaeae,query:#d9d9d9
		--border="rounded" --border-label="" --preview-window="border-sharp" --prompt="> "
		--marker=" " --pointer="." --separator="─" --scrollbar="│"
	},
	fzf_opts = {
		["--ansi"] = true,
		["--info"] = "inline-right",
		["--height"] = "100%",
		["--border"] = "none",
	},
	winopts = {
		title_flags = false,
		height = 15,
		width = 50,
		row = 1,
		col = 0,
		border = { " ", " ", " ", " ", " ", " ", " ", " " },
		fullscreen = true,
		preview = {
			border = { "", "", "", "", "", "", "", "" },
			horizontal = "right:40%",
			layout = "horizontal",
		},
	},
	actions = {
		files = {
			["enter"]  = require("fzf-lua.actions").file_edit_or_qf,
			["ctrl-v"] = require("fzf-lua.actions").file_vsplit,
			["ctrl-q"] = require("fzf-lua.actions").file_sel_to_qf,
		},
	},
	files = { prompt = "> ", title = "f" },
	oldfiles = { prompt = "> " },
	previewers = { bat = true },
	file_icon_padding = "",
})

require("flutter-tools").setup {
	dev_log = {
		enabled = true,
		filter = nil,
		notify_errors = true,
		open_cmd = "10split",
		focus_on_open = false,
	}
}

require 'sniprun'.setup({
	display = { "VirtualTextOk", },
	live_display = { "VirtualLine" }, --# display mode used in live_mode
	cwd = '.',
	snipruncolors = {
		SniprunVirtualTextOk  = { bg = "#967aeb", fg = "#FFFFFF", ctermbg = "Cyan", ctermfg = "Yellow" },
		SniprunFloatingWinOk  = { fg = "NONE", ctermfg = "Cyan" },
		SniprunVirtualTextErr = { bg = "#967aeb", fg = "#FFFFFF", ctermbg = "DarkRed", ctermfg = "Yellow" },
		SniprunFloatingWinErr = { fg = "NONE", ctermfg = "DarkRed", bold = true },
	},
	live_mode_toggle = 'off',
})

require('nvim-treesitter').setup {
	install_dir = vim.fn.stdpath('data') .. '/site',
	ensure_installed = { "typescript", "css", "javascript", "svelte", "html" },
	highlight = {
		enable = true,
	},
}

require("oil").setup({
	default_file_explorer = true,
	columns = {
		"icon",
		"permissions",
		"size",
	},
	buf_options = { buflisted = true, },
	win_options = { signcolumn = "yes:1", },
	delete_to_trash = true,
	skip_confirm_for_simple_edits = true,
	constrain_cursor = "editable",
	keymaps = { ['<C-s>'] = false },

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

vim.lsp.enable({
	"rust_analyzer", "clangd", "ruff",
	"intelephense", "tailwindcss", "ts_ls",
	"emmet_language_server", "emmet_ls", "zls",
	"marksman", "bashls", "lua_ls",
	"cssls", "svelte", "tinymist",
	"basedpyright",
})

vim.cmd [[set completeopt+=menuone,noselect,popup]]

vim.cmd("colorscheme vague")
vim.cmd("hi ModeMsg guifg=#cdcdcd")
vim.cmd("hi StatusLine guifg=#FFFFFF guibg=none")
vim.cmd("hi SignColumn guibg=none")
vim.cmd("hi NormalFloat guibg=NONE ctermbg=NONE")
vim.cmd("hi FloatBorder guibg=NONE")
vim.cmd("hi WinSeparator guifg=NONE guibg=NONE")
vim.cmd("hi QuickFixLine guifg = #7AA2F7")
vim.cmd("hi Pmenu guibg=NONE")
vim.cmd("hi PmenuBorder guibg=NONE")
vim.cmd("hi ColorColumn guibg=NONE")
vim.cmd("hi LineNr guibg=NONE")

map('n', '<leader>s', function()
	vim.bo.buftype = nofile
	vim.bo.bufhidden = hide
end, { desc = "Eval selection" })

map('v', '<leader>e', '<CMD>SnipRun<CR>', { desc = "Eval selection" })
map('n', '<leader>e', '<CMD>SnipRunOperator<CR>', { desc = "Eval motion" })
map('n', '<leader>ee', '<CMD>SnipRun<CR>', { desc = "Eval line" })
map('n', '<leader>es', '<CMD>SnipClose<CR>', { desc = "Eval line" })

map("n", "<leader>f", ":FzfLua files<CR>", { silent = true })
map("n", "<leader>b", ":FzfLua buffers<CR>", { silent = true })
map("n", "<leader>o", ":FzfLua oldfiles<CR>", { silent = true })
map("n", "<leader>h", ":FzfLua helptags<CR>", { silent = true })
map("n", "<leader>g", ":FzfLua live_grep<CR>", { silent = true })
map("n", "<leader>t", ":FzfLua colorschemes<CR>", { silent = true })
map("n", "<leader>c", ":FzfLua files cwd=~/.config<CR>", { silent = true })

map("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
map({ "n", "v", "x" }, "<leader>v", "<Cmd>edit $MYVIMRC<CR>", { desc = "Edit " .. vim.fn.expand("$MYVIMRC") })
map({ "n" }, "<Esc>", "<Cmd>nohlsearch<CR>")
map({ "n", "v", "x" }, "<leader>z", "<Cmd>e ~/.zshrc<CR>", { desc = "Edit .zshrc" })
map({ "n", "v", "x" }, "<leader>n", ":norm ")
map({ "n", "v", "x" }, "<leader>lf", vim.lsp.buf.format, { desc = "Format current buffer" })
map({ "v", "x", "n" }, "<C-y>", '"+y', { desc = "System clipboard yank." })
map("n", "-", "<cmd>Oil<CR>")
map("n", "<C-g>", ":Git | only<CR>", { silent = true })
map("n", "<S-h>", "<Cmd>vertical resize -8<CR>", { desc = "Decrease width faster" })
map("n", "<S-l>", "<Cmd>vertical resize +8<CR>", { desc = "Increase width faster" })

map("n", "<C-q>", ":copen<CR>", { silent = true })
for i = 1, 9 do
	map('n', '<leader>' .. i, ':cc ' .. i .. '<CR>', { noremap = true, silent = true })
end

map("n", "<leader>a",
	function() vim.fn.setqflist({ { filename = vim.fn.expand("%"), lnum = 1, col = 1, text = vim.fn.expand("%"), } }, "a") end,
	{ desc = "Add current file to QuickFix" })

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


vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
})

local term_win = nil
local term_buf = nil

-- Make it global so ftplugins can call vim.fn.toggle_term()
_G.toggle_term = function()
	if term_win and vim.api.nvim_win_is_valid(term_win) then
		vim.api.nvim_win_hide(term_win)
		term_win = nil
		return true -- was visible → now hidden
	end

	local cwd = vim.fn.expand("%:p:h") -- use file's dir on creation (better default)

	if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
		vim.cmd("lcd " .. vim.fn.fnameescape(cwd) .. " | belowright 10split | terminal")
		term_buf = vim.api.nvim_get_current_buf()
		term_win = vim.api.nvim_get_current_win()
		vim.bo[term_buf].bufhidden = "hide"
		vim.bo[term_buf].filetype = "toggleterm"
	else
		vim.cmd("belowright 10split")
		term_win = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_buf(term_win, term_buf)
	end

	vim.cmd("startinsert")
	return true -- opened or shown
end

map({ "n", "t" }, "<C-s>", _G.toggle_term)
