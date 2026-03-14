vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/vague-theme/vague.nvim" },
	{ src = "https://github.com/nvim-flutter/flutter-tools.nvim" },
	{ src = "https://github.com/leafOfTree/vim-svelte-plugin" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/tpope/vim-fugitive" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim"},
	{ src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"},
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/tpope/vim-surround" },
	{ src = "https://github.com/nvim-orgmode/orgmode" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
})

local opt = vim.opt
local map = vim.keymap.set

vim.cmd([[set mouse=]])
vim.cmd([[set noswapfile]])
opt.winborder = "rounded"
opt.tabstop = 2
opt.showtabline = 2
opt.inccommand = "split"
opt.shiftwidth = 2
opt.cmdheight = 1
opt.signcolumn = "yes:1"
opt.wrap = false
opt.ignorecase = true
opt.smartindent = true
opt.termguicolors = true
opt.undofile = true
opt.number = true
opt.guicursor = ""
opt.winborder = "rounded"
opt.pumborder = "rounded"
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require('telescope').setup({
	extensions = {
    fzf = { fuzzy = true, override_generic_sorter = true, override_file_sorter = true, case_mode = "smart_case", } },
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
require('telescope').load_extension('fzf')

require("flutter-tools").setup {
	dev_log = {
		enabled = true, filter = nil,
		notify_errors = true, open_cmd = "10split",
		focus_on_open = false,
	}
}

require('typst-preview').setup {
	-- invert_colors = 'always', --
}

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
	},
	buf_options = { buflisted = true, },
	win_options = { signcolumn = "yes:1", },
	delete_to_trash = true,
	skip_confirm_for_simple_edits = true,
	constrain_cursor = "editable",
	keymaps = {
		['<C-s>'] = false,
    ["<C-t>"] = { "actions.select", opts = { tab = true } },
    ["g\\"] = { "actions.toggle_trash", mode = "n" },
  },
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
	"emmet-language-server", "zls",
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
vim.cmd("hi LineNr guibg=NONE")
vim.cmd("hi TabLine guibg=NONE")

require("luasnip").setup({ enable_autosnippets = true })
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })
local ls = require("luasnip")

map({ "i", "s" }, "<C-e>", function() ls.expand_or_jump(1) end, { silent = true })
map({ "i", "s" }, "<C-J>", function() ls.jump(1) end, { silent = true })
map({ "i", "s" }, "<C-K>", function() ls.jump(-1) end, { silent = true })

map("n", "<leader>f", "<CMD>Telescope find_files<CR>", { silent = true })
map("n", "<C-f>", "<CMD> Telescope find_files<CR>", { silent = true })
map("n", "<C-b>", "<CMD>Telescope buffers<CR>", { silent = true })
map("n", "<leader>of", "<CMD>Telescope oldfiles<CR>", { silent = true })
map("n", "<leader>h", "<CMD>Telsecope helptags<CR>", { silent = true })
map("n", "<leader>gs", "<CMD>Telescope live_grep<CR>", { silent = true })
map("n", "<leader>c", "<CMD>cd ~/.config | Telescope find_files<CR>", { silent = true })
map("n", "<leader>sn", "<CMD>cd ~/Documents/notes | Telescope find_files<CR>", { silent = true })

map("n", "<leader>a", "<CMD>Org agenda<CR>a", { silent = true })
map("n", "<leader>t", "<CMD>Org capture<CR>t", { silent = true })

