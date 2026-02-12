vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/ellisonleao/gruvbox.nvim" },
	{ src = "https://github.com/tpope/vim-fugitive" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-flutter/flutter-tools.nvim" },
	{ src = "https://github.com/leafOfTree/vim-svelte-plugin" },
})

local opt = vim.opt
local map = vim.keymap.set
local builtin = require("telescope.builtin")

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

require("flutter-tools").setup {
	dev_log = {
		enabled = true,
		filter = nil,
		notify_errors = true,
		open_cmd = "10split",
		focus_on_open = false,
	}
}

local telescope = require("telescope")
telescope.setup({
	defaults = {
		preview = { treesitter = true },
		color_devicons = true,
		sorting_strategy = "ascending",
		borderchars = { "", "", "", "", "", "", "", "", },
		path_displays = { "smart" },
		layout_config = {
			height = 100,
			width = 400,
			prompt_position = "top",
			preview_cutoff = 40,
		}
	}
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
	use_default_keymaps = true,
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

vim.cmd("colorscheme gruvbox")
vim.cmd("hi ModeMsg guifg=#cdcdcd")
vim.cmd("hi StatusLine guifg=#FFFFFF guibg=none")
vim.cmd("hi SignColumn guibg=none")
vim.cmd("hi NormalFloat guibg=NONE ctermbg=NONE")
vim.cmd("hi FloatBorder guibg=NONE")
vim.cmd("hi WinSeparator guifg=NONE guibg=NONE")
vim.cmd("hi QuickFixLine guifg = #7AA2F7")
vim.cmd("hi Pmenu guibg=NONE")
vim.cmd("hi PmenuBorder guibg=NONE")

map("n", "<leader>f", builtin.find_files, { desc = "Telescope live grep" })
map({ "n", "i" }, "<C-f>", builtin.find_files)
map("n", "<leader>g", builtin.live_grep)
map("n", "<leader>o", builtin.oldfiles)
map("n", "<leader>h", builtin.help_tags)
map("n", "<leader>sm", builtin.man_pages)
map("n", "<leader>b", builtin.buffers)
map({ "n" }, "<leader>st", builtin.builtin)
map('n', '<leader>c', function() require('telescope.builtin').find_files({ cwd = vim.fn.expand('~/.config') }) end)

map("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
map({ "n", "v", "x" }, "<leader>v", "<Cmd>edit $MYVIMRC<CR>", { desc = "Edit " .. vim.fn.expand("$MYVIMRC") })
map({ "n" }, "<Esc>", "<Cmd>nohlsearch<CR>")
map({ "n", "v", "x" }, "<leader>z", "<Cmd>e ~/.zshrc<CR>", { desc = "Edit .zshrc" })
map({ "n", "v", "x" }, "<leader>n", ":norm ")
map({ "n", "v", "x" }, "<leader>lf", vim.lsp.buf.format, { desc = "Format current buffer" })
map({ "v", "x", "n" }, "<C-y>", '"+y', { desc = "System clipboard yank." })

map("n", "-", "<cmd>Oil<CR>")
map("n", "<C-g>", ":Git | only<CR>", { silent = true })

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

local function toggle_term()
	if term_win and vim.api.nvim_win_is_valid(term_win) then
		vim.api.nvim_win_hide(term_win)
		term_win = nil
		return
	end
	if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
		vim.cmd("lcd %:p:h | belowright 10split | terminal")

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
end

map({ "n", "t" }, "<leader>t", toggle_term)

map('n', "<C-t>", "<CMD>FlutterLogToggle<CR><esc>")

vim.keymap.set("n", "<S-h>", "<Cmd>vertical resize -8<CR>", { desc = "Decrease width faster" })
vim.keymap.set("n", "<S-l>", "<Cmd>vertical resize +8<CR>", { desc = "Increase width faster" })
