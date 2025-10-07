vim.cmd([[set mouse=]])
vim.cmd([[set noswapfile]])

vim.opt.winborder = "rounded"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.cursorcolumn = false
vim.opt.ignorecase = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.guicursor = ""

vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/LinArcX/telescope-env.nvim" },
	{ src = "https://github.com/chentoast/marks.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/aznhe21/actions-preview.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter",        version = "master" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim",          version = "0.1.8" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
})

require "marks".setup {
	refresh_interval = 250,
	sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
	excluded_filetypes = {},
	excluded_buftypes = {},
	mappings = {}
}


local default_color = "vague"

require "mason".setup()
require "telescope".setup({
	defaults = {
		color_devicons = true,
		sorting_strategy = "ascending",
		borderchars = { "", "", "", "", "", "", "", "" },
		path_displays = "smart",
		layout_strategy = "horizontal",
		layout_config = {
			height = 100,
			width = 400,
			prompt_position = "top",
			preview_cutoff = 40,
		}
	}
})

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

require("actions-preview").setup {
	backend = { "telescope" },
	extensions = { "env" },
	telescope = vim.tbl_extend(
		"force",
		require("telescope.themes").get_dropdown(), {}
	)
}

vim.lsp.enable({
	"lua_ls", "cssls", "svelte", "tinymist",
	"rust_analyzer", "clangd", "ruff",
	"glsl_analyzer", "haskell-language-server", "hlint",
	"intelephense", "biome", "tailwindcss",
	"ts_ls", "emmet_language_server"
})

require("oil").setup({
	float = {
		max_width = 0.7,
		max_height = 0.6,
		border = "rounded",
	},
})

require "vague".setup({ transparent = true })
vim.cmd.colorscheme("vague")
require("luasnip").setup({ enable_autosnippets = true })
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })

local ls = require("luasnip")
local builtin = require("telescope.builtin")
local map = vim.keymap.set
local current = 1

function random_theme()
	local colors = vim.fn.getcompletion("", "color")
	-- print(#colors)
	-- for i, v in ipairs(colors) do
	-- 	print(v)
	-- end
	if current < #colors then
		current = current + 1
	else
		current = 1
	end
	local color = colors[current]
	-- print(current .. " " .. color)
	vim.t.color = color
	vim.cmd("colorscheme " .. color)
end

vim.g.mapleader = " "
map({ "n" }, "<leader>dk", function() random_theme() end)
map({ "i", "s" }, "<C-e>", function() ls.expand_or_jump(1) end, { silent = true })
map({ "i", "s" }, "<C-J>", function() ls.jump(1) end, { silent = true })
map({ "i", "s" }, "<C-K>", function() ls.jump(-1) end, { silent = true })
map({ "n", "v", "x" }, "<leader>v", "<Cmd>e $MYVIMRC<CR>", { desc = "Edit " .. vim.fn.expand("$MYVIMRC") })
map({ "n", "v", "x" }, "<leader>z", "<Cmd>e ~/.config/zsh/.zshrc<CR>", { desc = "Edit .zshrc" })
map({ "n", "v", "x" }, "<leader>n", ":norm ", { desc = "ENTER NORM COMMAND." })
map({ "n", "v", "x" }, "<C-s>", [[:s/\V]], { desc = "Enter substitue mode in selection" })
map({ "n", "v", "x" }, "<leader>lf", vim.lsp.buf.format, { desc = "Format current buffer" })
map({ "v", "x", "n" }, "<C-y>", '"+y', { desc = "System clipboard yank." })
map({ "n" }, "<leader>fj", builtin.find_files, { desc = "Telescope live grep" })
map({ "n" }, "<leader>lg", builtin.live_grep, { desc = "Telescope live grep" })
map({ "n" }, "<leader>si", builtin.grep_string, { desc = "Telescope live string" })
map({ "n" }, "<leader>rf", builtin.oldfiles, { desc = "Telescope buffers" })
map({ "n" }, "<leader>sh", builtin.help_tags, { desc = "Telescope help tags" })
map({ "n" }, "<leader>se", "<cmd>Telescope env<cr>", { desc = "Telescope tags" })
map({ "n" }, "<leader>sa", require("actions-preview").code_actions)
map({ "n" }, "-", "<cmd>Oil<CR>")
map({ "n" }, "<C-q>", ":copen<CR>", { silent = true })
map({ "n" }, "<C-f>", "<Cmd>Open .<CR>", { desc = "Open current directory in Finder." })

require "vague".setup({ transparent = true })
vim.cmd("colorscheme vague")
vim.cmd(":hi statusline guibg=NONE")
vim.cmd(":hi ModeMsg guifg=#cdcdcd")
vim.api.nvim_set_hl(0, 'MiniPickPrompt', { italic = false })
vim.api.nvim_set_hl(0, 'MiniPickBorderText', { fg = 'NONE' })
vim.api.nvim_set_hl(0, 'MiniPickBorderBusy', { fg = 'NONE' })

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

vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		vim.bo.makeprg = "python3 %"
	end
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "rust",
	callback = function()
		if vim.fn.filereadable("Cargo.toml") == 1 then
			vim.bo.makeprg = "cargo run"
		else
			vim.bo.makeprg = "rustc % && ./%:r"
		end
	end
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "cpp", "c" },
	callback = function()
		local extension = vim.fn.expand("%:e")
		local compiler = extension == "cpp" and "g++" or "gcc"
		vim.bo.makeprg = compiler .. " % -o %:r && ./%:r"
	end
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "cs",
	callback = function()
		vim.bo.makeprg = "dotnet run"
	end
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "typst",
	callback = function()
		vim.bo.makeprg = "typst compile % %:r.pdf"
	end
})

map("n", "<leader>m", ":make<CR>", { noremap = true })

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	pattern = "[^l]*",
	command = "nested cwindow"
})

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	pattern = "l*",
	command = "nested lwindow"
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "typst",
	callback = function()
		map("n", "<leader>m", ":make<CR>:lua vim.fn.jobstart('zathura ' .. vim.fn.expand('%:r') .. '.pdf &')<CR><CR>",
			{ noremap = true, buffer = true })
	end
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = function()
		vim.bo.makeprg = "lua %"
	end
})