map("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
map({ "n", "v", "x" }, "<leader>v", "<Cmd>edit $MYVIMRC<CR>", { desc = "Edit " .. vim.fn.expand("$MYVIMRC") })
map({ "n" }, "<Esc>", "<Cmd>nohlsearch<CR>")
map({ "n", "v", "x" }, "<leader>z", "<Cmd>e ~/.zshrc<CR>", { desc = "Edit .zshrc" })
map({ "n", "v", "x" }, "<leader>n", ":norm ")
map({ "n", "v", "x" }, "<leader>lf", vim.lsp.buf.format, { desc = "Format current buffer" })
map({ "v", "x", "n" }, "<C-y>", '"+y', { desc = "System clipboard yank." })
map("n", "-", "<cmd>Oil<CR>")
map("n", "<C-g>", ":Git | only<CR>", { silent = true })

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
local term_job_id = nil

_G.toggle_term = function()
	if term_win and vim.api.nvim_win_is_valid(term_win) then
		vim.api.nvim_win_hide(term_win)
		term_win = nil
		return
	end
	local cwd
	if vim.bo.filetype == "oil" or vim.b.oil then
		cwd = require("oil").get_current_dir(0)
	else
		cwd = vim.fn.expand("%:p:h")
	end
	if not cwd or cwd == "" then
		cwd = vim.fn.getcwd()
	end
	if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
		vim.cmd("belowright 10split | terminal")
		term_buf = vim.api.nvim_get_current_buf()
		term_win = vim.api.nvim_get_current_win()
		term_job_id = vim.b.terminal_job_id
		vim.bo[term_buf].bufhidden = "hide"
		vim.bo[term_buf].filetype = "toggleterm"
		vim.api.nvim_create_autocmd("BufDelete", {
			buffer = term_buf,
			callback = function()
				term_buf = nil
				term_win = nil
				term_job_id = nil
			end,
			once = true
		})
	else
		vim.cmd("belowright 10split")
		term_win = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_buf(term_win, term_buf)
	end
	vim.fn.chdir(cwd)
	if term_job_id and vim.fn.jobwait({ term_job_id }, 0) == -1 then
		vim.fn.chansend(term_job_id, "cd " .. vim.fn.fnameescape(cwd) .. "\n")
	end
	vim.cmd("startinsert")
end

_G.run_in_terminal = function(cmd)
	vim.cmd("write")
	_G.toggle_term()
	vim.defer_fn(function()
		if term_job_id and vim.fn.jobwait({ term_job_id }, 0) == -1 then
			vim.fn.chansend(term_job_id, cmd .. "\n")
		else
			vim.api.nvim_feedkeys(cmd .. "\r", "t", false)
		end
		vim.cmd("startinsert")
	end, 50)
end
vim.keymap.set({ "n", "t" }, "<C-s>", _G.toggle_term, { desc = "Toggle terminal" })
vim.keymap.set("n", "<leader>m", function()
	local cmd = vim.b.run_command
	if cmd then
		_G.run_in_terminal(cmd)
	else
		vim.notify("No run command for " .. vim.bo.filetype, vim.log.levels.WARN)
	end
end)

local function wget_in_proper_dir(args)
	local dir
	if vim.bo.filetype == "oil" then
		local ok, oil = pcall(require, "oil")
		if ok then
			dir = oil.get_current_dir(0)
		end
	end
	if not dir or dir == "" then
		dir = vim.fn.expand("%:p:h")
		if dir == "" or dir == "." then
			dir = vim.fn.getcwd()
		end
	end
	vim.notify("wget → " .. dir, vim.log.levels.INFO)
	local safe_dir = vim.fn.shellescape(dir)
	vim.cmd("!wget -P " .. safe_dir .. " " .. args)
end
vim.api.nvim_create_user_command("Wget", function(opts)
	wget_in_proper_dir(opts.args)
end, {
	nargs = "+",
	desc = "wget with explicit dir (file / oil / fallback)",
})
vim.cmd('cabbrev wget Wget')

map({ "n", "t" }, "<leader>x", "<Cmd>tabclose<CR>")
map({ "n", "t" }, "<C-x>", "<Cmd>tabclose<CR>")
map({ "n", "t" }, "<C-t>", "<Cmd>tabnew<CR>")
map("n", "<C-n>", "<CMD>tabnext<CR>")
map("n", "<C-p>", "<CMD>tabprevious<CR>")
for i = 1, 8 do
	map({ "n", "t" }, "<Leader>" .. i, "<Cmd>tabnext " .. i .. "<CR>")
end

require('orgmode').setup({
	org_agenda_files = '~/Documents/notes/agendas/**/*',
	org_default_notes_file = '~/Documents/notes/agendas/main.org',
})

vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })

