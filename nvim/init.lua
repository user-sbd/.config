vim.cmd([[set mouse=]])
vim.cmd([[set noswapfile]])
vim.cmd([[hi @lsp.type.number gui=italic]])
vim.opt.winborder = "rounded"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.showtabline = 2
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.cursorcolumn = false
vim.opt.ignorecase = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.number = true

vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/chentoast/marks.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter",        version = "main" },
	{ src = "https://github.com/aznhe21/actions-preview.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim",          version = "0.1.8" },
	{ src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/NeogitOrg/neogit" },
})

vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'svelte', 'markdown', 'lua', 'rust', 'typst', 'typescript', 'javascript', 'c', 'cpp' },
	callback = function() vim.treesitter.start() end,
})

require "mason".setup()

local telescope = require("telescope")
local default_color = "vague"
telescope.setup({
	defaults = {
		preview = { treesitter = false },
		color_devicons = true,
		sorting_strategy = "ascending",
		borderchars = {
			"", -- top
			"", -- right
			"", -- bottom
			"", -- left
			"", -- top-left
			"", -- top-right
			"", -- bottom-right
			"", -- bottom-left
		},
		path_displays = { "smart" },
		layout_config = {
			height = 100,
			width = 400,
			prompt_position = "top",
			preview_cutoff = 40,
		}
	}
})
telescope.load_extension("ui-select")



vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method('textDocument/completion') then
			-- Optional: trigger autocompletion on EVERY keypress. May be slow!
			local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
			client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,
})

vim.cmd [[set completeopt+=menuone,noselect,popup]]

vim.lsp.enable({
	"lua_ls", "cssls", "svelte", "tinymist",
	"rust_analyzer", "clangd", "ruff",
	"glsl_analyzer", "haskell-language-server", "hlint",
	"intelephense", "tailwindcss", "ts_ls",
	"emmet_language_server", "emmet_ls", "solargraph", "zls"
})

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

require "vague".setup({ transparent = true })
require("luasnip").setup({ enable_autosnippets = true })
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })

local ls = require("luasnip")
local builtin = require("telescope.builtin")
local map = vim.keymap.set

vim.g.mapleader = " "

map({ "i", "s" }, "<C-e>", function() ls.expand_or_jump(1) end, { silent = true })
map({ "n", "t" }, "<Leader>t", "<Cmd>tabnew<CR>")
map({ "n", "t" }, "<Leader>x", "<Cmd>tabclose<CR>")

map({ "n", "v", "x" }, "<leader>v", "<Cmd>edit $MYVIMRC<CR>", { desc = "Edit " .. vim.fn.expand("$MYVIMRC") })
map({ "n", "v", "x" }, "<leader>z", "<Cmd>e .zshrc<CR>", { desc = "Edit .zshrc" })
map({ "n", "v", "x" }, "<leader>n", ":norm " )
map({ "n", "v", "x" }, "<leader>lf", vim.lsp.buf.format, { desc = "Format current buffer" })
map({ "v", "x", "n" }, "<C-y>", '"+y', { desc = "System clipboard yank." })
map({ "n" }, "<leader>f", builtin.find_files )

function git_files() builtin.find_files({ no_ignore = true }) end

function grep() builtin.live_grep({ additional_args = { "-e" } }) end

map({ "n" }, "<leader>g", grep)
map({ "n" }, "<leader>so", builtin.oldfiles)
map({ "n" }, "<leader>sh", builtin.help_tags)
map({ "n" }, "<leader>sm", builtin.man_pages)
map({ "n" }, "<leader>sr", builtin.lsp_references)
-- map({ "n" }, "<leader>si", builtin.lsp_implementations)
map({ "n" }, "<leader>st", builtin.builtin)
map({ "n" }, "<leader>sc", builtin.git_bcommits)
map({ "n" }, "<leader>sk", builtin.keymaps)
map({ "n" }, "<leader>se", "<cmd>Telescope env<cr>")
map({ "n" }, "-", "<cmd>Oil<CR>")
map({ "n" }, "<leader>c", "1z=")
map("n", "<C-g>", function()
	require("neogit").open({ kind = "replace", cwd = vim.fn.expand("%:p:h") })
end)

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
	map("n", "<leader>" .. i, function()
		local args = vim.fn.argv()
		if #args >= i then
			vim.cmd.argument(i)
		else
			vim.notify("No argument " .. i, vim.log.levels.WARN)
		end
	end, { desc = "Go to argument " .. i })
end

